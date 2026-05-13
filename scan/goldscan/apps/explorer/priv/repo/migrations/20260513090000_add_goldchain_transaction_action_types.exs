defmodule Explorer.Repo.Migrations.AddGoldchainTransactionActionTypes do
  use Ecto.Migration

  def up do
    execute("ALTER TYPE transaction_actions_protocol ADD VALUE IF NOT EXISTS 'goldchain'")

    for type <- [
          "stake",
          "unstake",
          "redelegate",
          "reward",
          "slash",
          "governance",
          "bridge_lock",
          "bridge_release",
          "mint_or_credit",
          "burn_or_debit",
          "migration",
          "validator_update"
        ] do
      execute("ALTER TYPE transaction_actions_type ADD VALUE IF NOT EXISTS '#{type}'")
    end
  end

  def down do
    :ok
  end
end
