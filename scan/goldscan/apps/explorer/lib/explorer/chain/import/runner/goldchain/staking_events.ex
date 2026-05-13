defmodule Explorer.Chain.Import.Runner.Goldchain.StakingEvents do
  @moduledoc """
  Bulk imports `t:Explorer.Chain.Goldchain.StakingEvent.t/0`.
  """

  require Ecto.Query

  import Ecto.Query, only: [from: 2]

  alias Ecto.{Changeset, Multi, Repo}
  alias Explorer.Chain.Goldchain.StakingEvent
  alias Explorer.Chain.Import
  alias Explorer.Prometheus.Instrumenter

  @behaviour Import.Runner

  # milliseconds
  @timeout 60_000

  @type imported :: [StakingEvent.t()]

  @impl Import.Runner
  def ecto_schema_module, do: StakingEvent

  @impl Import.Runner
  def option_key, do: :goldchain_staking_events

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

    Multi.run(multi, :insert_goldchain_staking_events, fn repo, _ ->
      Instrumenter.block_import_stage_runner(
        fn -> insert(repo, changes_list, insert_options) end,
        :block_referencing,
        :goldchain_staking_events,
        :goldchain_staking_events
      )
    end)
  end

  @impl Import.Runner
  def timeout, do: @timeout

  @spec insert(Repo.t(), [map()], %{required(:timeout) => timeout(), required(:timestamps) => Import.timestamps()}) ::
          {:ok, [StakingEvent.t()]}
          | {:error, [Changeset.t()]}
  def insert(repo, changes_list, %{timeout: timeout, timestamps: timestamps} = options) when is_list(changes_list) do
    on_conflict = Map.get_lazy(options, :on_conflict, &default_on_conflict/0)

    ordered_changes_list =
      Enum.sort_by(changes_list, fn item ->
        {item[:block_number] || 0, item[:log_index] || 0}
      end)

    {:ok, inserted} =
      Import.insert_changes_list(
        repo,
        ordered_changes_list,
        conflict_target: [:event_id],
        on_conflict: on_conflict,
        for: StakingEvent,
        returning: true,
        timeout: timeout,
        timestamps: timestamps
      )

    {:ok, inserted}
  end

  defp default_on_conflict do
    from(
      se in StakingEvent,
      update: [
        set: [
          transaction_hash: fragment("COALESCE(EXCLUDED.transaction_hash, ?)", se.transaction_hash),
          log_index: fragment("COALESCE(EXCLUDED.log_index, ?)", se.log_index),
          block_number: fragment("COALESCE(EXCLUDED.block_number, ?)", se.block_number),
          block_timestamp: fragment("COALESCE(EXCLUDED.block_timestamp, ?)", se.block_timestamp),
          event_type: fragment("COALESCE(EXCLUDED.event_type, ?)", se.event_type),
          operator_address_hash: fragment("COALESCE(EXCLUDED.operator_address_hash, ?)", se.operator_address_hash),
          delegator_address_hash: fragment("COALESCE(EXCLUDED.delegator_address_hash, ?)", se.delegator_address_hash),
          src_validator_address_hash:
            fragment("COALESCE(EXCLUDED.src_validator_address_hash, ?)", se.src_validator_address_hash),
          dst_validator_address_hash:
            fragment("COALESCE(EXCLUDED.dst_validator_address_hash, ?)", se.dst_validator_address_hash),
          gilt_amount: fragment("COALESCE(EXCLUDED.gilt_amount, ?)", se.gilt_amount),
          shares: fragment("COALESCE(EXCLUDED.shares, ?)", se.shares),
          old_shares: fragment("COALESCE(EXCLUDED.old_shares, ?)", se.old_shares),
          new_shares: fragment("COALESCE(EXCLUDED.new_shares, ?)", se.new_shares),
          reward_amount: fragment("COALESCE(EXCLUDED.reward_amount, ?)", se.reward_amount),
          finality_status: fragment("COALESCE(EXCLUDED.finality_status, ?)", se.finality_status),
          metadata: fragment("COALESCE(EXCLUDED.metadata, ?)", se.metadata),
          inserted_at: fragment("LEAST(?, EXCLUDED.inserted_at)", se.inserted_at),
          updated_at: fragment("GREATEST(?, EXCLUDED.updated_at)", se.updated_at)
        ]
      ],
      where:
        fragment(
          "(EXCLUDED.transaction_hash, EXCLUDED.log_index, EXCLUDED.block_number, EXCLUDED.block_timestamp, EXCLUDED.event_type, EXCLUDED.operator_address_hash, EXCLUDED.delegator_address_hash, EXCLUDED.src_validator_address_hash, EXCLUDED.dst_validator_address_hash, EXCLUDED.gilt_amount, EXCLUDED.shares, EXCLUDED.old_shares, EXCLUDED.new_shares, EXCLUDED.reward_amount, EXCLUDED.finality_status, EXCLUDED.metadata) IS DISTINCT FROM (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
          se.transaction_hash,
          se.log_index,
          se.block_number,
          se.block_timestamp,
          se.event_type,
          se.operator_address_hash,
          se.delegator_address_hash,
          se.src_validator_address_hash,
          se.dst_validator_address_hash,
          se.gilt_amount,
          se.shares,
          se.old_shares,
          se.new_shares,
          se.reward_amount,
          se.finality_status,
          se.metadata
        )
    )
  end
end
