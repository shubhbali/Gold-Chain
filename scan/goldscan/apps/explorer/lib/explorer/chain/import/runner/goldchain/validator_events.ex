defmodule Explorer.Chain.Import.Runner.Goldchain.ValidatorEvents do
  @moduledoc """
  Bulk imports `t:Explorer.Chain.Goldchain.ValidatorEvent.t/0`.
  """

  require Ecto.Query

  import Ecto.Query, only: [from: 2]

  alias Ecto.{Changeset, Multi, Repo}
  alias Explorer.Chain.Goldchain.ValidatorEvent
  alias Explorer.Chain.Import
  alias Explorer.Prometheus.Instrumenter

  @behaviour Import.Runner

  # milliseconds
  @timeout 60_000

  @type imported :: [ValidatorEvent.t()]

  @impl Import.Runner
  def ecto_schema_module, do: ValidatorEvent

  @impl Import.Runner
  def option_key, do: :goldchain_validator_events

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

    Multi.run(multi, :insert_goldchain_validator_events, fn repo, _ ->
      Instrumenter.block_import_stage_runner(
        fn -> insert(repo, changes_list, insert_options) end,
        :block_referencing,
        :goldchain_validator_events,
        :goldchain_validator_events
      )
    end)
  end

  @impl Import.Runner
  def timeout, do: @timeout

  @spec insert(Repo.t(), [map()], %{required(:timeout) => timeout(), required(:timestamps) => Import.timestamps()}) ::
          {:ok, [ValidatorEvent.t()]}
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
        for: ValidatorEvent,
        returning: true,
        timeout: timeout,
        timestamps: timestamps
      )

    {:ok, inserted}
  end

  defp default_on_conflict do
    from(
      ve in ValidatorEvent,
      update: [
        set: [
          transaction_hash: fragment("COALESCE(EXCLUDED.transaction_hash, ?)", ve.transaction_hash),
          log_index: fragment("COALESCE(EXCLUDED.log_index, ?)", ve.log_index),
          block_number: fragment("COALESCE(EXCLUDED.block_number, ?)", ve.block_number),
          block_timestamp: fragment("COALESCE(EXCLUDED.block_timestamp, ?)", ve.block_timestamp),
          event_type: fragment("COALESCE(EXCLUDED.event_type, ?)", ve.event_type),
          validator_address_hash: fragment("COALESCE(EXCLUDED.validator_address_hash, ?)", ve.validator_address_hash),
          operator_address_hash: fragment("COALESCE(EXCLUDED.operator_address_hash, ?)", ve.operator_address_hash),
          amount: fragment("COALESCE(EXCLUDED.amount, ?)", ve.amount),
          slash_type: fragment("COALESCE(EXCLUDED.slash_type, ?)", ve.slash_type),
          finality_status: fragment("COALESCE(EXCLUDED.finality_status, ?)", ve.finality_status),
          metadata: fragment("COALESCE(EXCLUDED.metadata, ?)", ve.metadata),
          inserted_at: fragment("LEAST(?, EXCLUDED.inserted_at)", ve.inserted_at),
          updated_at: fragment("GREATEST(?, EXCLUDED.updated_at)", ve.updated_at)
        ]
      ],
      where:
        fragment(
          "(EXCLUDED.transaction_hash, EXCLUDED.log_index, EXCLUDED.block_number, EXCLUDED.block_timestamp, EXCLUDED.event_type, EXCLUDED.validator_address_hash, EXCLUDED.operator_address_hash, EXCLUDED.amount, EXCLUDED.slash_type, EXCLUDED.finality_status, EXCLUDED.metadata) IS DISTINCT FROM (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
          ve.transaction_hash,
          ve.log_index,
          ve.block_number,
          ve.block_timestamp,
          ve.event_type,
          ve.validator_address_hash,
          ve.operator_address_hash,
          ve.amount,
          ve.slash_type,
          ve.finality_status,
          ve.metadata
        )
    )
  end
end
