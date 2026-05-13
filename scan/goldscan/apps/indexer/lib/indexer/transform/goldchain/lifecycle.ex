defmodule Indexer.Transform.Goldchain.Lifecycle do
  @moduledoc """
  Parses Gold Chain protocol logs into typed bridge / validator / staking / governance lifecycle entities.

  This parser is chain-profile driven so testnet and mainnet share identical codepaths.
  """

  require Logger

  import Explorer.Helper, only: [decode_data: 2]

  alias Indexer.Helper

  @bridge_state_to_event_type %{
    locked: :bridge_lock,
    synced: :bridge_lock,
    minted_or_credited: :mint_or_credit,
    burned_or_debited: :burn_or_debit,
    released: :bridge_release
  }

  defp event_topic(signature), do: "0x" <> Base.encode16(ExKeccak.hash_256(signature), case: :lower)

  @erc20_transfer_topic event_topic("Transfer(address,address,uint256)")
  @erc1155_transfer_single_topic event_topic("TransferSingle(address,address,address,uint256,uint256)")
  @native_gilt_deposited_topic event_topic("NativeGiltDeposited(address,uint256)")
  @state_synced_topic event_topic("StateSynced(uint256,address,bytes)")
  @locked_scaled_erc1155_topic_legacy event_topic("LockedScaledERC1155(address,address,address,uint256,uint256)")
  @exited_scaled_erc1155_topic_legacy event_topic("ExitedScaledERC1155(address,address,uint256,uint256)")
  @locked_scaled_erc1155_topic event_topic("LockedScaledERC1155(address,address,address,uint256,uint256,uint256)")
  @exited_scaled_erc1155_topic event_topic("ExitedScaledERC1155(address,address,uint256,uint256,uint256)")
  @locked_wrapped_gilt_topic event_topic("LockedWrappedGilt(address,address,address,uint256)")
  @exited_wrapped_gilt_topic event_topic("ExitedWrappedGilt(address,address,uint256)")
  @locked_erc20_topic event_topic("LockedERC20(address,address,address,uint256)")
  @locked_mintable_erc20_topic event_topic("LockedMintableERC20(address,address,address,uint256)")
  @exited_erc20_topic event_topic("ExitedERC20(address,address,uint256)")
  @exited_mintable_erc20_topic event_topic("ExitedMintableERC20(address,address,uint256)")
  @locked_batch_erc1155_topic event_topic("LockedBatchERC1155(address,address,address,uint256[],uint256[])")
  @locked_batch_mintable_erc1155_topic event_topic("LockedBatchMintableERC1155(address,address,address,uint256[],uint256[])")
  @locked_batch_chain_exit_erc1155_topic event_topic("LockedBatchChainExitERC1155(address,address,address,uint256[],uint256[])")
  @exited_erc1155_topic event_topic("ExitedERC1155(address,address,address,uint256,uint256)")
  @exited_batch_erc1155_topic event_topic("ExitedBatchERC1155(address,address,address,uint256[],uint256[])")
  @exited_mintable_erc1155_topic event_topic("ExitedMintableERC1155(address,address,address,uint256,uint256)")
  @exited_batch_mintable_erc1155_topic event_topic("ExitedBatchMintableERC1155(address,address,address,uint256[],uint256[])")
  @locked_ether_topic event_topic("LockedEther(address,address,uint256)")
  @exited_ether_topic event_topic("ExitedEther(address,uint256)")
  @validator_set_updated_topic event_topic("validatorSetUpdated()")
  @validator_deposit_topic event_topic("validatorDeposit(address,uint256)")
  @validator_misdemeanor_topic event_topic("validatorMisdemeanor(address,uint256)")
  @validator_felony_topic event_topic("validatorFelony(address,uint256)")
  @validator_enter_maintenance_topic event_topic("validatorEnterMaintenance(address)")
  @validator_exit_maintenance_topic event_topic("validatorExitMaintenance(address)")
  @finality_reward_deposit_topic event_topic("finalityRewardDeposit(address,uint256)")
  @fee_burned_topic event_topic("feeBurned(uint256)")

  @validator_created_topic event_topic("ValidatorCreated(address,address,address,bytes)")
  @stake_credit_initialized_topic event_topic("StakeCreditInitialized(address,address)")
  @consensus_address_edited_topic event_topic("ConsensusAddressEdited(address,address)")
  @vote_address_edited_topic event_topic("VoteAddressEdited(address,bytes)")
  @delegated_topic event_topic("Delegated(address,address,uint256,uint256)")
  @undelegated_topic event_topic("Undelegated(address,address,uint256,uint256)")
  @redelegated_topic event_topic("Redelegated(address,address,address,uint256,uint256,uint256)")
  @reward_distributed_topic event_topic("RewardDistributed(address,uint256)")
  @validator_slashed_topic event_topic("ValidatorSlashed(address,uint256,uint256,uint8)")
  @claimed_topic event_topic("Claimed(address,address,uint256)")

  @lifecycle_changed_topic event_topic("LifecycleChanged(uint8,uint8,uint256)")
  @migration_prepared_topic event_topic("MigrationPrepared(address,address,address,address)")
  @migration_paused_set_topic event_topic("MigrationPausedSet(bool)")
  @stake_migration_caller_updated_topic event_topic("StakeMigrationCallerUpdated(address,address)")
  @wallet_migration_router_updated_topic event_topic("WalletMigrationRouterUpdated(address,address)")
  @wallet_migrated_topic event_topic("WalletMigrated(address,uint256,uint256,bytes32)")
  @stake_migrated_topic event_topic("StakeMigrated(address,address,uint256,uint256,bytes32)")
  @gold_swapped_topic event_topic("GoldSwapped(address,uint256,uint256)")
  @router_migrated_topic event_topic("RouterMigrated(address,uint256,uint256)")
  @governance_param_change_topic event_topic("ParamChange(string,bytes)")
  @proposal_created_topic event_topic("ProposalCreated(uint256,address,address[],uint256[],string[],bytes[],uint256,uint256,string)")
  @proposal_canceled_topic event_topic("ProposalCanceled(uint256)")
  @proposal_executed_topic event_topic("ProposalExecuted(uint256)")
  @proposal_queued_topic event_topic("ProposalQueued(uint256,uint256)")
  @vote_cast_topic event_topic("VoteCast(address,uint256,uint8,uint256,string)")
  @vote_cast_with_params_topic event_topic("VoteCastWithParams(address,uint256,uint8,uint256,string,bytes)")

  @root_lock_topics [
    @locked_scaled_erc1155_topic_legacy,
    @locked_scaled_erc1155_topic,
    @locked_wrapped_gilt_topic,
    @locked_erc20_topic,
    @locked_mintable_erc20_topic,
    @locked_batch_erc1155_topic,
    @locked_batch_mintable_erc1155_topic,
    @locked_batch_chain_exit_erc1155_topic,
    @locked_ether_topic
  ]

  @root_release_topics [
    @exited_scaled_erc1155_topic_legacy,
    @exited_scaled_erc1155_topic,
    @exited_wrapped_gilt_topic,
    @exited_erc20_topic,
    @exited_mintable_erc20_topic,
    @exited_erc1155_topic,
    @exited_batch_erc1155_topic,
    @exited_mintable_erc1155_topic,
    @exited_batch_mintable_erc1155_topic,
    @exited_ether_topic
  ]

  @default_bridge_topics %{
    root_lock: @root_lock_topics,
    root_release: @root_release_topics,
    child_synced: [@state_synced_topic],
    child_mint_or_credit: [@native_gilt_deposited_topic, @erc1155_transfer_single_topic],
    child_burn_or_debit: [@erc20_transfer_topic, @erc1155_transfer_single_topic]
  }

  @default_validator_topics %{
    validator_set_updated: @validator_set_updated_topic,
    validator_deposit: @validator_deposit_topic,
    validator_misdemeanor: @validator_misdemeanor_topic,
    validator_felony: @validator_felony_topic,
    validator_enter_maintenance: @validator_enter_maintenance_topic,
    validator_exit_maintenance: @validator_exit_maintenance_topic,
    finality_reward_deposit: @finality_reward_deposit_topic,
    fee_burned: @fee_burned_topic
  }

  @default_staking_topics %{
    validator_created: @validator_created_topic,
    stake_credit_initialized: @stake_credit_initialized_topic,
    consensus_address_edited: @consensus_address_edited_topic,
    vote_address_edited: @vote_address_edited_topic,
    delegated: @delegated_topic,
    undelegated: @undelegated_topic,
    redelegated: @redelegated_topic,
    reward_distributed: @reward_distributed_topic,
    validator_slashed: @validator_slashed_topic,
    claimed: @claimed_topic
  }

  @default_governance_topics %{
    lifecycle_changed: @lifecycle_changed_topic,
    migration_prepared: @migration_prepared_topic,
    migration_paused_set: @migration_paused_set_topic,
    stake_migration_caller_updated: @stake_migration_caller_updated_topic,
    wallet_migration_router_updated: @wallet_migration_router_updated_topic,
    wallet_migrated: @wallet_migrated_topic,
    stake_migrated: @stake_migrated_topic,
    gold_swapped: @gold_swapped_topic,
    router_migrated: @router_migrated_topic,
    param_change: @governance_param_change_topic,
    proposal_created: @proposal_created_topic,
    proposal_canceled: @proposal_canceled_topic,
    proposal_executed: @proposal_executed_topic,
    proposal_queued: @proposal_queued_topic,
    vote_cast: @vote_cast_topic,
    vote_cast_with_params: @vote_cast_with_params_topic
  }

  @spec parse([map()], [map()]) :: %{
          bridge_transfers: [map()],
          validator_events: [map()],
          staking_events: [map()],
          governance_events: [map()]
        }
  def parse(blocks, logs) do
    if Application.get_env(:explorer, :chain_type) != :goldchain do
      empty_result()
    else
      block_numbers = Enum.map(blocks, & &1.number)
      latest_block = if block_numbers == [], do: 0, else: Enum.max(block_numbers)
      block_to_timestamp = Map.new(blocks, &{&1.number, &1.timestamp})
      profile = Application.get_env(:explorer, Explorer.Chain.Goldchain.Profile, [])
      child_finality_confirmations = Keyword.get(profile, :child_finality_confirmations, 64)
      root_finality_confirmations = Keyword.get(profile, :root_finality_confirmations, 64)

      root_bridge_contracts =
        profile
        |> Keyword.get(:root_bridge_contracts, [])
        |> normalize_address_set()

      child_bridge_contracts =
        profile
        |> Keyword.get(:child_bridge_contracts, [])
        |> normalize_address_set()

      validator_contracts =
        profile
        |> Keyword.get(:validator_contracts, [])
        |> normalize_address_set()

      staking_contracts =
        profile
        |> Keyword.get(:staking_contracts, [])
        |> normalize_address_set()

      governance_contracts =
        profile
        |> Keyword.get(:governance_contracts, [])
        |> normalize_address_set()

      migration_contracts =
        profile
        |> Keyword.get(:migration_contracts, [])
        |> normalize_address_set()

      root_route_asset_by_token =
        profile
        |> Keyword.get(:root_route_asset_by_token, %{})
        |> normalize_root_route_asset_map()

      bridge_topics =
        profile
        |> Keyword.get(:bridge_topics, %{})
        |> normalize_bridge_topics()

      validator_topics =
        profile
        |> Keyword.get(:validator_topics, %{})
        |> merge_topics(@default_validator_topics)

      staking_topics =
        profile
        |> Keyword.get(:staking_topics, %{})
        |> merge_topics(@default_staking_topics)

      governance_topics =
        profile
        |> Keyword.get(:governance_topics, %{})
        |> merge_topics(@default_governance_topics)

      Enum.reduce(logs, empty_result(), fn log, acc ->
        address = normalize_address(Helper.address_hash_to_string(log.address_hash, true))
        topic = sanitize_topic(log.first_topic)
        block_number = log.block_number || 0
        block_timestamp = Map.get(block_to_timestamp, block_number)

        cond do
          MapSet.member?(root_bridge_contracts, address) or MapSet.member?(child_bridge_contracts, address) ->
            case parse_bridge_transfer(
                   log,
                   address,
                   topic,
                   latest_block,
                   block_timestamp,
                   child_finality_confirmations,
                   root_finality_confirmations,
                   root_bridge_contracts,
                   bridge_topics,
                   root_route_asset_by_token
                 ) do
              nil ->
                acc

              transfer ->
                update_in(acc.bridge_transfers, &[transfer | &1])
            end

          MapSet.member?(validator_contracts, address) ->
            case parse_validator_event(
                   log,
                   topic,
                   latest_block,
                   block_timestamp,
                   child_finality_confirmations,
                   validator_topics
                 ) do
              nil ->
                acc

              event ->
                update_in(acc.validator_events, &[event | &1])
            end

          MapSet.member?(staking_contracts, address) ->
            case parse_staking_event(
                   log,
                   topic,
                   latest_block,
                   block_timestamp,
                   child_finality_confirmations,
                   staking_topics
                 ) do
              nil ->
                acc

              event ->
                update_in(acc.staking_events, &[event | &1])
            end

          MapSet.member?(governance_contracts, address) or MapSet.member?(migration_contracts, address) ->
            case parse_governance_event(
                   log,
                   topic,
                   latest_block,
                   block_timestamp,
                   child_finality_confirmations,
                   governance_topics
                 ) do
              nil ->
                acc

              event ->
                update_in(acc.governance_events, &[event | &1])
            end

          true ->
            acc
        end
      end)
      |> reverse_result_lists()
      |> correlate_bridge_result()
    end
  rescue
    error ->
      Logger.error("Goldchain lifecycle parser failed: #{Exception.message(error)}")
      empty_result()
  end

  @spec bridge_state_to_action_type(atom()) :: atom() | nil
  def bridge_state_to_action_type(state), do: Map.get(@bridge_state_to_event_type, state)

  defp parse_bridge_transfer(
         log,
         address,
         topic,
         latest_block,
         block_timestamp,
         child_finality_confirmations,
         root_finality_confirmations,
         root_bridge_contracts,
         bridge_topics,
         root_route_asset_by_token
       ) do
    source_layer = if(MapSet.member?(root_bridge_contracts, address), do: :root, else: :child)
    event_kind = find_bridge_event_kind(log, topic, bridge_topics)

    with {bridge_state, direction} when not is_nil(bridge_state) <- bridge_event_state_direction(event_kind),
         parsed when is_map(parsed) <- decode_bridge_payload(log, event_kind, topic) do
      account = Map.get(parsed, :account)
      counterparty = Map.get(parsed, :counterparty)
      amount = Map.get(parsed, :amount, 0)
      token_id = Map.get(parsed, :token_id)
      transfer_id = Map.get(parsed, :transfer_id)
      root_token = Map.get(parsed, :root_token)
      payload_metadata = Map.get(parsed, :metadata, %{})
      payload_child_amount = Map.get(payload_metadata, :child_amount)

      confirmations =
        if source_layer == :root, do: root_finality_confirmations, else: child_finality_confirmations

      finality_status = finality_for_block(log.block_number, latest_block, confirmations)
      route_asset = resolve_route_asset(token_id, root_token, root_route_asset_by_token)
      canonical_transfer_id =
        canonical_transfer_id(
          transfer_id,
          direction,
          route_asset,
          account,
          counterparty,
          root_token,
          token_id,
          amount,
          payload_child_amount
        )

      event_id = canonical_event_id(canonical_transfer_id)

      %{
        event_id: event_id,
        canonical_transfer_id: canonical_transfer_id,
        cross_chain_transfer_id: if(is_nil(transfer_id), do: nil, else: Decimal.new(transfer_id)),
        transaction_hash: log.transaction_hash,
        root_transaction_hash: if(source_layer == :root, do: log.transaction_hash, else: nil),
        child_transaction_hash: if(source_layer == :child, do: log.transaction_hash, else: nil),
        log_index: log.index,
        block_number: log.block_number,
        root_block_number: if(source_layer == :root, do: log.block_number, else: nil),
        child_block_number: if(source_layer == :child, do: log.block_number, else: nil),
        root_log_index: if(source_layer == :root, do: log.index, else: nil),
        child_log_index: if(source_layer == :child, do: log.index, else: nil),
        block_timestamp: block_timestamp,
        source_layer: source_layer,
        direction: direction,
        bridge_state: bridge_state,
        finality_status: finality_status,
        route_asset: route_asset,
        account_address_hash: account,
        counterparty_address_hash: counterparty,
        root_token_address_hash: root_token,
        contract_address_hash: address,
        child_token_id: if(is_nil(token_id), do: nil, else: Decimal.new(token_id)),
        root_amount: if(source_layer == :root, do: amount, else: nil),
        child_amount:
          cond do
            source_layer == :child -> amount
            is_integer(payload_child_amount) -> payload_child_amount
            true -> nil
          end,
        metadata:
          %{
            topic: topic,
            event_kind: to_string(event_kind),
            leg_finality_status: to_string(finality_status)
          }
          |> Map.merge(payload_metadata)
      }
    else
      _ -> nil
    end
  end

  defp correlate_bridge_result(result) do
    Map.update(result, :bridge_transfers, [], &correlate_bridge_transfers/1)
  end

  defp correlate_bridge_transfers([]), do: []

  defp correlate_bridge_transfers(bridge_events) do
    bridge_events
    |> Enum.group_by(& &1.canonical_transfer_id)
    |> Enum.map(fn {_canonical_id, events} -> build_canonical_bridge_transfer(events) end)
    |> Enum.sort_by(
      fn transfer ->
        {transfer.block_number || 0, transfer.log_index || 0}
      end,
      :desc
    )
  end

  defp build_canonical_bridge_transfer(events) do
    ordered_events = Enum.sort_by(events, &{&1.block_number || 0, &1.log_index || 0})
    latest_event = List.last(ordered_events)
    direction = canonical_direction(ordered_events)

    route_asset =
      ordered_events
      |> Enum.map(& &1.route_asset)
      |> Enum.reject(&is_nil/1)
      |> Enum.at(0)

    has_route_mismatch? = route_mismatch?(ordered_events)
    has_amount_mismatch? = amount_mismatch?(ordered_events)

    has_finalized_root_lock? = finalized_event?(ordered_events, "root_lock")
    has_finalized_child_synced? = finalized_event?(ordered_events, "child_synced")
    has_finalized_child_mint? = finalized_event?(ordered_events, "child_mint_or_credit")
    has_finalized_child_burn? = finalized_event?(ordered_events, "child_burn_or_debit")
    has_finalized_root_release? = finalized_event?(ordered_events, "root_release")

    has_reverted_leg? = Enum.any?(ordered_events, &(&1.finality_status == :reverted))

    {bridge_state, finality_status} =
      cond do
        has_reverted_leg? ->
          {:failed, :reverted}

        has_route_mismatch? or has_amount_mismatch? ->
          {:failed, :disputed}

        direction == :deposit and has_finalized_child_mint? and has_finalized_root_lock? ->
          {:minted_or_credited, :finalized}

        direction == :withdrawal and has_finalized_root_release? and has_finalized_child_burn? ->
          {:released, :finalized}

        direction == :deposit and observed_event?(ordered_events, "child_mint_or_credit") ->
          {:synced, :pending}

        direction == :deposit and has_finalized_child_synced? ->
          {:synced, :pending}

        direction == :withdrawal and observed_event?(ordered_events, "root_release") ->
          {:burned_or_debited, :pending}

        direction == :withdrawal and observed_event?(ordered_events, "child_burn_or_debit") ->
          {:burned_or_debited, :pending}

        true ->
          {:locked, :pending}
      end

    representative =
      case direction do
        :withdrawal -> pick_latest(ordered_events, &(&1.direction == :withdrawal))
        _ -> pick_latest(ordered_events, fn _ -> true end)
      end

    root_event = pick_latest(ordered_events, &(&1.source_layer == :root))
    child_event = pick_latest(ordered_events, &(&1.source_layer == :child))

    metadata =
      Map.get(latest_event, :metadata, %{})
      |> Map.drop([:event_kind, :leg_finality_status, "event_kind", "leg_finality_status"])
      |> Map.merge(%{
        "observed_legs" => Enum.map(ordered_events, &event_kind_value/1),
        "route_consistency" => if(has_route_mismatch?, do: "disputed", else: "ok"),
        "amount_consistency" => if(has_amount_mismatch?, do: "disputed", else: "ok"),
        "finalized_root_lock" => has_finalized_root_lock?,
        "finalized_child_synced" => has_finalized_child_synced?,
        "finalized_child_mint_or_credit" => has_finalized_child_mint?,
        "finalized_child_burn_or_debit" => has_finalized_child_burn?,
        "finalized_root_release" => has_finalized_root_release?
      })

    %{
      event_id: latest_event.event_id,
      canonical_transfer_id: latest_event.canonical_transfer_id,
      cross_chain_transfer_id: latest_event.cross_chain_transfer_id,
      transaction_hash: representative.transaction_hash,
      root_transaction_hash:
        first_non_nil([latest_event.root_transaction_hash, root_event && root_event.transaction_hash]),
      child_transaction_hash:
        first_non_nil([latest_event.child_transaction_hash, child_event && child_event.transaction_hash]),
      log_index: representative.log_index,
      block_number: representative.block_number,
      root_block_number: first_non_nil([latest_event.root_block_number, root_event && root_event.block_number]),
      child_block_number: first_non_nil([latest_event.child_block_number, child_event && child_event.block_number]),
      root_log_index: first_non_nil([latest_event.root_log_index, root_event && root_event.log_index]),
      child_log_index: first_non_nil([latest_event.child_log_index, child_event && child_event.log_index]),
      block_timestamp: representative.block_timestamp,
      source_layer: representative.source_layer,
      direction: direction,
      bridge_state: bridge_state,
      finality_status: finality_status,
      route_asset: route_asset,
      account_address_hash: first_non_nil(Enum.map(ordered_events, & &1.account_address_hash)),
      counterparty_address_hash: first_non_nil(Enum.map(ordered_events, & &1.counterparty_address_hash)),
      root_token_address_hash: first_non_nil(Enum.map(ordered_events, & &1.root_token_address_hash)),
      contract_address_hash: representative.contract_address_hash,
      child_token_id: first_non_nil(Enum.map(ordered_events, & &1.child_token_id)),
      root_amount: first_non_nil(Enum.map(ordered_events, & &1.root_amount)),
      child_amount: first_non_nil(Enum.map(ordered_events, & &1.child_amount)),
      metadata: metadata
    }
  end

  defp parse_validator_event(log, topic, latest_block, block_timestamp, confirmations, validator_topics) do
    {event_type, parser_fun} =
      case topic do
        t when t == Map.get(validator_topics, :validator_set_updated) ->
          {:validator_set_updated, fn _log -> %{} end}

        t when t == Map.get(validator_topics, :validator_deposit) ->
          {:validator_deposit, &parse_validator_amount_event/1}

        t when t == Map.get(validator_topics, :validator_misdemeanor) ->
          {:validator_misdemeanor, &parse_validator_amount_event/1}

        t when t == Map.get(validator_topics, :validator_felony) ->
          {:validator_felony, &parse_validator_amount_event/1}

        t when t == Map.get(validator_topics, :validator_enter_maintenance) ->
          {:validator_enter_maintenance, &parse_validator_address_event/1}

        t when t == Map.get(validator_topics, :validator_exit_maintenance) ->
          {:validator_exit_maintenance, &parse_validator_address_event/1}

        t when t == Map.get(validator_topics, :finality_reward_deposit) ->
          {:finality_reward_deposit, &parse_validator_amount_event/1}

        t when t == Map.get(validator_topics, :fee_burned) ->
          {:fee_burned, &parse_amount_only_event/1}

        _ ->
          {nil, nil}
      end

    if is_nil(event_type) do
      nil
    else
      parsed = parser_fun.(log)

      %{
        event_id: log_event_id(log, "validator", event_type),
        transaction_hash: log.transaction_hash,
        log_index: log.index,
        block_number: log.block_number,
        block_timestamp: block_timestamp,
        event_type: event_type,
        validator_address_hash: Map.get(parsed, :validator_address_hash),
        operator_address_hash: Map.get(parsed, :operator_address_hash, Map.get(parsed, :validator_address_hash)),
        amount: decimal_or_nil(Map.get(parsed, :amount)),
        slash_type: Map.get(parsed, :slash_type),
        finality_status: finality_for_block(log.block_number, latest_block, confirmations),
        metadata: %{
          topic: topic
        }
      }
    end
  end

  defp parse_staking_event(log, topic, latest_block, block_timestamp, confirmations, staking_topics) do
    {event_type, parser_fun} =
      cond do
        topic == Map.get(staking_topics, :delegated) ->
          {:delegated, &parse_delegated/1}

        topic == Map.get(staking_topics, :undelegated) ->
          {:undelegated, &parse_delegated/1}

        topic == Map.get(staking_topics, :redelegated) ->
          {:redelegated, &parse_redelegated/1}

        topic == Map.get(staking_topics, :reward_distributed) ->
          {:reward_distributed, &parse_reward_distributed/1}

        topic == Map.get(staking_topics, :claimed) ->
          {:claimed, &parse_claimed/1}

        topic == Map.get(staking_topics, :stake_credit_initialized) ->
          {:stake_credit_initialized, &parse_operator_only/1}

        topic == Map.get(staking_topics, :consensus_address_edited) ->
          {:consensus_address_edited, &parse_operator_only/1}

        topic == Map.get(staking_topics, :vote_address_edited) ->
          {:vote_address_edited, &parse_operator_only/1}

        topic == Map.get(staking_topics, :validator_created) ->
          {:validator_created, &parse_validator_created/1}

        topic == Map.get(staking_topics, :validator_slashed) ->
          {:validator_slashed, &parse_validator_slashed/1}

        true ->
          {nil, nil}
      end

    if is_nil(event_type) do
      nil
    else
      parsed = parser_fun.(log)

      %{
        event_id: log_event_id(log, "staking", event_type),
        transaction_hash: log.transaction_hash,
        log_index: log.index,
        block_number: log.block_number,
        block_timestamp: block_timestamp,
        event_type: event_type,
        operator_address_hash: Map.get(parsed, :operator_address_hash),
        delegator_address_hash: Map.get(parsed, :delegator_address_hash),
        src_validator_address_hash: Map.get(parsed, :src_validator_address_hash),
        dst_validator_address_hash: Map.get(parsed, :dst_validator_address_hash),
        gilt_amount: decimal_or_nil(Map.get(parsed, :gilt_amount)),
        shares: decimal_or_nil(Map.get(parsed, :shares)),
        old_shares: decimal_or_nil(Map.get(parsed, :old_shares)),
        new_shares: decimal_or_nil(Map.get(parsed, :new_shares)),
        reward_amount: decimal_or_nil(Map.get(parsed, :reward_amount)),
        finality_status: finality_for_block(log.block_number, latest_block, confirmations),
        metadata:
          %{
            topic: topic
          }
          |> Map.merge(Map.get(parsed, :metadata, %{}))
      }
    end
  end

  defp parse_governance_event(log, topic, latest_block, block_timestamp, confirmations, governance_topics) do
    {event_type, parser_fun} =
      cond do
        topic == Map.get(governance_topics, :lifecycle_changed) ->
          {:lifecycle_changed, fn _log -> %{} end}

        topic == Map.get(governance_topics, :migration_prepared) ->
          {:migration_prepared, &parse_migration_prepared/1}

        topic == Map.get(governance_topics, :migration_paused_set) ->
          {:migration_paused_set, fn _log -> %{} end}

        topic == Map.get(governance_topics, :stake_migration_caller_updated) ->
          {:stake_migration_caller_updated, &parse_two_addresses/1}

        topic == Map.get(governance_topics, :wallet_migration_router_updated) ->
          {:wallet_migration_router_updated, &parse_two_addresses/1}

        topic == Map.get(governance_topics, :wallet_migrated) ->
          {:wallet_migrated, &parse_wallet_migrated/1}

        topic == Map.get(governance_topics, :stake_migrated) ->
          {:stake_migrated, &parse_stake_migrated/1}

        topic == Map.get(governance_topics, :gold_swapped) ->
          {:gold_swapped, &parse_gold_swapped/1}

        topic == Map.get(governance_topics, :router_migrated) ->
          {:router_migrated, &parse_gold_swapped/1}

        topic == Map.get(governance_topics, :param_change) ->
          {:param_change, fn _log -> %{} end}

        topic == Map.get(governance_topics, :proposal_created) ->
          {:proposal_created, &parse_proposal_created/1}

        topic == Map.get(governance_topics, :proposal_canceled) ->
          {:proposal_canceled, &parse_proposal_only/1}

        topic == Map.get(governance_topics, :proposal_executed) ->
          {:proposal_executed, &parse_proposal_only/1}

        topic == Map.get(governance_topics, :proposal_queued) ->
          {:proposal_queued, &parse_proposal_queued/1}

        topic == Map.get(governance_topics, :vote_cast) ->
          {:vote_cast, &parse_vote_cast/1}

        topic == Map.get(governance_topics, :vote_cast_with_params) ->
          {:vote_cast_with_params, &parse_vote_cast/1}

        true ->
          {nil, nil}
      end

    if is_nil(event_type) do
      nil
    else
      parsed = parser_fun.(log)
      token_id = Map.get(parsed, :token_id)

      %{
        event_id: log_event_id(log, "governance", event_type),
        transaction_hash: log.transaction_hash,
        log_index: log.index,
        block_number: log.block_number,
        block_timestamp: block_timestamp,
        event_type: event_type,
        governance_actor_address_hash:
          Map.get(parsed, :governance_actor_address_hash, Map.get(parsed, :operator_address_hash)),
        route_asset: token_id_to_route_asset(token_id),
        amount: decimal_or_nil(Map.get(parsed, :amount)),
        token_id: decimal_or_nil(token_id),
        finality_status: finality_for_block(log.block_number, latest_block, confirmations),
        metadata:
          %{
            topic: topic
          }
          |> Map.merge(Map.get(parsed, :metadata, %{}))
      }
    end
  end

  defp decode_bridge_payload(log, event_kind, topic) do
    case event_kind do
      :child_synced ->
        parse_state_synced_payload(log)

      :child_burn_or_debit ->
        parse_child_transfer_payload(log, topic, :child_burn_or_debit)

      :child_mint_or_credit ->
        parse_child_transfer_payload(log, topic, :child_mint_or_credit)

      :root_lock ->
        parse_root_bridge_payload(log, topic, :root_lock)

      :root_release ->
        parse_root_bridge_payload(log, topic, :root_release)

      _ ->
        parse_fallback_bridge_payload(log)
    end
  end

  defp parse_state_synced_payload(log) do
    transfer_id = topic_to_uint(log.second_topic)
    state_receiver = topic_to_address(log.third_topic)

    %{
      account: nil,
      counterparty: state_receiver,
      amount: nil,
      token_id: nil,
      transfer_id: transfer_id,
      root_token: nil
    }
  end

  defp parse_child_transfer_payload(log, topic, :child_burn_or_debit) do
    transfer_id = guess_transfer_id(log)

    case parse_erc1155_transfer_single(log, topic) do
      %{from: from, to: to, amount: amount, token_id: token_id} ->
        %{
          account: from,
          counterparty: to,
          amount: amount,
          token_id: token_id,
          transfer_id: transfer_id,
          root_token: nil
        }

      _ ->
        from = topic_to_address(log.second_topic)
        to = topic_to_address(log.third_topic)
        [amount] = safe_decode(log.data, [{:uint, 256}], [0])

        %{
          account: from,
          counterparty: to,
          amount: amount,
          token_id: nil,
          transfer_id: transfer_id,
          root_token: nil
        }
    end
  end

  defp parse_child_transfer_payload(log, topic, :child_mint_or_credit) do
    transfer_id = guess_transfer_id(log)

    case parse_erc1155_transfer_single(log, topic) do
      %{from: from, to: to, amount: amount, token_id: token_id} ->
        account = if(from == burn_address(), do: to, else: from)

        %{
          account: account,
          counterparty: if(account == to, do: from, else: to),
          amount: amount,
          token_id: token_id,
          transfer_id: transfer_id,
          root_token: nil
        }

      _ ->
        account = topic_to_address(log.second_topic)
        [amount] = safe_decode(log.data, [{:uint, 256}], [0])

        %{
          account: account,
          counterparty: nil,
          amount: amount,
          token_id: nil,
          transfer_id: transfer_id,
          root_token: nil
        }
    end
  end

  defp parse_root_bridge_payload(log, topic, :root_lock) do
    case topic do
      t when t in [@locked_scaled_erc1155_topic_legacy, @locked_scaled_erc1155_topic] ->
        parse_root_scaled_lock(log, topic)

      t when t in [@locked_erc20_topic, @locked_mintable_erc20_topic, @locked_wrapped_gilt_topic] ->
        parse_root_three_indexed_lock(log)

      t
      when t in [
             @locked_batch_erc1155_topic,
             @locked_batch_mintable_erc1155_topic,
             @locked_batch_chain_exit_erc1155_topic
           ] ->
        parse_root_batch_erc1155_lock(log)

      t when t == @locked_ether_topic ->
        depositor = topic_to_address(log.second_topic)
        receiver = topic_to_address(log.third_topic)
        [amount] = safe_decode(log.data, [{:uint, 256}], [0])

        %{
          account: depositor,
          counterparty: receiver,
          amount: amount,
          token_id: nil,
          transfer_id: nil,
          root_token: nil
        }

      _ ->
        parse_fallback_bridge_payload(log)
    end
  end

  defp parse_root_bridge_payload(log, topic, :root_release) do
    case topic do
      t when t in [@exited_scaled_erc1155_topic_legacy, @exited_scaled_erc1155_topic] ->
        parse_root_scaled_release(log, topic)

      t when t in [@exited_erc20_topic, @exited_mintable_erc20_topic, @exited_wrapped_gilt_topic] ->
        parse_root_two_indexed_release(log)

      t when t in [@exited_erc1155_topic, @exited_mintable_erc1155_topic] ->
        parse_root_single_erc1155_release(log)

      t when t in [@exited_batch_erc1155_topic, @exited_batch_mintable_erc1155_topic] ->
        parse_root_batch_erc1155_release(log)

      t when t == @exited_ether_topic ->
        exitor = topic_to_address(log.second_topic)
        [amount] = safe_decode(log.data, [{:uint, 256}], [0])

        %{
          account: exitor,
          counterparty: nil,
          amount: amount,
          token_id: nil,
          transfer_id: nil,
          root_token: nil
        }

      _ ->
        parse_fallback_bridge_payload(log)
    end
  end

  defp parse_root_scaled_lock(log, topic) do
    depositor = topic_to_address(log.second_topic)
    receiver = topic_to_address(log.third_topic)
    root_token = topic_to_address(log.fourth_topic)

    case topic do
      t when t == @locked_scaled_erc1155_topic_legacy ->
        [root_amount, child_amount] = safe_decode(log.data, [{:uint, 256}, {:uint, 256}], [0, 0])

        %{
          account: depositor,
          counterparty: receiver,
          amount: root_amount,
          token_id: nil,
          transfer_id: nil,
          root_token: root_token,
          metadata: %{child_amount: child_amount}
        }

      _ ->
        [child_token_id, root_amount, child_amount] =
          safe_decode(log.data, [{:uint, 256}, {:uint, 256}, {:uint, 256}], [nil, 0, 0])

        %{
          account: depositor,
          counterparty: receiver,
          amount: root_amount,
          token_id: child_token_id,
          transfer_id: nil,
          root_token: root_token,
          metadata: %{child_amount: child_amount}
        }
    end
  end

  defp parse_root_scaled_release(log, topic) do
    exitor = topic_to_address(log.second_topic)
    root_token = topic_to_address(log.third_topic)

    case topic do
      t when t == @exited_scaled_erc1155_topic_legacy ->
        [child_amount, root_amount] = safe_decode(log.data, [{:uint, 256}, {:uint, 256}], [0, 0])

        %{
          account: exitor,
          counterparty: nil,
          amount: root_amount,
          token_id: nil,
          transfer_id: nil,
          root_token: root_token,
          metadata: %{child_amount: child_amount}
        }

      _ ->
        [child_token_id, child_amount, root_amount] =
          safe_decode(log.data, [{:uint, 256}, {:uint, 256}, {:uint, 256}], [nil, 0, 0])

        %{
          account: exitor,
          counterparty: nil,
          amount: root_amount,
          token_id: child_token_id,
          transfer_id: nil,
          root_token: root_token,
          metadata: %{child_amount: child_amount}
        }
    end
  end

  defp parse_root_three_indexed_lock(log) do
    depositor = topic_to_address(log.second_topic)
    receiver = topic_to_address(log.third_topic)
    root_token = topic_to_address(log.fourth_topic)
    [amount] = safe_decode(log.data, [{:uint, 256}], [0])

    %{
      account: depositor,
      counterparty: receiver,
      amount: amount,
      token_id: nil,
      transfer_id: nil,
      root_token: root_token
    }
  end

  defp parse_root_two_indexed_release(log) do
    exitor = topic_to_address(log.second_topic)
    root_token = topic_to_address(log.third_topic)
    [amount] = safe_decode(log.data, [{:uint, 256}], [0])

    %{
      account: exitor,
      counterparty: nil,
      amount: amount,
      token_id: nil,
      transfer_id: nil,
      root_token: root_token
    }
  end

  defp parse_root_batch_erc1155_lock(log) do
    depositor = topic_to_address(log.second_topic)
    receiver = topic_to_address(log.third_topic)
    root_token = topic_to_address(log.fourth_topic)
    [ids, amounts] = safe_decode(log.data, [{:array, {:uint, 256}}, {:array, {:uint, 256}}], [[], []])
    token_id = List.first(ids)
    amount = List.first(amounts) || 0

    %{
      account: depositor,
      counterparty: receiver,
      amount: amount,
      token_id: token_id,
      transfer_id: nil,
      root_token: root_token,
      metadata: %{
        ids: ids,
        amounts: amounts
      }
    }
  end

  defp parse_root_single_erc1155_release(log) do
    exitor = topic_to_address(log.second_topic)
    root_token = topic_to_address(log.third_topic)
    [token_id, amount] = safe_decode(log.data, [{:uint, 256}, {:uint, 256}], [nil, 0])

    %{
      account: exitor,
      counterparty: nil,
      amount: amount,
      token_id: token_id,
      transfer_id: nil,
      root_token: root_token
    }
  end

  defp parse_root_batch_erc1155_release(log) do
    exitor = topic_to_address(log.second_topic)
    root_token = topic_to_address(log.third_topic)
    [ids, amounts] = safe_decode(log.data, [{:array, {:uint, 256}}, {:array, {:uint, 256}}], [[], []])
    token_id = List.first(ids)
    amount = List.first(amounts) || 0

    %{
      account: exitor,
      counterparty: nil,
      amount: amount,
      token_id: token_id,
      transfer_id: nil,
      root_token: root_token,
      metadata: %{
        ids: ids,
        amounts: amounts
      }
    }
  end

  defp parse_fallback_bridge_payload(log) do
    %{
      account: topic_to_address(log.second_topic),
      counterparty: topic_to_address(log.third_topic),
      amount: guess_amount(log),
      token_id: nil,
      transfer_id: guess_transfer_id(log),
      root_token: nil
    }
  end

  defp parse_validator_amount_event(log) do
    validator = topic_to_address(log.second_topic)
    [amount] = safe_decode(log.data, [{:uint, 256}], [0])

    %{
      validator_address_hash: validator,
      operator_address_hash: validator,
      amount: amount
    }
  end

  defp parse_validator_address_event(log) do
    validator = topic_to_address(log.second_topic)
    %{validator_address_hash: validator, operator_address_hash: validator}
  end

  defp parse_amount_only_event(log) do
    [amount] = safe_decode(log.data, [{:uint, 256}], [0])
    %{amount: amount}
  end

  defp parse_delegated(log) do
    operator = topic_to_address(log.second_topic)
    delegator = topic_to_address(log.third_topic)
    [shares, gilt_amount] = safe_decode(log.data, [{:uint, 256}, {:uint, 256}], [0, 0])

    %{
      operator_address_hash: operator,
      delegator_address_hash: delegator,
      shares: shares,
      gilt_amount: gilt_amount
    }
  end

  defp parse_redelegated(log) do
    src_validator = topic_to_address(log.second_topic)
    dst_validator = topic_to_address(log.third_topic)
    delegator = topic_to_address(log.fourth_topic)
    [old_shares, new_shares, gilt_amount] =
      safe_decode(log.data, [{:uint, 256}, {:uint, 256}, {:uint, 256}], [0, 0, 0])

    %{
      operator_address_hash: src_validator,
      delegator_address_hash: delegator,
      src_validator_address_hash: src_validator,
      dst_validator_address_hash: dst_validator,
      old_shares: old_shares,
      new_shares: new_shares,
      gilt_amount: gilt_amount
    }
  end

  defp parse_reward_distributed(log) do
    operator = topic_to_address(log.second_topic)
    [reward] = safe_decode(log.data, [{:uint, 256}], [0])

    %{
      operator_address_hash: operator,
      reward_amount: reward
    }
  end

  defp parse_claimed(log) do
    operator = topic_to_address(log.second_topic)
    delegator = topic_to_address(log.third_topic)
    [amount] = safe_decode(log.data, [{:uint, 256}], [0])

    %{
      operator_address_hash: operator,
      delegator_address_hash: delegator,
      reward_amount: amount
    }
  end

  defp parse_operator_only(log) do
    %{operator_address_hash: topic_to_address(log.second_topic)}
  end

  defp parse_validator_created(log) do
    consensus = topic_to_address(log.second_topic)
    operator = topic_to_address(log.third_topic)
    credit = topic_to_address(log.fourth_topic)

    %{
      operator_address_hash: operator,
      src_validator_address_hash: consensus,
      dst_validator_address_hash: credit
    }
  end

  defp parse_validator_slashed(log) do
    operator = topic_to_address(log.second_topic)
    [_jail_until, slash_amount, slash_type] = safe_decode(log.data, [{:uint, 256}, {:uint, 256}, {:uint, 8}], [0, 0, 0])

    %{
      operator_address_hash: operator,
      reward_amount: slash_amount,
      metadata: %{slash_type: slash_type}
    }
  end

  defp parse_migration_prepared(log) do
    legacy = topic_to_address(log.second_topic)
    final = topic_to_address(log.third_topic)
    reserve = topic_to_address(log.fourth_topic)
    [caller] = safe_decode(log.data, [:address], [nil])

    %{
      governance_actor_address_hash: normalize_address(legacy),
      operator_address_hash: normalize_address(caller),
      metadata: %{final_gold: final, reserve_vault: reserve}
    }
  end

  defp parse_two_addresses(log) do
    %{
      governance_actor_address_hash: topic_to_address(log.second_topic),
      operator_address_hash: topic_to_address(log.third_topic)
    }
  end

  defp parse_wallet_migrated(log) do
    account = topic_to_address(log.second_topic)
    token_id = topic_to_uint(log.third_topic)
    [amount, migration_ref] = safe_decode(log.data, [{:uint, 256}, {:bytes, 32}], [0, nil])

    %{
      governance_actor_address_hash: account,
      token_id: token_id,
      amount: amount,
      metadata: %{migration_ref: bytes32_to_hex(migration_ref)}
    }
  end

  defp parse_stake_migrated(log) do
    operator = topic_to_address(log.second_topic)
    delegator = topic_to_address(log.third_topic)
    token_id = topic_to_uint(log.fourth_topic)
    [amount, migration_ref] = safe_decode(log.data, [{:uint, 256}, {:bytes, 32}], [0, nil])

    %{
      governance_actor_address_hash: operator,
      operator_address_hash: delegator,
      token_id: token_id,
      amount: amount,
      metadata: %{migration_ref: bytes32_to_hex(migration_ref)}
    }
  end

  defp parse_gold_swapped(log) do
    account = topic_to_address(log.second_topic)
    token_id = topic_to_uint(log.third_topic)
    [amount] = safe_decode(log.data, [{:uint, 256}], [0])

    %{
      governance_actor_address_hash: account,
      token_id: token_id,
      amount: amount
    }
  end

  defp parse_proposal_created(log) do
    [proposal_id, proposer] = safe_decode(log.data, [{:uint, 256}, :address], [nil, nil])

    %{
      governance_actor_address_hash: normalize_address(proposer),
      metadata: %{
        proposal_id: proposal_id
      }
    }
  end

  defp parse_proposal_only(log) do
    [proposal_id] = safe_decode(log.data, [{:uint, 256}], [nil])

    %{
      metadata: %{
        proposal_id: proposal_id
      }
    }
  end

  defp parse_proposal_queued(log) do
    [proposal_id, eta] = safe_decode(log.data, [{:uint, 256}, {:uint, 256}], [nil, nil])

    %{
      metadata: %{
        proposal_id: proposal_id,
        eta: eta
      }
    }
  end

  defp parse_vote_cast(log) do
    voter = topic_to_address(log.second_topic)
    [proposal_id, support, weight] = safe_decode(log.data, [{:uint, 256}, {:uint, 8}, {:uint, 256}], [nil, nil, nil])

    %{
      governance_actor_address_hash: voter,
      metadata: %{
        proposal_id: proposal_id,
        support: support,
        weight: weight
      }
    }
  end

  defp finality_for_block(block_number, latest_block, confirmations)
       when is_integer(block_number) and is_integer(latest_block) and is_integer(confirmations) do
    if latest_block - block_number >= confirmations, do: :finalized, else: :pending
  end

  defp finality_for_block(_, _, _), do: :pending

  defp guess_amount(log) do
    case safe_decode(log.data, [{:uint, 256}], [:error]) do
      [value] when is_integer(value) -> value
      _ -> 0
    end
  end

  defp guess_transfer_id(log) do
    topic_to_uint(log.fourth_topic)
  end

  defp bridge_event_state_direction(:root_lock), do: {:locked, :deposit}
  defp bridge_event_state_direction(:child_synced), do: {:synced, :deposit}
  defp bridge_event_state_direction(:child_mint_or_credit), do: {:minted_or_credited, :deposit}
  defp bridge_event_state_direction(:child_burn_or_debit), do: {:burned_or_debited, :withdrawal}
  defp bridge_event_state_direction(:root_release), do: {:released, :withdrawal}
  defp bridge_event_state_direction(_), do: nil

  defp find_bridge_event_kind(log, topic, bridge_topics) do
    if topic == @erc1155_transfer_single_topic and
         topic_in?(topic, bridge_topics.child_mint_or_credit) and
         topic_in?(topic, bridge_topics.child_burn_or_debit) do
      case parse_erc1155_transfer_single(log, topic) do
        %{from: from, to: to} ->
          cond do
            from == burn_address() and to != burn_address() -> :child_mint_or_credit
            to == burn_address() and from != burn_address() -> :child_burn_or_debit
            true -> nil
          end

        _ ->
          nil
      end
    else
      do_find_bridge_event_kind(topic, bridge_topics)
    end
  end

  defp do_find_bridge_event_kind(topic, bridge_topics) do
    cond do
      topic_in?(topic, bridge_topics.root_lock) -> :root_lock
      topic_in?(topic, bridge_topics.root_release) -> :root_release
      topic_in?(topic, bridge_topics.child_synced) -> :child_synced
      topic_in?(topic, bridge_topics.child_mint_or_credit) -> :child_mint_or_credit
      topic_in?(topic, bridge_topics.child_burn_or_debit) -> :child_burn_or_debit
      true -> nil
    end
  end

  defp topic_in?(_topic, nil), do: false
  defp topic_in?(topic, topics) when is_list(topics), do: Enum.member?(topics, topic)
  defp topic_in?(topic, single_topic) when is_binary(single_topic), do: topic == single_topic

  defp token_id_to_route_asset(1), do: :paxg
  defp token_id_to_route_asset(2), do: :xaut
  defp token_id_to_route_asset(_), do: nil

  defp resolve_route_asset(token_id, root_token, root_route_asset_by_token) do
    token_id_to_route_asset(token_id) ||
      (root_token && Map.get(root_route_asset_by_token, normalize_address(root_token)))
  end

  defp canonical_transfer_id(
         transfer_id,
         direction,
         route_asset,
         account,
         counterparty,
         root_token,
         token_id,
         root_amount,
         child_amount
       ) do
    if is_nil(transfer_id) do
      participant = fallback_participant(account, counterparty)
      effective_amount = first_non_nil([child_amount, root_amount]) || 0

      fallback_seed =
        [
          "fallback",
          to_string(direction || :unknown),
          route_asset && to_string(route_asset),
          participant,
          normalize_address(root_token),
          token_id || 0,
          effective_amount
        ]
        |> Enum.map(&to_string_or_empty/1)
        |> Enum.join(":")

      "xfer-fallback-" <> short_hash(fallback_seed)
    else
      "xfer-#{transfer_id}-#{direction || :unknown}"
    end
  end

  defp fallback_participant(account, counterparty) do
    account = normalize_address(account)
    counterparty = normalize_address(counterparty)

    cond do
      is_nil(counterparty) -> account
      counterparty == burn_address() -> account
      true -> counterparty
    end
  end

  defp canonical_event_id(canonical_transfer_id) do
    "0x" <> Base.encode16(ExKeccak.hash_256("canonical:#{canonical_transfer_id}"), case: :lower)
  end

  defp canonical_direction(events) do
    if Enum.any?(events, &(&1.direction == :withdrawal)), do: :withdrawal, else: :deposit
  end

  defp finalized_event?(events, event_kind) do
    Enum.any?(events, fn event ->
      event_kind_value(event) == event_kind and event.finality_status == :finalized
    end)
  end

  defp observed_event?(events, event_kind) do
    Enum.any?(events, fn event ->
      event_kind_value(event) == event_kind
    end)
  end

  defp route_mismatch?(events) do
    unique_routes =
      events
      |> Enum.map(& &1.route_asset)
      |> Enum.reject(&is_nil/1)
      |> Enum.uniq()

    length(unique_routes) > 1
  end

  defp amount_mismatch?(events) do
    root_amounts =
      events
      |> Enum.map(& &1.root_amount)
      |> Enum.reject(&is_nil/1)
      |> Enum.uniq()

    child_amounts =
      events
      |> Enum.map(& &1.child_amount)
      |> Enum.reject(&is_nil/1)
      |> Enum.uniq()

    length(root_amounts) > 1 or length(child_amounts) > 1
  end

  defp pick_latest(events, matcher) do
    events
    |> Enum.filter(matcher)
    |> List.last()
  end

  defp event_kind_value(event) do
    metadata = Map.get(event, :metadata, %{})
    Map.get(metadata, :event_kind) || Map.get(metadata, "event_kind")
  end

  defp first_non_nil(values) when is_list(values) do
    Enum.find(values, &(not is_nil(&1)))
  end

  defp short_hash(value) do
    value
    |> to_string_or_empty()
    |> ExKeccak.hash_256()
    |> Base.encode16(case: :lower)
    |> String.slice(0, 32)
  end

  defp to_string_or_empty(nil), do: ""
  defp to_string_or_empty(value) when is_binary(value), do: value
  defp to_string_or_empty(value), do: to_string(value)

  defp log_event_id(log, family, event_type) do
    seed = "#{family}:#{event_type}:#{Helper.address_hash_to_string(log.transaction_hash, true)}:#{log.index}"
    "0x" <> Base.encode16(ExKeccak.hash_256(seed), case: :lower)
  end

  defp safe_decode(data, types, default) do
    decode_data(data, types)
  rescue
    _ -> default
  end

  defp sanitize_topic(topic) do
    if is_nil(topic), do: "", else: String.downcase(Helper.log_topic_to_string(topic))
  end

  defp normalize_bridge_topics(map) when is_map(map) do
    merged =
      @default_bridge_topics
      |> Map.merge(Map.new(map, fn {k, v} -> {normalize_topic_key(k), normalize_topic_value(v)} end))

    %{
      root_lock: merged[:root_lock],
      root_release: merged[:root_release],
      child_synced: merged[:child_synced],
      child_mint_or_credit: merged[:child_mint_or_credit],
      child_burn_or_debit: merged[:child_burn_or_debit]
    }
  end

  defp normalize_bridge_topics(_), do: normalize_bridge_topics(%{})

  defp merge_topics(custom, defaults) do
    custom = if is_map(custom), do: custom, else: %{}

    defaults
    |> Map.merge(
      Map.new(custom, fn {k, v} ->
        {normalize_topic_key(k), normalize_topic_value(v)}
      end)
    )
    |> Map.new(fn {k, v} -> {k, normalize_topic_value(v)} end)
  end

  defp normalize_topic_key(key) when is_atom(key), do: key
  defp normalize_topic_key(key) when is_binary(key), do: String.to_atom(key)

  defp normalize_topic_value(value) when is_binary(value), do: String.downcase(value)

  defp normalize_topic_value(value) when is_list(value) do
    Enum.map(value, fn item ->
      if is_binary(item), do: String.downcase(item), else: item
    end)
  end

  defp normalize_topic_value(value), do: value

  defp normalize_root_route_asset_map(map) when is_map(map) do
    map
    |> Enum.reduce(%{}, fn {token, route_asset}, acc ->
      normalized_token =
        token
        |> to_string()
        |> normalize_address()

      case normalize_route_asset(route_asset) do
        nil -> acc
        normalized_route -> Map.put(acc, normalized_token, normalized_route)
      end
    end)
  end

  defp normalize_root_route_asset_map(_), do: %{}

  defp normalize_route_asset(route_asset) when route_asset in [:paxg, :xaut], do: route_asset

  defp normalize_route_asset(route_asset) when is_binary(route_asset) do
    case String.downcase(route_asset) do
      "paxg" -> :paxg
      "xaut" -> :xaut
      _ -> nil
    end
  end

  defp normalize_route_asset(_), do: nil

  defp normalize_address_set(addresses) when is_list(addresses) do
    addresses
    |> Enum.map(&normalize_address/1)
    |> MapSet.new()
  end

  defp normalize_address_set(_), do: MapSet.new()

  defp normalize_address(nil), do: nil
  defp normalize_address(address) when is_binary(address), do: String.downcase(address)

  defp topic_to_address(nil), do: nil

  defp topic_to_address(topic) do
    with "0x" <> rest <- sanitize_topic(topic),
         true <- String.length(rest) == 64 do
      "0x" <> String.slice(rest, 24, 40)
    else
      _ -> nil
    end
  end

  defp topic_to_uint(nil), do: nil

  defp topic_to_uint(topic) do
    case safe_decode(sanitize_topic(topic), [{:uint, 256}], [:error]) do
      [value] when is_integer(value) -> value
      _ -> nil
    end
  end

  defp bytes32_to_hex(nil), do: nil
  defp bytes32_to_hex(binary) when is_binary(binary), do: "0x" <> Base.encode16(binary, case: :lower)

  defp parse_erc1155_transfer_single(log, topic) do
    if topic == @erc1155_transfer_single_topic do
      from = topic_to_address(log.third_topic)
      to = topic_to_address(log.fourth_topic)
      [token_id, amount] = safe_decode(log.data, [{:uint, 256}, {:uint, 256}], [nil, nil])

      %{
        from: from,
        to: to,
        token_id: token_id,
        amount: if(is_integer(amount), do: amount, else: 0)
      }
    else
      nil
    end
  end

  defp burn_address, do: "0x0000000000000000000000000000000000000000"

  defp decimal_or_nil(nil), do: nil
  defp decimal_or_nil(value) when is_integer(value), do: Decimal.new(value)
  defp decimal_or_nil(value), do: value

  defp empty_result do
    %{
      bridge_transfers: [],
      validator_events: [],
      staking_events: [],
      governance_events: []
    }
  end

  defp reverse_result_lists(result) do
    %{
      bridge_transfers: Enum.reverse(result.bridge_transfers),
      validator_events: Enum.reverse(result.validator_events),
      staking_events: Enum.reverse(result.staking_events),
      governance_events: Enum.reverse(result.governance_events)
    }
  end
end
