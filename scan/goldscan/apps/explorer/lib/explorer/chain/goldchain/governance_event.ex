defmodule Explorer.Chain.Goldchain.GovernanceEvent do
  @moduledoc """
  Models decoded governance, migration, and policy lifecycle events for Gold Chain.
  """

  use Explorer.Schema

  alias Explorer.Chain.Hash

  @event_types [
    :proposal_created,
    :proposal_canceled,
    :proposal_executed,
    :proposal_queued,
    :vote_cast,
    :vote_cast_with_params,
    :param_change,
    :lifecycle_changed,
    :migration_prepared,
    :wallet_migrated,
    :stake_migrated,
    :gold_swapped,
    :router_migrated,
    :migration_paused_set,
    :stake_migration_caller_updated,
    :wallet_migration_router_updated
  ]

  @route_assets [:paxg, :xaut]
  @finality_statuses [:pending, :finalized, :reverted, :disputed]

  @required_attrs ~w(event_id transaction_hash log_index block_number event_type finality_status)a

  @optional_attrs ~w(
    block_timestamp
    governance_actor_address_hash
    route_asset
    amount
    token_id
    metadata
  )a

  @primary_key false
  typed_schema "goldchain_governance_events" do
    field(:event_id, Hash.Full, primary_key: true)
    field(:transaction_hash, Hash.Full)
    field(:log_index, :integer)
    field(:block_number, :integer)
    field(:block_timestamp, :utc_datetime_usec)
    field(:event_type, Ecto.Enum, values: @event_types)
    field(:governance_actor_address_hash, Hash.Address)
    field(:route_asset, Ecto.Enum, values: @route_assets)
    field(:amount, :decimal)
    field(:token_id, :decimal)
    field(:finality_status, Ecto.Enum, values: @finality_statuses)
    field(:metadata, :map)

    timestamps()
  end

  @spec changeset(Ecto.Schema.t(), map()) :: Ecto.Schema.t()
  def changeset(%__MODULE__{} = event, attrs \\ %{}) do
    event
    |> cast(attrs, @required_attrs ++ @optional_attrs)
    |> validate_required(@required_attrs)
    |> unique_constraint(:event_id)
  end
end
