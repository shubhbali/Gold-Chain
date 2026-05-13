defmodule Explorer.Repo.Goldchain.Migrations.ExtendGoldchainBridgeTransfersForCanonicalCorrelation do
  use Ecto.Migration

  def up do
    execute("ALTER TABLE goldchain_bridge_transfers ADD COLUMN IF NOT EXISTS canonical_transfer_id text")
    execute("ALTER TABLE goldchain_bridge_transfers ADD COLUMN IF NOT EXISTS root_transaction_hash bytea")
    execute("ALTER TABLE goldchain_bridge_transfers ADD COLUMN IF NOT EXISTS child_transaction_hash bytea")
    execute("ALTER TABLE goldchain_bridge_transfers ADD COLUMN IF NOT EXISTS root_block_number bigint")
    execute("ALTER TABLE goldchain_bridge_transfers ADD COLUMN IF NOT EXISTS child_block_number bigint")
    execute("ALTER TABLE goldchain_bridge_transfers ADD COLUMN IF NOT EXISTS root_log_index integer")
    execute("ALTER TABLE goldchain_bridge_transfers ADD COLUMN IF NOT EXISTS child_log_index integer")

    execute("""
    UPDATE goldchain_bridge_transfers
    SET canonical_transfer_id = encode(event_id, 'hex')
    WHERE canonical_transfer_id IS NULL
    """)

    execute("ALTER TABLE goldchain_bridge_transfers ALTER COLUMN canonical_transfer_id SET NOT NULL")
    execute("CREATE UNIQUE INDEX IF NOT EXISTS goldchain_bridge_transfers_canonical_transfer_id_index ON goldchain_bridge_transfers (canonical_transfer_id)")
    execute("CREATE INDEX IF NOT EXISTS goldchain_bridge_transfers_root_transaction_hash_index ON goldchain_bridge_transfers (root_transaction_hash)")
    execute("CREATE INDEX IF NOT EXISTS goldchain_bridge_transfers_child_transaction_hash_index ON goldchain_bridge_transfers (child_transaction_hash)")
  end

  def down do
    execute("DROP INDEX IF EXISTS goldchain_bridge_transfers_child_transaction_hash_index")
    execute("DROP INDEX IF EXISTS goldchain_bridge_transfers_root_transaction_hash_index")
    execute("DROP INDEX IF EXISTS goldchain_bridge_transfers_canonical_transfer_id_index")
    execute("ALTER TABLE goldchain_bridge_transfers DROP COLUMN IF EXISTS child_log_index")
    execute("ALTER TABLE goldchain_bridge_transfers DROP COLUMN IF EXISTS root_log_index")
    execute("ALTER TABLE goldchain_bridge_transfers DROP COLUMN IF EXISTS child_block_number")
    execute("ALTER TABLE goldchain_bridge_transfers DROP COLUMN IF EXISTS root_block_number")
    execute("ALTER TABLE goldchain_bridge_transfers DROP COLUMN IF EXISTS child_transaction_hash")
    execute("ALTER TABLE goldchain_bridge_transfers DROP COLUMN IF EXISTS root_transaction_hash")
    execute("ALTER TABLE goldchain_bridge_transfers DROP COLUMN IF EXISTS canonical_transfer_id")
  end
end

