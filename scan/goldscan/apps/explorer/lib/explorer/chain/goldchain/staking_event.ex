defmodule Explorer.Chain.Goldchain.StakingEvent do
  @moduledoc """
  Models decoded staking lifecycle events emitted by Gold Chain system contracts.
  """

  use Explorer.Schema

  alias Explorer.Chain.Hash

  @event_types [
    :delegated,
    :undelegated,
    :redelegated,
    :reward_distributed,
    :claimed,
    :validator_created,
    :validator_slashed,
    :consensus_address_edited,
    :vote_address_edited,
    :stake_credit_initialized
  ]

  @finality_statuses [:pending, :finalized, :reverted, :disputed]

  @required_attrs ~w(event_id transaction_hash log_index block_number event_type finality_status)a

  @optional_attrs ~w(
    block_timestamp
    operator_address_hash
    delegator_address_hash
    src_validator_address_hash
    dst_validator_address_hash
    gilt_amount
    shares
    old_shares
    new_shares
    reward_amount
    metadata
  )a

  @primary_key false
  typed_schema "goldchain_staking_events" do
    field(:event_id, Hash.Full, primary_key: true)
    field(:transaction_hash, Hash.Full)
    field(:log_index, :integer)
    field(:block_number, :integer)
    field(:block_timestamp, :utc_datetime_usec)
    field(:event_type, Ecto.Enum, values: @event_types)
    field(:operator_address_hash, Hash.Address)
    field(:delegator_address_hash, Hash.Address)
    field(:src_validator_address_hash, Hash.Address)
    field(:dst_validator_address_hash, Hash.Address)
    field(:gilt_amount, :decimal)
    field(:shares, :decimal)
    field(:old_shares, :decimal)
    field(:new_shares, :decimal)
    field(:reward_amount, :decimal)
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
