defmodule Explorer.Chain.Goldchain.BridgeTransfer do
  @moduledoc """
  Models a decoded Gold Chain bridge transfer lifecycle event.
  """

  use Explorer.Schema

  alias Explorer.Chain.Hash

  @source_layers [:root, :child]
  @directions [:deposit, :withdrawal]
  @bridge_states [:locked, :synced, :minted_or_credited, :burned_or_debited, :released, :failed]
  @finality_statuses [:pending, :finalized, :reverted, :disputed]
  @route_assets [:paxg, :xaut]

  @required_attrs ~w(event_id canonical_transfer_id transaction_hash log_index block_number source_layer bridge_state finality_status)a

  @optional_attrs ~w(
    cross_chain_transfer_id
    root_transaction_hash
    child_transaction_hash
    root_block_number
    child_block_number
    root_log_index
    child_log_index
    block_timestamp
    direction
    route_asset
    account_address_hash
    counterparty_address_hash
    root_token_address_hash
    contract_address_hash
    child_token_id
    root_amount
    child_amount
    metadata
  )a

  @primary_key false
  typed_schema "goldchain_bridge_transfers" do
    field(:event_id, Hash.Full, primary_key: true)
    field(:canonical_transfer_id, :string)
    field(:cross_chain_transfer_id, :decimal)
    field(:transaction_hash, Hash.Full)
    field(:root_transaction_hash, Hash.Full)
    field(:child_transaction_hash, Hash.Full)
    field(:log_index, :integer)
    field(:block_number, :integer)
    field(:root_block_number, :integer)
    field(:child_block_number, :integer)
    field(:root_log_index, :integer)
    field(:child_log_index, :integer)
    field(:block_timestamp, :utc_datetime_usec)
    field(:source_layer, Ecto.Enum, values: @source_layers)
    field(:direction, Ecto.Enum, values: @directions)
    field(:bridge_state, Ecto.Enum, values: @bridge_states)
    field(:finality_status, Ecto.Enum, values: @finality_statuses)
    field(:route_asset, Ecto.Enum, values: @route_assets)
    field(:account_address_hash, Hash.Address)
    field(:counterparty_address_hash, Hash.Address)
    field(:root_token_address_hash, Hash.Address)
    field(:contract_address_hash, Hash.Address)
    field(:child_token_id, :decimal)
    field(:root_amount, :decimal)
    field(:child_amount, :decimal)
    field(:metadata, :map)

    timestamps()
  end

  @spec changeset(Ecto.Schema.t(), map()) :: Ecto.Schema.t()
  def changeset(%__MODULE__{} = transfer, attrs \\ %{}) do
    transfer
    |> cast(attrs, @required_attrs ++ @optional_attrs)
    |> validate_required(@required_attrs)
    |> unique_constraint(:event_id)
  end
end
