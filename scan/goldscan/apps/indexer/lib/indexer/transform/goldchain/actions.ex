defmodule Indexer.Transform.Goldchain.Actions do
  @moduledoc """
  Builds transaction action payloads for decoded Gold Chain lifecycle entities.
  """

  alias Indexer.Transform.Goldchain.Lifecycle

  @slash_validator_event_types ~w(validator_misdemeanor validator_felony validator_slashed)a
  @migration_event_types ~w(migration_prepared wallet_migrated stake_migrated router_migrated gold_swapped)a

  @spec from_lifecycle(map()) :: [map()]
  def from_lifecycle(%{
        bridge_transfers: bridge_transfers,
        validator_events: validator_events,
        staking_events: staking_events,
        governance_events: governance_events
      }) do
    bridge_transfers
    |> Enum.flat_map(&bridge_transfer_action/1)
    |> Kernel.++(Enum.map(validator_events, &validator_event_action/1))
    |> Kernel.++(Enum.map(staking_events, &staking_event_action/1))
    |> Kernel.++(Enum.map(governance_events, &governance_event_action/1))
    |> Enum.sort_by(fn action -> {action.data.block_number || 0, action.log_index || 0} end)
  end

  def from_lifecycle(_), do: []

  defp bridge_transfer_action(transfer) do
    case Lifecycle.bridge_state_to_action_type(transfer.bridge_state) do
      nil ->
        []

      type ->
        [
          action(
            transfer.transaction_hash,
            type,
            transfer.log_index,
            transfer.block_number,
            %{
              event_id: transfer.event_id,
              canonical_transfer_id: transfer.canonical_transfer_id,
              cross_chain_transfer_id: transfer.cross_chain_transfer_id,
              source_layer: transfer.source_layer,
              direction: transfer.direction,
              bridge_state: transfer.bridge_state,
              finality_status: transfer.finality_status,
              route_asset: route_asset_value(transfer.route_asset),
              root_transaction_hash: transfer.root_transaction_hash,
              child_transaction_hash: transfer.child_transaction_hash,
              account_address_hash: transfer.account_address_hash,
              counterparty_address_hash: transfer.counterparty_address_hash,
              contract_address_hash: transfer.contract_address_hash,
              root_amount: transfer.root_amount,
              child_amount: transfer.child_amount
            }
          )
        ]
    end
  end

  defp validator_event_action(event) do
    type =
      if event.event_type in @slash_validator_event_types do
        :slash
      else
        :validator_update
      end

    action(event.transaction_hash, type, event.log_index, event.block_number, %{
      event_id: event.event_id,
      event_type: event.event_type,
      validator_address_hash: event.validator_address_hash,
      operator_address_hash: event.operator_address_hash,
      amount: event.amount,
      slash_type: event.slash_type,
      finality_status: event.finality_status
    })
  end

  defp staking_event_action(event) do
    type =
      case event.event_type do
        :delegated -> :stake
        :undelegated -> :unstake
        :redelegated -> :redelegate
        :reward_distributed -> :reward
        :claimed -> :reward
        :validator_slashed -> :slash
        _ -> :validator_update
      end

    action(event.transaction_hash, type, event.log_index, event.block_number, %{
      event_id: event.event_id,
      event_type: event.event_type,
      operator_address_hash: event.operator_address_hash,
      delegator_address_hash: event.delegator_address_hash,
      src_validator_address_hash: event.src_validator_address_hash,
      dst_validator_address_hash: event.dst_validator_address_hash,
      gilt_amount: event.gilt_amount,
      shares: event.shares,
      old_shares: event.old_shares,
      new_shares: event.new_shares,
      reward_amount: event.reward_amount,
      finality_status: event.finality_status
    })
  end

  defp governance_event_action(event) do
    type =
      if event.event_type in @migration_event_types do
        :migration
      else
        :governance
      end

    action(event.transaction_hash, type, event.log_index, event.block_number, %{
      event_id: event.event_id,
      event_type: event.event_type,
      governance_actor_address_hash: event.governance_actor_address_hash,
      route_asset: route_asset_value(event.route_asset),
      amount: event.amount,
      token_id: event.token_id,
      finality_status: event.finality_status
    })
  end

  defp action(hash, type, log_index, block_number, data) do
    %{
      hash: hash,
      protocol: "goldchain",
      type: to_string(type),
      log_index: log_index || 0,
      data:
        data
        |> Map.put(:block_number, block_number)
        |> Enum.reject(fn {_k, v} -> is_nil(v) end)
        |> Map.new()
    }
  end

  defp route_asset_value(:paxg), do: "PAXG"
  defp route_asset_value(:xaut), do: "XAUT"
  defp route_asset_value(route_asset) when is_binary(route_asset), do: String.upcase(route_asset)
  defp route_asset_value(_), do: nil
end
