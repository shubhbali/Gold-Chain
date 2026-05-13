defmodule Explorer.Chain.Goldchain.ValidatorEvent do
  @moduledoc """
  Models decoded validator lifecycle events emitted by Gold Chain system contracts.
  """

  use Explorer.Schema

  alias Explorer.Chain.Hash

  @event_types [
    :validator_created,
    :validator_set_updated,
    :validator_misdemeanor,
    :validator_felony,
    :validator_enter_maintenance,
    :validator_exit_maintenance,
    :validator_deposit,
    :validator_slashed,
    :finality_reward_deposit,
    :fee_burned
  ]

  @finality_statuses [:pending, :finalized, :reverted, :disputed]

  @required_attrs ~w(event_id transaction_hash log_index block_number event_type finality_status)a
  @optional_attrs ~w(
    block_timestamp
    validator_address_hash
    operator_address_hash
    amount
    slash_type
    metadata
  )a

  @primary_key false
  typed_schema "goldchain_validator_events" do
    field(:event_id, Hash.Full, primary_key: true)
    field(:transaction_hash, Hash.Full)
    field(:log_index, :integer)
    field(:block_number, :integer)
    field(:block_timestamp, :utc_datetime_usec)
    field(:event_type, Ecto.Enum, values: @event_types)
    field(:validator_address_hash, Hash.Address)
    field(:operator_address_hash, Hash.Address)
    field(:amount, :decimal)
    field(:slash_type, :integer)
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
