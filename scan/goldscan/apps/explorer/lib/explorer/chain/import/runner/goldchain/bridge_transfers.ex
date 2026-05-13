defmodule Explorer.Chain.Import.Runner.Goldchain.BridgeTransfers do
  @moduledoc """
  Bulk imports `t:Explorer.Chain.Goldchain.BridgeTransfer.t/0`.
  """

  require Ecto.Query

  import Ecto.Query, only: [from: 2, where: 3]

  alias Ecto.{Changeset, Multi, Repo}
  alias Explorer.Chain.Goldchain.BridgeTransfer
  alias Explorer.Chain.Import
  alias Explorer.Prometheus.Instrumenter

  @behaviour Import.Runner

  # milliseconds
  @timeout 60_000

  @type imported :: [BridgeTransfer.t()]

  @impl Import.Runner
  def ecto_schema_module, do: BridgeTransfer

  @impl Import.Runner
  def option_key, do: :goldchain_bridge_transfers

  @impl Import.Runner
  def imported_table_row do
    %{
      value_type: "[#{ecto_schema_module()}.t()]",
      value_description: "List of `t:#{ecto_schema_module()}.t/0`s"
    }
  end

  @impl Import.Runner
  def run(multi, changes_list, %{timestamps: timestamps} = options) do
    insert_options =
      options
      |> Map.get(option_key(), %{})
      |> Map.take(~w(on_conflict timeout)a)
      |> Map.put_new(:timeout, @timeout)
      |> Map.put(:timestamps, timestamps)

    Multi.run(multi, :insert_goldchain_bridge_transfers, fn repo, _ ->
      Instrumenter.block_import_stage_runner(
        fn -> insert(repo, changes_list, insert_options) end,
        :block_referencing,
        :goldchain_bridge_transfers,
        :goldchain_bridge_transfers
      )
    end)
  end

  @impl Import.Runner
  def timeout, do: @timeout

  @spec insert(Repo.t(), [map()], %{required(:timeout) => timeout(), required(:timestamps) => Import.timestamps()}) ::
          {:ok, [BridgeTransfer.t()]}
          | {:error, [Changeset.t()]}
  def insert(repo, changes_list, %{timeout: timeout, timestamps: timestamps} = options) when is_list(changes_list) do
    on_conflict = Map.get_lazy(options, :on_conflict, &default_on_conflict/0)

    ordered_changes_list =
      Enum.sort_by(changes_list, fn item ->
        {
          item[:canonical_transfer_id] || "",
          item[:block_number] || 0,
          item[:log_index] || 0
        }
      end)

    merged_changes_list = merge_with_existing(repo, ordered_changes_list)

    {:ok, inserted} =
      Import.insert_changes_list(
        repo,
        merged_changes_list,
        conflict_target: [:event_id],
        on_conflict: on_conflict,
        for: BridgeTransfer,
        returning: true,
        timeout: timeout,
        timestamps: timestamps
      )

    {:ok, inserted}
  end

  defp default_on_conflict do
    from(
      bt in BridgeTransfer,
      update: [
        set: [
          canonical_transfer_id: fragment("EXCLUDED.canonical_transfer_id"),
          cross_chain_transfer_id: fragment("EXCLUDED.cross_chain_transfer_id"),
          transaction_hash: fragment("EXCLUDED.transaction_hash"),
          root_transaction_hash: fragment("EXCLUDED.root_transaction_hash"),
          child_transaction_hash: fragment("EXCLUDED.child_transaction_hash"),
          log_index: fragment("EXCLUDED.log_index"),
          block_number: fragment("EXCLUDED.block_number"),
          root_block_number: fragment("EXCLUDED.root_block_number"),
          child_block_number: fragment("EXCLUDED.child_block_number"),
          root_log_index: fragment("EXCLUDED.root_log_index"),
          child_log_index: fragment("EXCLUDED.child_log_index"),
          block_timestamp: fragment("EXCLUDED.block_timestamp"),
          source_layer: fragment("EXCLUDED.source_layer"),
          direction: fragment("EXCLUDED.direction"),
          bridge_state: fragment("EXCLUDED.bridge_state"),
          finality_status: fragment("EXCLUDED.finality_status"),
          route_asset: fragment("EXCLUDED.route_asset"),
          account_address_hash: fragment("EXCLUDED.account_address_hash"),
          counterparty_address_hash: fragment("EXCLUDED.counterparty_address_hash"),
          root_token_address_hash: fragment("EXCLUDED.root_token_address_hash"),
          contract_address_hash: fragment("EXCLUDED.contract_address_hash"),
          child_token_id: fragment("EXCLUDED.child_token_id"),
          root_amount: fragment("EXCLUDED.root_amount"),
          child_amount: fragment("EXCLUDED.child_amount"),
          metadata: fragment("EXCLUDED.metadata"),
          inserted_at: fragment("LEAST(?, EXCLUDED.inserted_at)", bt.inserted_at),
          updated_at: fragment("GREATEST(?, EXCLUDED.updated_at)", bt.updated_at)
        ]
      ]
    )
  end

  defp merge_with_existing(_repo, []), do: []

  defp merge_with_existing(repo, changes_list) do
    event_ids =
      changes_list
      |> Enum.map(& &1.event_id)
      |> Enum.reject(&is_nil/1)
      |> Enum.uniq()

    existing_by_event_id =
      BridgeTransfer
      |> where([bt], bt.event_id in ^event_ids)
      |> repo.all()
      |> Map.new(&{&1.event_id, &1})

    Enum.map(changes_list, fn incoming ->
      case Map.get(existing_by_event_id, incoming.event_id) do
        nil -> incoming
        existing -> merge_transfer(existing, incoming)
      end
    end)
  end

  defp merge_transfer(existing, incoming) do
    mismatch? = mismatch?(existing, incoming)
    route_asset = incoming.route_asset || existing.route_asset
    direction = incoming.direction || existing.direction

    representative =
      choose_representative(
        %{
          bridge_state: existing.bridge_state,
          block_number: existing.block_number,
          log_index: existing.log_index,
          transaction_hash: existing.transaction_hash,
          source_layer: existing.source_layer
        },
        %{
          bridge_state: incoming.bridge_state,
          block_number: incoming.block_number,
          log_index: incoming.log_index,
          transaction_hash: incoming.transaction_hash,
          source_layer: incoming.source_layer
        }
      )

    merged_metadata =
      existing.metadata
      |> merge_metadata(incoming.metadata)
      |> maybe_mark_disputed(mismatch?)

    merged_transfer = %{
      event_id: incoming.event_id,
      canonical_transfer_id: incoming.canonical_transfer_id || existing.canonical_transfer_id,
      cross_chain_transfer_id: incoming.cross_chain_transfer_id || existing.cross_chain_transfer_id,
      transaction_hash: representative.transaction_hash || incoming.transaction_hash || existing.transaction_hash,
      root_transaction_hash: incoming.root_transaction_hash || existing.root_transaction_hash,
      child_transaction_hash: incoming.child_transaction_hash || existing.child_transaction_hash,
      log_index: representative.log_index,
      block_number: representative.block_number,
      root_block_number: incoming.root_block_number || existing.root_block_number,
      child_block_number: incoming.child_block_number || existing.child_block_number,
      root_log_index: incoming.root_log_index || existing.root_log_index,
      child_log_index: incoming.child_log_index || existing.child_log_index,
      block_timestamp: incoming.block_timestamp || existing.block_timestamp,
      source_layer: representative.source_layer || incoming.source_layer || existing.source_layer,
      direction: direction,
      bridge_state: pick_bridge_state(existing.bridge_state, incoming.bridge_state),
      finality_status: pick_finality_status(existing.finality_status, incoming.finality_status),
      route_asset: route_asset,
      account_address_hash: incoming.account_address_hash || existing.account_address_hash,
      counterparty_address_hash: incoming.counterparty_address_hash || existing.counterparty_address_hash,
      root_token_address_hash: incoming.root_token_address_hash || existing.root_token_address_hash,
      contract_address_hash: incoming.contract_address_hash || existing.contract_address_hash,
      child_token_id: incoming.child_token_id || existing.child_token_id,
      root_amount: incoming.root_amount || existing.root_amount,
      child_amount: incoming.child_amount || existing.child_amount,
      metadata: merged_metadata
    }

    {bridge_state, finality_status} =
      derive_bridge_state_and_finality(
        merged_transfer,
        existing,
        incoming,
        mismatch?
      )

    %{merged_transfer | bridge_state: bridge_state, finality_status: finality_status}
  end

  defp maybe_mark_disputed(metadata, false), do: metadata
  defp maybe_mark_disputed(metadata, true), do: Map.put(metadata, "correlation_status", "disputed")

  defp derive_bridge_state_and_finality(_merged, _existing, _incoming, true), do: {:failed, :disputed}

  defp derive_bridge_state_and_finality(merged, existing, incoming, false) do
    if reverted_leg?(existing, incoming) do
      {:failed, :reverted}
    else
      flags = finalized_leg_flags(merged.metadata)
      observed_legs = observed_legs(merged.metadata)
      direction = merged.direction || infer_direction(observed_legs)

      cond do
        direction == :deposit and flags.finalized_root_lock and flags.finalized_child_mint_or_credit ->
          {:minted_or_credited, :finalized}

        direction == :withdrawal and flags.finalized_child_burn_or_debit and flags.finalized_root_release ->
          {:released, :finalized}

        direction == :withdrawal and
            (flags.finalized_child_burn_or_debit or flags.finalized_root_release or
               observed_leg?(observed_legs, "child_burn_or_debit") or observed_leg?(observed_legs, "root_release")) ->
          {:burned_or_debited, :pending}

        direction == :deposit and
            (flags.finalized_child_mint_or_credit or flags.finalized_child_synced or
               observed_leg?(observed_legs, "child_mint_or_credit") or observed_leg?(observed_legs, "child_synced")) ->
          {:synced, :pending}

        direction == :deposit and (flags.finalized_root_lock or observed_leg?(observed_legs, "root_lock")) ->
          {:locked, :pending}

        true ->
          {merged.bridge_state || :locked, :pending}
      end
    end
  end

  defp finalized_leg_flags(metadata) when is_map(metadata) do
    %{
      finalized_root_lock: truthy?(metadata_value(metadata, :finalized_root_lock, "finalized_root_lock")),
      finalized_child_synced: truthy?(metadata_value(metadata, :finalized_child_synced, "finalized_child_synced")),
      finalized_child_mint_or_credit:
        truthy?(
          metadata_value(
            metadata,
            :finalized_child_mint_or_credit,
            "finalized_child_mint_or_credit"
          )
        ),
      finalized_child_burn_or_debit:
        truthy?(
          metadata_value(
            metadata,
            :finalized_child_burn_or_debit,
            "finalized_child_burn_or_debit"
          )
        ),
      finalized_root_release: truthy?(metadata_value(metadata, :finalized_root_release, "finalized_root_release"))
    }
  end

  defp finalized_leg_flags(_),
    do: %{
      finalized_root_lock: false,
      finalized_child_synced: false,
      finalized_child_mint_or_credit: false,
      finalized_child_burn_or_debit: false,
      finalized_root_release: false
    }

  defp observed_legs(metadata) when is_map(metadata) do
    metadata
    |> metadata_value(:observed_legs, "observed_legs")
    |> case do
      legs when is_list(legs) -> legs |> Enum.map(&to_string/1) |> Enum.uniq()
      _ -> []
    end
  end

  defp observed_legs(_), do: []

  defp observed_leg?(legs, expected) when is_list(legs),
    do: Enum.any?(legs, fn leg -> to_string(leg) == expected end)

  defp observed_leg?(_, _), do: false

  defp infer_direction(observed_legs) do
    if observed_leg?(observed_legs, "child_burn_or_debit") or observed_leg?(observed_legs, "root_release") do
      :withdrawal
    else
      :deposit
    end
  end

  defp reverted_leg?(existing, incoming),
    do: existing.finality_status == :reverted or incoming.finality_status == :reverted

  defp metadata_value(map, atom_key, string_key) do
    Map.get(map, atom_key, Map.get(map, string_key))
  end

  defp truthy?(value), do: value in [true, "true", 1, "1"]

  defp merge_metadata(existing, incoming) when is_map(existing) and is_map(incoming) do
    merged = Map.merge(existing, incoming)
    leg_keys = [
      {:finalized_root_lock, "finalized_root_lock"},
      {:finalized_child_synced, "finalized_child_synced"},
      {:finalized_child_mint_or_credit, "finalized_child_mint_or_credit"},
      {:finalized_child_burn_or_debit, "finalized_child_burn_or_debit"},
      {:finalized_root_release, "finalized_root_release"}
    ]

    merged_with_flags =
      Enum.reduce(leg_keys, merged, fn {atom_key, string_key}, acc ->
        value =
          truthy?(metadata_value(existing, atom_key, string_key)) or
            truthy?(metadata_value(incoming, atom_key, string_key))

        Map.put(acc, string_key, value)
      end)

    observed =
      (observed_legs(existing) ++ observed_legs(incoming))
      |> Enum.uniq()

    merged_with_flags
    |> Map.put("observed_legs", observed)
    |> Map.put(
      "route_consistency",
      merge_consistency(
        metadata_value(existing, :route_consistency, "route_consistency"),
        metadata_value(incoming, :route_consistency, "route_consistency")
      )
    )
    |> Map.put(
      "amount_consistency",
      merge_consistency(
        metadata_value(existing, :amount_consistency, "amount_consistency"),
        metadata_value(incoming, :amount_consistency, "amount_consistency")
      )
    )
  end

  defp merge_metadata(existing, nil) when is_map(existing), do: existing
  defp merge_metadata(nil, incoming) when is_map(incoming), do: incoming
  defp merge_metadata(_, _), do: %{}

  defp mismatch?(existing, incoming) do
    mismatched_field?(existing.route_asset, incoming.route_asset) or
      mismatched_field?(existing.direction, incoming.direction) or
      mismatched_field?(existing.account_address_hash, incoming.account_address_hash) or
      mismatched_field?(existing.counterparty_address_hash, incoming.counterparty_address_hash) or
      mismatched_field?(existing.root_token_address_hash, incoming.root_token_address_hash) or
      mismatched_field?(existing.cross_chain_transfer_id, incoming.cross_chain_transfer_id) or
      mismatched_field?(existing.child_token_id, incoming.child_token_id) or
      mismatched_field?(existing.root_amount, incoming.root_amount) or
      mismatched_field?(existing.child_amount, incoming.child_amount)
  end

  defp mismatched_field?(nil, _), do: false
  defp mismatched_field?(_, nil), do: false
  defp mismatched_field?(left, right), do: left != right

  defp pick_bridge_state(existing, incoming) do
    existing_rank = bridge_state_rank(existing)
    incoming_rank = bridge_state_rank(incoming)
    if incoming_rank >= existing_rank, do: incoming, else: existing
  end

  defp bridge_state_rank(:locked), do: 1
  defp bridge_state_rank(:synced), do: 2
  defp bridge_state_rank(:minted_or_credited), do: 3
  defp bridge_state_rank(:burned_or_debited), do: 4
  defp bridge_state_rank(:released), do: 5
  defp bridge_state_rank(:failed), do: 6
  defp bridge_state_rank(_), do: 0

  defp pick_finality_status(existing, incoming) do
    existing_rank = finality_rank(existing)
    incoming_rank = finality_rank(incoming)
    if incoming_rank >= existing_rank, do: incoming, else: existing
  end

  defp finality_rank(:pending), do: 1
  defp finality_rank(:finalized), do: 2
  defp finality_rank(:reverted), do: 3
  defp finality_rank(:disputed), do: 4
  defp finality_rank(_), do: 0

  defp choose_representative(existing, incoming) do
    existing_rank = bridge_state_rank(existing.bridge_state)
    incoming_rank = bridge_state_rank(incoming.bridge_state)

    cond do
      incoming_rank > existing_rank -> incoming
      incoming_rank < existing_rank -> existing
      (incoming.block_number || 0) > (existing.block_number || 0) -> incoming
      (incoming.block_number || 0) < (existing.block_number || 0) -> existing
      (incoming.log_index || 0) >= (existing.log_index || 0) -> incoming
      true -> existing
    end
  end

  defp merge_consistency(left, right) do
    left_value = normalize_consistency(left)
    right_value = normalize_consistency(right)

    cond do
      left_value == "disputed" or right_value == "disputed" -> "disputed"
      right_value == "ok" -> "ok"
      left_value == "ok" -> "ok"
      true -> "unknown"
    end
  end

  defp normalize_consistency(value) when value in ["ok", :ok], do: "ok"
  defp normalize_consistency(value) when value in ["disputed", :disputed], do: "disputed"
  defp normalize_consistency(_), do: "unknown"
end
