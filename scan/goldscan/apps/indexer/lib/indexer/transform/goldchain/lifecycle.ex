defmodule Indexer.Transform.Goldchain.Lifecycle do
  @moduledoc """
  Parses Gold Chain protocol logs into typed bridge / validator / staking / governance lifecycle entities.

  This parser is chain-profile driven so testnet and mainnet share identical codepaths.
  """

  require Logger

  import Explorer.Helper, only: [decode_data: 2]

  alias Indexer.Helper
  alias Indexer.Transform.Goldchain.Lifecycle.TransferIds

  @bridge_state_to_event_type %{
    locked: :bridge_lock,
    synced: :bridge_lock,
    minted_or_credited: :mint_or_credit,
    burned_or_debited: :burn_or_debit,
    released: :bridge_release
  }


  @erc20_transfer_topic "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef"
  @erc1155_transfer_single_topic "0xc3d58168c5ae7397731d063d5bbf3d657854427343f4c083240f7aacaa2d0f62"
  @native_gilt_deposited_topic "0xc221810ad0e3bd1642287ccca475afa5e8bbda40dcd530831a38d8496172578a"
  @state_synced_topic "0x103fed9db65eac19c4d870f49ab7520fe03b99f1838e5996caf47e9e43308392"
  @locked_scaled_erc1155_topic_legacy "0xb5253c4d78beed4e3a1c142dffdb2f93a04d7c5e97fd56c08d8c762d2c881e91"
  @exited_scaled_erc1155_topic_legacy "0xfe981088b77c9d96be5f304b4db754ed2734f2434cad4e73b53147c251c79f6f"
  @locked_scaled_erc1155_topic "0x2213c543677a81854e3c7dfbcfbb091309e2ef30e35a2a60bab69185b2e4ba81"
  @exited_scaled_erc1155_topic "0xbfec0e380085911b08df36cec417889b47e14715b246825974ee44c9f9f52863"
  @locked_wrapped_gilt_topic "0x376677db932e29d7d2bcd59fdf3a6dca08445b9104f93fd41c4dbe7ef4f9fcfb"
  @exited_wrapped_gilt_topic "0x262149ddcbac4a6e328c8bf36497eb10ebb5a89668041de2ffcc2262c4e13fc1"
  @locked_erc20_topic "0x9b217a401a5ddf7c4d474074aff9958a18d48690d77cc2151c4706aa7348b401"
  @locked_mintable_erc20_topic "0x31472eae9e158460fea5622d1fcb0c5bdc65b6ffb51827f7bc9ef5788410c34c"
  @exited_erc20_topic "0xbb61bd1b26b3684c7c028ff1a8f6dabcac2fac8ac57b66fa6b1efb6edeab03c4"
  @exited_mintable_erc20_topic "0x42315cb7471194a6f162099cd1052b95b750612a46472e887f7784b95aa2c4c3"
  @locked_batch_erc1155_topic "0x5a921678b5779e4471b77219741a417a6ad6ec5d89fa5c8ce8cd7bd2d9f34186"
  @locked_batch_mintable_erc1155_topic "0x1f512d82dee9e34be6d1fbe7e9eee79cb3185b84686ce1968a3e95f76fdb8c6a"
  @locked_batch_chain_exit_erc1155_topic "0xecf1f094c6a68f46c74b2e3aae719d6996bf2172e8bac7413a744748938da99e"
  @exited_erc1155_topic "0xb49b534e4a6ffb5f20d7994c4e2921360f77f27525061da3318b2739241239a1"
  @exited_batch_erc1155_topic "0xb1e13b57f14f66b7b74efca5036e3f2ef128a5e0cab93ece340c891344f034dd"
  @exited_mintable_erc1155_topic "0x02758c5b369a62fd5f7b52e72e443a7723af61ea7164f54bdd0b5dd39842c2ea"
  @exited_batch_mintable_erc1155_topic "0x0f8b689c50d88d81136377378b18a7fb01e9d3873f444f0aebebdd1b6c6fec30"
  @locked_ether_topic "0x3e799b2d61372379e767ef8f04d65089179b7a6f63f9be3065806456c7309f1b"
  @exited_ether_topic "0x0fc0eed41f72d3da77d0f53b9594fc7073acd15ee9d7c536819a70a67c57ef3c"
  @validator_set_updated_topic "0xedd8d7296956dd970ab4de3f2fc03be2b0ffc615d20cd4c72c6e44f928630ebf"
  @validator_deposit_topic "0x93a090ecc682c002995fad3c85b30c5651d7fd29b0be5da9d784a3302aedc055"
  @validator_misdemeanor_topic "0x8cd4e147d8af98a9e3b6724021b8bf6aed2e5dac71c38f2dce8161b82585b25d"
  @validator_felony_topic "0x3b6f9ef90462b512a1293ecec018670bf7b7f1876fb727590a8a6d7643130a70"
  @validator_enter_maintenance_topic "0xf62981a567ec3cec866c6fa93c55bcdf841d6292d18b8d522ececa769375d82d"
  @validator_exit_maintenance_topic "0xb9d38178dc641ff1817967a63c9078cbcd955a9f1fcd75e0e3636de615d44d3b"
  @finality_reward_deposit_topic "0xcb0aad6cf9cd03bdf6137e359f541c42f38b39f007cae8e89e88aa7d8c6617b2"
  @fee_burned_topic "0x627059660ea01c4733a328effb2294d2f86905bf806da763a89cee254de8bee5"

  @validator_created_topic "0xaecd9fb95e79c75a3a1de93362c6be5fe6ab65770d8614be583884161cd8228d"
  @stake_credit_initialized_topic "0xd481492e4e93bb36b4c12a5af93f03be3bf04b454dfbc35dd2663fa26f44d5b0"
  @consensus_address_edited_topic "0x6e4e747ca35203f16401c69805c7dd52fff67ef60b0ebc5c7fe16890530f2235"
  @vote_address_edited_topic "0x783156582145bd0ff7924fae6953ba054cf1233eb60739a200ddb10de068ff0d"
  @delegated_topic "0x24d7bda8602b916d64417f0dbfe2e2e88ec9b1157bd9f596dfdb91ba26624e04"
  @undelegated_topic "0x3aace7340547de7b9156593a7652dc07ee900cea3fd8f82cb6c9d38b40829802"
  @redelegated_topic "0xfdac6e81913996d95abcc289e90f2d8bd235487ce6fe6f821e7d21002a1915b4"
  @reward_distributed_topic "0xe34918ff1c7084970068b53fd71ad6d8b04e9f15d3886cbf006443e6cdc52ea6"
  @validator_slashed_topic "0x6e9a2ee7aee95665e3a774a212eb11441b217e3e4656ab9563793094689aabb2"
  @claimed_topic "0xf7a40077ff7a04c7e61f6f26fb13774259ddf1b6bce9ecf26a8276cdd3992683"

  @lifecycle_changed_topic "0x25f99d052de99503e90a911ffc00c46b0452ef3c5fe5599520ac03218ba7797a"
  @migration_prepared_topic "0x4cf0c1ea5dceb87375e3e5ba680d6819a24a4fded089d27d16c1a59a3fcb060d"
  @migration_paused_set_topic "0x335b784f538a4188326e0cbf8aa87c0d5f7164304653923e0daa4be03ecc4d32"
  @stake_migration_caller_updated_topic "0x0909057a819745a440ab89bcbf4afed06907df17fa39bc2874ad70fdfc6d00f6"
  @wallet_migration_router_updated_topic "0x53e9d7d0c96ece35de1236ecae186a92e804795bb0fee69f2ff1f51cb96fb34d"
  @wallet_migrated_topic "0x3cb2c9ea96d80d807ea50ecffe8ef07630e116e7cb411589e6d5cff8c7d0ff1b"
  @stake_migrated_topic "0x6f3f0b1b3726b8facd05ad7b112f6b2e2dfee290e51f995ff7b2bec103cb26a0"
  @gold_swapped_topic "0x78cb6dbca4be5076a927cc6eca8fb93584b83e3d68009dd22ac038aa1f71ac15"
  @router_migrated_topic "0x6a52ac7145a275e52ff6a1c5670004d515b8e95031b622cbd97118afba4834b5"
  @governance_param_change_topic "0xf1ce9b2cbf50eeb05769a29e2543fd350cab46894a7dd9978a12d534bb20e633"
  @proposal_created_topic "0x7d84a6263ae0d98d3329bd7b46bb4e8d6f98cd35a7adb45c274c8b7fd5ebd5e0"
  @proposal_canceled_topic "0x789cf55be980739dad1d0699b93b58e806b51c9d96619bfa8fe0a28abaa7b30c"
  @proposal_executed_topic "0x712ae1383f79ac853f8d882153778e0260ef8f03b504e2866e0593e04d2b291f"
  @proposal_queued_topic "0x9a2e42fd6722813d69113e7d0079d3d940171428df7373df9c7f7617cfda2892"
  @vote_cast_topic "0xb8e138887d0aa13bab447e82de9d5c1777041ecd21ca36ba824ff1e6c07ddda4"
  @vote_cast_with_params_topic "0xe2babfbac5889a709b63bb7f598b324e08bc5a4fb9ec647fb3cbc9ec07eb8712"

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
      canonical_transfer_id = TransferIds.canonical_transfer_id(transfer_id, direction, log)
      event_id = TransferIds.canonical_event_id(canonical_transfer_id)

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
          |> mark_correlation_status(transfer_id)
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
    {correlatable_events, uncorrelatable_events} =
      Enum.split_with(bridge_events, &protocol_correlatable?/1)

    correlated_transfers =
      correlatable_events
      |> Enum.group_by(& &1.canonical_transfer_id)
      |> Enum.map(fn {_canonical_id, events} -> build_canonical_bridge_transfer(events) end)

    uncorrelatable_transfers =
      Enum.map(uncorrelatable_events, fn event -> build_canonical_bridge_transfer([event]) end)

    (correlated_transfers ++ uncorrelatable_transfers)
    |> Enum.sort_by(
      fn transfer ->
        {transfer.block_number || 0, transfer.log_index || 0}
      end,
      :desc
    )
  end

  defp protocol_correlatable?(event), do: not is_nil(event.cross_chain_transfer_id)

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
      cond do
        topic == Map.get(validator_topics, :validator_set_updated) ->
          {:validator_set_updated, fn _log -> %{} end}

        topic == Map.get(validator_topics, :validator_deposit) ->
          {:validator_deposit, &parse_validator_amount_event/1}

        topic == Map.get(validator_topics, :validator_misdemeanor) ->
          {:validator_misdemeanor, &parse_validator_amount_event/1}

        topic == Map.get(validator_topics, :validator_felony) ->
          {:validator_felony, &parse_validator_amount_event/1}

        topic == Map.get(validator_topics, :validator_enter_maintenance) ->
          {:validator_enter_maintenance, &parse_validator_address_event/1}

        topic == Map.get(validator_topics, :validator_exit_maintenance) ->
          {:validator_exit_maintenance, &parse_validator_address_event/1}

        topic == Map.get(validator_topics, :finality_reward_deposit) ->
          {:finality_reward_deposit, &parse_validator_amount_event/1}

        topic == Map.get(validator_topics, :fee_burned) ->
          {:fee_burned, &parse_amount_only_event/1}

        true ->
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

  defp mark_correlation_status(metadata, nil) do
    Map.merge(metadata, %{
      "correlation_status" => "uncorrelatable",
      "correlation_reason" => "missing_protocol_transfer_id"
    })
  end

  defp mark_correlation_status(metadata, _transfer_id) do
    Map.put(metadata, "correlation_status", "protocol_transfer_id")
  end

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
