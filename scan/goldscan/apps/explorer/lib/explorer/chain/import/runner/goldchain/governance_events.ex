defmodule Explorer.Chain.Import.Runner.Goldchain.GovernanceEvents do
  @moduledoc """
  Bulk imports `t:Explorer.Chain.Goldchain.GovernanceEvent.t/0`.
  """

  require Ecto.Query

  import Ecto.Query, only: [from: 2]

  alias Ecto.{Changeset, Multi, Repo}
  alias Explorer.Chain.Goldchain.GovernanceEvent
  alias Explorer.Chain.Import
  alias Explorer.Prometheus.Instrumenter

  @behaviour Import.Runner

  # milliseconds
  @timeout 60_000

  @type imported :: [GovernanceEvent.t()]

  @impl Import.Runner
  def ecto_schema_module, do: GovernanceEvent

  @impl Import.Runner
  def option_key, do: :goldchain_governance_events

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

    Multi.run(multi, :insert_goldchain_governance_events, fn repo, _ ->
      Instrumenter.block_import_stage_runner(
        fn -> insert(repo, changes_list, insert_options) end,
        :block_referencing,
        :goldchain_governance_events,
        :goldchain_governance_events
      )
    end)
  end

  @impl Import.Runner
  def timeout, do: @timeout

  @spec insert(Repo.t(), [map()], %{required(:timeout) => timeout(), required(:timestamps) => Import.timestamps()}) ::
          {:ok, [GovernanceEvent.t()]}
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
        for: GovernanceEvent,
        returning: true,
        timeout: timeout,
        timestamps: timestamps
      )

    {:ok, inserted}
  end

  defp default_on_conflict do
    from(
      ge in GovernanceEvent,
      update: [
        set: [
          transaction_hash: fragment("COALESCE(EXCLUDED.transaction_hash, ?)", ge.transaction_hash),
          log_index: fragment("COALESCE(EXCLUDED.log_index, ?)", ge.log_index),
          block_number: fragment("COALESCE(EXCLUDED.block_number, ?)", ge.block_number),
          block_timestamp: fragment("COALESCE(EXCLUDED.block_timestamp, ?)", ge.block_timestamp),
          event_type: fragment("COALESCE(EXCLUDED.event_type, ?)", ge.event_type),
          governance_actor_address_hash:
            fragment("COALESCE(EXCLUDED.governance_actor_address_hash, ?)", ge.governance_actor_address_hash),
          route_asset: fragment("COALESCE(EXCLUDED.route_asset, ?)", ge.route_asset),
          amount: fragment("COALESCE(EXCLUDED.amount, ?)", ge.amount),
          token_id: fragment("COALESCE(EXCLUDED.token_id, ?)", ge.token_id),
          finality_status: fragment("COALESCE(EXCLUDED.finality_status, ?)", ge.finality_status),
          metadata: fragment("COALESCE(EXCLUDED.metadata, ?)", ge.metadata),
          inserted_at: fragment("LEAST(?, EXCLUDED.inserted_at)", ge.inserted_at),
          updated_at: fragment("GREATEST(?, EXCLUDED.updated_at)", ge.updated_at)
        ]
      ],
      where:
        fragment(
          "(EXCLUDED.transaction_hash, EXCLUDED.log_index, EXCLUDED.block_number, EXCLUDED.block_timestamp, EXCLUDED.event_type, EXCLUDED.governance_actor_address_hash, EXCLUDED.route_asset, EXCLUDED.amount, EXCLUDED.token_id, EXCLUDED.finality_status, EXCLUDED.metadata) IS DISTINCT FROM (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
          ge.transaction_hash,
          ge.log_index,
          ge.block_number,
          ge.block_timestamp,
          ge.event_type,
          ge.governance_actor_address_hash,
          ge.route_asset,
          ge.amount,
          ge.token_id,
          ge.finality_status,
          ge.metadata
        )
    )
  end
end
