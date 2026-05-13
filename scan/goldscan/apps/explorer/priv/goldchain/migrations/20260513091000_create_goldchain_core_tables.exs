defmodule Explorer.Repo.Goldchain.Migrations.CreateGoldchainCoreTables do
  use Ecto.Migration

  def change do
    execute(
      "CREATE TYPE goldchain_bridge_layer AS ENUM ('root', 'child')",
      "DROP TYPE goldchain_bridge_layer"
    )

    execute(
      "CREATE TYPE goldchain_bridge_direction AS ENUM ('deposit', 'withdrawal')",
      "DROP TYPE goldchain_bridge_direction"
    )

    execute(
      "CREATE TYPE goldchain_bridge_state AS ENUM ('locked', 'synced', 'minted_or_credited', 'burned_or_debited', 'released', 'failed')",
      "DROP TYPE goldchain_bridge_state"
    )

    execute(
      "CREATE TYPE goldchain_finality_status AS ENUM ('pending', 'finalized', 'reverted', 'disputed')",
      "DROP TYPE goldchain_finality_status"
    )

    execute(
      "CREATE TYPE goldchain_route_asset AS ENUM ('paxg', 'xaut')",
      "DROP TYPE goldchain_route_asset"
    )

    create table(:goldchain_bridge_transfers, primary_key: false) do
      add(:event_id, :bytea, null: false, primary_key: true)
      add(:canonical_transfer_id, :string, null: false)
      add(:cross_chain_transfer_id, :numeric, precision: 100, null: true)
      add(:transaction_hash, :bytea, null: false)
      add(:root_transaction_hash, :bytea, null: true)
      add(:child_transaction_hash, :bytea, null: true)
      add(:log_index, :integer, null: false)
      add(:block_number, :bigint, null: false)
      add(:root_block_number, :bigint, null: true)
      add(:child_block_number, :bigint, null: true)
      add(:root_log_index, :integer, null: true)
      add(:child_log_index, :integer, null: true)
      add(:block_timestamp, :"timestamp without time zone", null: true)
      add(:source_layer, :goldchain_bridge_layer, null: false)
      add(:direction, :goldchain_bridge_direction, null: true)
      add(:bridge_state, :goldchain_bridge_state, null: false)
      add(:finality_status, :goldchain_finality_status, null: false)
      add(:route_asset, :goldchain_route_asset, null: true)
      add(:account_address_hash, :bytea, null: true)
      add(:counterparty_address_hash, :bytea, null: true)
      add(:root_token_address_hash, :bytea, null: true)
      add(:contract_address_hash, :bytea, null: true)
      add(:child_token_id, :numeric, precision: 100, null: true)
      add(:root_amount, :numeric, precision: 100, null: true)
      add(:child_amount, :numeric, precision: 100, null: true)
      add(:metadata, :map, null: true)
      timestamps(null: false, type: :utc_datetime_usec)
    end

    create(unique_index(:goldchain_bridge_transfers, [:canonical_transfer_id]))
    create(index(:goldchain_bridge_transfers, [:block_number, :log_index]))
    create(index(:goldchain_bridge_transfers, [:transaction_hash, :log_index]))
    create(index(:goldchain_bridge_transfers, [:root_transaction_hash]))
    create(index(:goldchain_bridge_transfers, [:child_transaction_hash]))
    create(index(:goldchain_bridge_transfers, [:direction, :bridge_state]))
    create(index(:goldchain_bridge_transfers, [:finality_status, :bridge_state]))
    create(index(:goldchain_bridge_transfers, [:route_asset, :bridge_state]))
    create(index(:goldchain_bridge_transfers, [:cross_chain_transfer_id]))

    create table(:goldchain_validator_events, primary_key: false) do
      add(:event_id, :bytea, null: false, primary_key: true)
      add(:transaction_hash, :bytea, null: false)
      add(:log_index, :integer, null: false)
      add(:block_number, :bigint, null: false)
      add(:block_timestamp, :"timestamp without time zone", null: true)
      add(:event_type, :string, null: false)
      add(:validator_address_hash, :bytea, null: true)
      add(:operator_address_hash, :bytea, null: true)
      add(:amount, :numeric, precision: 100, null: true)
      add(:slash_type, :integer, null: true)
      add(:finality_status, :goldchain_finality_status, null: false)
      add(:metadata, :map, null: true)
      timestamps(null: false, type: :utc_datetime_usec)
    end

    create(index(:goldchain_validator_events, [:block_number, :log_index]))
    create(index(:goldchain_validator_events, [:event_type, :block_number]))
    create(index(:goldchain_validator_events, [:validator_address_hash, :block_number]))
    create(index(:goldchain_validator_events, [:finality_status, :event_type]))

    create table(:goldchain_staking_events, primary_key: false) do
      add(:event_id, :bytea, null: false, primary_key: true)
      add(:transaction_hash, :bytea, null: false)
      add(:log_index, :integer, null: false)
      add(:block_number, :bigint, null: false)
      add(:block_timestamp, :"timestamp without time zone", null: true)
      add(:event_type, :string, null: false)
      add(:operator_address_hash, :bytea, null: true)
      add(:delegator_address_hash, :bytea, null: true)
      add(:src_validator_address_hash, :bytea, null: true)
      add(:dst_validator_address_hash, :bytea, null: true)
      add(:gilt_amount, :numeric, precision: 100, null: true)
      add(:shares, :numeric, precision: 100, null: true)
      add(:old_shares, :numeric, precision: 100, null: true)
      add(:new_shares, :numeric, precision: 100, null: true)
      add(:reward_amount, :numeric, precision: 100, null: true)
      add(:finality_status, :goldchain_finality_status, null: false)
      add(:metadata, :map, null: true)
      timestamps(null: false, type: :utc_datetime_usec)
    end

    create(index(:goldchain_staking_events, [:block_number, :log_index]))
    create(index(:goldchain_staking_events, [:event_type, :block_number]))
    create(index(:goldchain_staking_events, [:delegator_address_hash, :block_number]))
    create(index(:goldchain_staking_events, [:operator_address_hash, :block_number]))
    create(index(:goldchain_staking_events, [:finality_status, :event_type]))

    create table(:goldchain_governance_events, primary_key: false) do
      add(:event_id, :bytea, null: false, primary_key: true)
      add(:transaction_hash, :bytea, null: false)
      add(:log_index, :integer, null: false)
      add(:block_number, :bigint, null: false)
      add(:block_timestamp, :"timestamp without time zone", null: true)
      add(:event_type, :string, null: false)
      add(:governance_actor_address_hash, :bytea, null: true)
      add(:route_asset, :goldchain_route_asset, null: true)
      add(:amount, :numeric, precision: 100, null: true)
      add(:token_id, :numeric, precision: 100, null: true)
      add(:finality_status, :goldchain_finality_status, null: false)
      add(:metadata, :map, null: true)
      timestamps(null: false, type: :utc_datetime_usec)
    end

    create(index(:goldchain_governance_events, [:block_number, :log_index]))
    create(index(:goldchain_governance_events, [:event_type, :block_number]))
    create(index(:goldchain_governance_events, [:governance_actor_address_hash, :block_number]))
    create(index(:goldchain_governance_events, [:finality_status, :event_type]))
  end
end
