defmodule Indexer.Fetcher.Goldchain.BridgeRoot do
  @moduledoc """
  Indexes finalized root-side bridge events for Gold Chain into typed bridge transfer records.
  """

  use GenServer
  use Indexer.Fetcher

  require Logger

  import Ecto.Query, only: [from: 2]

  import EthereumJSONRPC, only: [quantity_to_integer: 1]

  alias EthereumJSONRPC.Logs
  alias Explorer.Chain
  alias Explorer.Chain.Goldchain.BridgeTransfer
  alias Explorer.Chain.Goldchain.Profile
  alias Explorer.Repo
  alias Indexer.Helper
  alias Indexer.Transform.Addresses
  alias Indexer.Transform.Goldchain.Lifecycle, as: GoldchainLifecycle

  @fetcher_name :goldchain_bridge_root
  @eth_get_logs_range_size 1_000
  @boot_delay_ms 2_000

  def child_spec(start_link_arguments) do
    spec = %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, start_link_arguments},
      restart: :transient,
      type: :worker
    }

    Supervisor.child_spec(spec, [])
  end

  def start_link(args, gen_server_options \\ []) do
    GenServer.start_link(__MODULE__, args, Keyword.put_new(gen_server_options, :name, __MODULE__))
  end

  @impl GenServer
  def init(_args) do
    {:ok, %{}, {:continue, :ok}}
  end

  @impl GenServer
  def handle_continue(:ok, state) do
    Logger.metadata(fetcher: @fetcher_name)
    Process.send_after(self(), :init_with_delay, @boot_delay_ms)
    {:noreply, state}
  end

  @impl GenServer
  def handle_info(:init_with_delay, _state) do
    if Application.get_env(:explorer, :chain_type) != :goldchain do
      {:stop, :normal, %{}}
    else
      profile = Application.get_env(:explorer, Profile, [])

      root_rpc = Keyword.get(profile, :root_rpc)
      root_start_block = Keyword.get(profile, :root_start_block, 0)
      poll_interval = Keyword.get(profile, :poll_interval, 5_000)
      root_finality_confirmations = Keyword.get(profile, :root_finality_confirmations, 64)
      root_bridge_contracts = Keyword.get(profile, :root_bridge_contracts, [])
      root_topics = root_event_topics(profile)

      with true <- is_binary(root_rpc),
           true <- is_integer(root_start_block) and root_start_block >= 0,
           true <- is_integer(poll_interval) and poll_interval > 0,
           true <- is_integer(root_finality_confirmations) and root_finality_confirmations > 0,
           true <- is_list(root_bridge_contracts) and root_bridge_contracts != [],
           true <- root_topics != [] do
        json_rpc_named_arguments = Helper.json_rpc_named_arguments(root_rpc)
        {:ok, latest_root_block} =
          Helper.get_block_number_by_tag("latest", json_rpc_named_arguments, Helper.infinite_retries_number())

        finalized_head = max(latest_root_block - root_finality_confirmations, 0)
        last_imported_root_block = last_imported_root_block()
        start_block = max(root_start_block, last_imported_root_block + 1)

        Process.send(self(), :continue, [])

        {:noreply,
         %{
           json_rpc_named_arguments: json_rpc_named_arguments,
           root_start_block: root_start_block,
           start_block: start_block,
           root_topics: root_topics,
           root_bridge_contracts: root_bridge_contracts,
           poll_interval: poll_interval,
           root_finality_confirmations: root_finality_confirmations,
           latest_finalized_head: finalized_head
         }}
      else
        _ ->
          Logger.error("Goldchain root bridge fetcher configuration is invalid.")
          {:stop, :normal, %{}}
      end
    end
  end

  @impl GenServer
  def handle_info(
        :continue,
        %{
          json_rpc_named_arguments: json_rpc_named_arguments,
          root_start_block: root_start_block,
          start_block: start_block,
          root_topics: root_topics,
          root_bridge_contracts: root_bridge_contracts,
          poll_interval: poll_interval,
          root_finality_confirmations: root_finality_confirmations,
          latest_finalized_head: latest_finalized_head
        } = state
      ) do
    {:ok, latest_root_block} =
      Helper.get_block_number_by_tag("latest", json_rpc_named_arguments, Helper.infinite_retries_number())

    finalized_head = max(latest_root_block - root_finality_confirmations, 0)

    {new_start_block, delay} =
      if start_block <= finalized_head do
        replay_from = max(root_start_block, start_block - root_finality_confirmations)
        observed_transfer_ids =
          import_root_range(replay_from, finalized_head, root_bridge_contracts, root_topics, json_rpc_named_arguments)

        mark_reverted_root_window(replay_from, finalized_head, observed_transfer_ids)
        {finalized_head + 1, 0}
      else
        {start_block, poll_interval}
      end

    Process.send_after(self(), :continue, delay)

    {:noreply,
     %{
       state
       | start_block: new_start_block,
         latest_finalized_head: max(latest_finalized_head, finalized_head)
     }}
  end

  @impl GenServer
  def handle_info({ref, _result}, state) do
    Process.demonitor(ref, [:flush])
    {:noreply, state}
  end

  defp import_root_range(
         replay_from,
         finalized_head,
         root_bridge_contracts,
         root_topics,
         json_rpc_named_arguments
       ) do
    replay_from..finalized_head
    |> Helper.range_chunk_every(@eth_get_logs_range_size)
    |> Enum.reduce(MapSet.new(), fn chunk_start..chunk_end, observed_transfer_ids ->
      Helper.log_blocks_chunk_handling(chunk_start, chunk_end, replay_from, finalized_head, nil, :L1)

      logs =
        chunk_start
        |> fetch_logs_for_chunk(chunk_end, root_bridge_contracts, root_topics, json_rpc_named_arguments)
        |> Logs.elixir_to_params()

      updated_observed_transfer_ids =
        if logs != [] do
          blocks = blocks_for_logs(logs, json_rpc_named_arguments)

          transfers =
            blocks
            |> GoldchainLifecycle.parse(logs)
            |> Map.get(:bridge_transfers, [])
            |> Enum.filter(&(&1.source_layer == :root))
            |> Enum.map(&Map.put(&1, :finality_status, :finalized))

          observed_transfer_ids =
            Enum.reduce(transfers, observed_transfer_ids, fn transfer, acc ->
              MapSet.put(acc, transfer.canonical_transfer_id)
            end)

          addresses =
            Addresses.extract_addresses(%{
              goldchain_bridge_transfers: transfers
            })

          {:ok, _} =
            Chain.import(%{
              addresses: %{params: addresses, on_conflict: :nothing},
              goldchain_bridge_transfers: %{params: transfers},
              timeout: :infinity
            })

          observed_transfer_ids
        else
          observed_transfer_ids
        end

      Helper.log_blocks_chunk_handling(
        chunk_start,
        chunk_end,
        replay_from,
        finalized_head,
        "#{Enum.count(logs)} root bridge log(s)",
        :L1
      )

      updated_observed_transfer_ids
    end)
  end

  defp fetch_logs_for_chunk(chunk_start, chunk_end, root_bridge_contracts, root_topics, json_rpc_named_arguments) do
    Enum.flat_map(root_bridge_contracts, fn contract ->
      {:ok, raw_logs} =
        Helper.get_logs(
          chunk_start,
          chunk_end,
          contract,
          [root_topics],
          json_rpc_named_arguments,
          0,
          Helper.infinite_retries_number()
        )

      raw_logs
    end)
  end

  defp blocks_for_logs(logs, _json_rpc_named_arguments) when logs == [], do: []

  defp blocks_for_logs(logs, json_rpc_named_arguments) do
    logs
    |> Enum.map(fn log ->
      %{"blockNumber" => log.block_number}
    end)
    |> Helper.get_blocks_by_events(json_rpc_named_arguments, Helper.infinite_retries_number())
    |> Enum.map(fn block ->
      %{
        number: quantity_to_integer(block["number"]),
        timestamp: block["timestamp"] |> quantity_to_integer() |> Helper.timestamp_to_datetime()
      }
    end)
  end

  defp root_event_topics(profile) do
    bridge_topics = Keyword.get(profile, :bridge_topics, %{})

    root_lock_topics = bridge_topics |> Map.get(:root_lock, []) |> normalize_topics()
    root_release_topics = bridge_topics |> Map.get(:root_release, []) |> normalize_topics()
    child_synced_topics = bridge_topics |> Map.get(:child_synced, []) |> normalize_topics()

    (root_lock_topics ++ root_release_topics ++ child_synced_topics)
    |> Enum.uniq()
  end

  defp normalize_topics(topic) when is_binary(topic), do: [String.downcase(topic)]
  defp normalize_topics(topics) when is_list(topics) do
    topics
    |> Enum.filter(&is_binary/1)
    |> Enum.map(&String.downcase/1)
  end
  defp normalize_topics(_), do: []

  defp last_imported_root_block do
    query =
      from(bt in BridgeTransfer,
        where: not is_nil(bt.root_block_number),
        select: max(bt.root_block_number)
      )

    Repo.one(query) || -1
  end

  defp mark_reverted_root_window(replay_from, finalized_head, observed_transfer_ids)
       when replay_from <= finalized_head do
    query =
      if MapSet.size(observed_transfer_ids) == 0 do
        from(bt in BridgeTransfer,
          where:
            bt.root_block_number >= ^replay_from and bt.root_block_number <= ^finalized_head and
              bt.finality_status not in [:reverted, :disputed]
        )
      else
        from(bt in BridgeTransfer,
              where:
            bt.root_block_number >= ^replay_from and bt.root_block_number <= ^finalized_head and
              bt.canonical_transfer_id not in ^MapSet.to_list(observed_transfer_ids) and
              bt.finality_status not in [:reverted, :disputed]
        )
      end

    query
    |> Repo.update_all(set: [finality_status: :reverted, bridge_state: :failed])

    :ok
  end

  defp mark_reverted_root_window(_, _, _), do: :ok
end
