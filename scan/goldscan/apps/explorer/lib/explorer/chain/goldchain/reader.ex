defmodule Explorer.Chain.Goldchain.Reader do
  @moduledoc """
  Read helpers for Gold Chain decoded bridge and lifecycle events.
  """

  import Ecto.Query, only: [field: 2, from: 2, limit: 2]
  import Explorer.Chain, only: [default_paging_options: 0, select_repo: 1]

  alias Explorer.Chain.Goldchain.{
    BridgeTransfer,
    GovernanceEvent,
    StakingEvent,
    ValidatorEvent
  }

  alias Explorer.Chain.TransactionAction
  alias Explorer.PagingOptions

  @spec deposits(keyword()) :: list()
  def deposits(options \\ []) do
    paging_options = Keyword.get(options, :paging_options, default_paging_options())

    case paging_options do
      %PagingOptions{key: {0}} ->
        []

      _ ->
        base_query =
          from(
            bt in BridgeTransfer,
            where:
              bt.direction == :deposit and
                bt.bridge_state in [:locked, :synced, :minted_or_credited, :failed],
            select: %{
              canonical_transfer_id: bt.canonical_transfer_id,
              block_number: bt.block_number,
              log_index: bt.log_index,
              l1_block_number: bt.root_block_number,
              l2_block_number: bt.child_block_number,
              l1_transaction_hash: bt.root_transaction_hash,
              l2_transaction_hash: bt.child_transaction_hash,
              user: bt.account_address_hash,
              timestamp: bt.block_timestamp,
              finality_status: bt.finality_status,
              bridge_state: bt.bridge_state,
              route_asset: bt.route_asset,
              child_amount: bt.child_amount,
              root_amount: bt.root_amount
            },
            order_by: [desc: bt.block_number, desc: bt.log_index]
          )

        base_query
        |> page_deposits(paging_options)
        |> limit(^paging_options.page_size)
        |> select_repo(options).all()
    end
  end

  @spec deposits_count(keyword()) :: non_neg_integer()
  def deposits_count(options \\ []) do
    query =
      from(bt in BridgeTransfer,
        where:
          bt.direction == :deposit and
            bt.bridge_state in [:locked, :synced, :minted_or_credited, :failed]
      )

    select_repo(options).aggregate(query, :count, timeout: :infinity)
  end

  @spec withdrawals(keyword()) :: list()
  def withdrawals(options \\ []) do
    paging_options = Keyword.get(options, :paging_options, default_paging_options())

    case paging_options do
      %PagingOptions{key: {0}} ->
        []

      _ ->
        base_query =
          from(
            bt in BridgeTransfer,
            where:
              bt.direction == :withdrawal and
                bt.bridge_state in [:burned_or_debited, :released, :failed],
            select: %{
              canonical_transfer_id: bt.canonical_transfer_id,
              block_number: bt.block_number,
              log_index: bt.log_index,
              l1_block_number: bt.root_block_number,
              l2_block_number: bt.child_block_number,
              l2_transaction_hash: bt.child_transaction_hash,
              l1_transaction_hash: bt.root_transaction_hash,
              user: bt.account_address_hash,
              timestamp: bt.block_timestamp,
              finality_status: bt.finality_status,
              bridge_state: bt.bridge_state,
              route_asset: bt.route_asset,
              child_amount: bt.child_amount,
              root_amount: bt.root_amount
            },
            order_by: [desc: bt.block_number, desc: bt.log_index]
          )

        base_query
        |> page_withdrawals(paging_options)
        |> limit(^paging_options.page_size)
        |> select_repo(options).all()
    end
  end

  @spec withdrawals_count(keyword()) :: non_neg_integer()
  def withdrawals_count(options \\ []) do
    query =
      from(bt in BridgeTransfer,
        where:
          bt.direction == :withdrawal and
            bt.bridge_state in [:burned_or_debited, :released, :failed]
      )

    select_repo(options).aggregate(query, :count, timeout: :infinity)
  end

  @spec validator_events(keyword()) :: list()
  def validator_events(options \\ []) do
    paging_options = Keyword.get(options, :paging_options, default_paging_options())
    address_hash = resolve_validator_filter_address(options)

    ValidatorEvent
    |> maybe_filter_validator_address(address_hash)
    |> order_by_desc_block()
    |> page_by_block(paging_options)
    |> limit(^paging_options.page_size)
    |> select_repo(options).all()
  end

  @spec validator_events_count(keyword()) :: non_neg_integer()
  def validator_events_count(options \\ []) do
    address_hash = resolve_validator_filter_address(options)

    ValidatorEvent
    |> maybe_filter_validator_address(address_hash)
    |> select_repo(options).aggregate(:count, timeout: :infinity)
  end

  @spec staking_events(keyword()) :: list()
  def staking_events(options \\ []) do
    paging_options = Keyword.get(options, :paging_options, default_paging_options())

    StakingEvent
    |> order_by_desc_block()
    |> page_by_block(paging_options)
    |> limit(^paging_options.page_size)
    |> select_repo(options).all()
  end

  @spec staking_events_count(keyword()) :: non_neg_integer()
  def staking_events_count(options \\ []) do
    select_repo(options).aggregate(StakingEvent, :count, timeout: :infinity)
  end

  @spec governance_events(keyword()) :: list()
  def governance_events(options \\ []) do
    paging_options = Keyword.get(options, :paging_options, default_paging_options())

    GovernanceEvent
    |> order_by_desc_block()
    |> page_by_block(paging_options)
    |> limit(^paging_options.page_size)
    |> select_repo(options).all()
  end

  @spec governance_events_count(keyword()) :: non_neg_integer()
  def governance_events_count(options \\ []) do
    select_repo(options).aggregate(GovernanceEvent, :count, timeout: :infinity)
  end

  @spec bridge_transfers(keyword()) :: list()
  def bridge_transfers(options \\ []) do
    paging_options = Keyword.get(options, :paging_options, default_paging_options())

    BridgeTransfer
    |> apply_bridge_transfer_filters(options)
    |> order_by_desc_block()
    |> page_by_block_log_id(paging_options)
    |> limit(^paging_options.page_size)
    |> select_repo(options).all()
  end

  @spec bridge_transfers_count(keyword()) :: non_neg_integer()
  def bridge_transfers_count(options \\ []) do
    BridgeTransfer
    |> apply_bridge_transfer_filters(options)
    |> select_repo(options).aggregate(:count, timeout: :infinity)
  end

  @spec decoded_actions(keyword()) :: list()
  def decoded_actions(options \\ []) do
    paging_options = Keyword.get(options, :paging_options, default_paging_options())
    tx_hash = Keyword.get(options, :transaction_hash)

    base_query =
      from(
        action in TransactionAction,
        where: action.protocol == :goldchain,
        order_by: [desc: action.hash, desc: action.log_index]
      )

    base_query
    |> maybe_filter_decoded_action_transaction_hash(tx_hash)
    |> page_decoded_actions(paging_options)
    |> limit(^paging_options.page_size)
    |> select_repo(options).all()
  end

  @spec decoded_actions_count(keyword()) :: non_neg_integer()
  def decoded_actions_count(options \\ []) do
    tx_hash = Keyword.get(options, :transaction_hash)

    from(action in TransactionAction, where: action.protocol == :goldchain)
    |> maybe_filter_decoded_action_transaction_hash(tx_hash)
    |> select_repo(options).aggregate(:count, timeout: :infinity)
  end

  defp order_by_desc_block(query) do
    from(item in query, order_by: [desc: item.block_number, desc: item.log_index])
  end

  defp page_deposits(query, %PagingOptions{key: nil}), do: query

  defp page_deposits(query, %PagingOptions{key: {block_number, log_index, canonical_transfer_id}}) do
    from(
      item in query,
      where:
        item.block_number < ^block_number or
          (item.block_number == ^block_number and item.log_index < ^log_index) or
          (item.block_number == ^block_number and item.log_index == ^log_index and
             item.canonical_transfer_id < ^canonical_transfer_id)
    )
  end

  defp page_deposits(query, %PagingOptions{key: {block_number}}) do
    from(item in query, where: item.l1_block_number < ^block_number)
  end

  defp page_withdrawals(query, %PagingOptions{key: nil}), do: query

  defp page_withdrawals(query, %PagingOptions{key: {block_number, log_index, canonical_transfer_id}}) do
    from(
      item in query,
      where:
        item.block_number < ^block_number or
          (item.block_number == ^block_number and item.log_index < ^log_index) or
          (item.block_number == ^block_number and item.log_index == ^log_index and
             item.canonical_transfer_id < ^canonical_transfer_id)
    )
  end

  defp page_withdrawals(query, %PagingOptions{key: {block_number}}) do
    from(item in query, where: item.l2_block_number < ^block_number)
  end

  defp page_by_block(query, %PagingOptions{key: nil}), do: query

  defp page_by_block(query, %PagingOptions{key: {block_number, log_index}}) do
    from(
      item in query,
      where:
        item.block_number < ^block_number or
          (item.block_number == ^block_number and item.log_index < ^log_index)
    )
  end

  defp page_by_block(query, %PagingOptions{key: {block_number}}) do
    from(item in query, where: item.block_number < ^block_number)
  end

  defp page_by_block_log_id(query, %PagingOptions{key: nil}), do: query

  defp page_by_block_log_id(query, %PagingOptions{key: {block_number, log_index, canonical_transfer_id}}) do
    from(
      item in query,
      where:
        item.block_number < ^block_number or
          (item.block_number == ^block_number and item.log_index < ^log_index) or
          (item.block_number == ^block_number and item.log_index == ^log_index and
             item.canonical_transfer_id < ^canonical_transfer_id)
    )
  end

  defp page_by_block_log_id(query, %PagingOptions{key: {block_number}}) do
    page_by_block(query, %PagingOptions{key: {block_number}})
  end

  defp apply_bridge_transfer_filters(query, options) do
    query
    |> maybe_filter_bridge_transaction_hash(Keyword.get(options, :transaction_hash))
    |> maybe_filter_equals(:account_address_hash, Keyword.get(options, :account_address_hash))
    |> maybe_filter_equals(:counterparty_address_hash, Keyword.get(options, :counterparty_address_hash))
    |> maybe_filter_equals(:bridge_state, Keyword.get(options, :bridge_state))
    |> maybe_filter_equals(:finality_status, Keyword.get(options, :finality_status))
    |> maybe_filter_equals(:direction, Keyword.get(options, :direction))
    |> maybe_filter_equals(:source_layer, Keyword.get(options, :source_layer))
    |> maybe_filter_equals(:cross_chain_transfer_id, Keyword.get(options, :cross_chain_transfer_id))
    |> maybe_filter_equals(:canonical_transfer_id, Keyword.get(options, :canonical_transfer_id))
    |> maybe_filter_route_asset(Keyword.get(options, :route_asset))
  end

  defp maybe_filter_bridge_transaction_hash(query, nil), do: query

  defp maybe_filter_bridge_transaction_hash(query, transaction_hash) do
    from(
      item in query,
      where:
        item.transaction_hash == ^transaction_hash or item.root_transaction_hash == ^transaction_hash or
          item.child_transaction_hash == ^transaction_hash
    )
  end

  defp maybe_filter_decoded_action_transaction_hash(query, nil), do: query

  defp maybe_filter_decoded_action_transaction_hash(query, transaction_hash) do
    from(action in query, where: action.hash == ^transaction_hash)
  end

  defp page_decoded_actions(query, %PagingOptions{key: nil}), do: query

  defp page_decoded_actions(query, %PagingOptions{key: {transaction_hash, log_index}}) do
    from(
      action in query,
      where: action.hash < ^transaction_hash or (action.hash == ^transaction_hash and action.log_index < ^log_index)
    )
  end

  defp page_decoded_actions(query, _), do: query

  defp maybe_filter_route_asset(query, nil), do: query

  defp maybe_filter_route_asset(query, route_asset) when is_atom(route_asset) do
    from(item in query, where: item.route_asset == ^route_asset)
  end

  defp maybe_filter_route_asset(query, route_asset) when is_binary(route_asset) do
    case String.downcase(route_asset) do
      "paxg" -> from(item in query, where: item.route_asset == :paxg)
      "xaut" -> from(item in query, where: item.route_asset == :xaut)
      _ -> query
    end
  end

  defp maybe_filter_equals(query, _field, nil), do: query

  defp maybe_filter_equals(query, field, value) do
    from(item in query, where: field(item, ^field) == ^value)
  end

  defp resolve_validator_filter_address(options) do
    options
    |> Keyword.get(:address_hash)
    |> case do
      nil -> Keyword.get(options, :validator_address_hash)
      address_hash -> address_hash
    end
    |> case do
      nil -> Keyword.get(options, :operator_address_hash)
      address_hash -> address_hash
    end
    |> normalize_filter_address()
  end

  defp maybe_filter_validator_address(query, nil), do: query

  defp maybe_filter_validator_address(query, address_hash) do
    from(
      item in query,
      where: item.validator_address_hash == ^address_hash or item.operator_address_hash == ^address_hash
    )
  end

  defp normalize_filter_address(nil), do: nil
  defp normalize_filter_address(address_hash) when is_binary(address_hash), do: String.downcase(address_hash)
  defp normalize_filter_address(address_hash), do: address_hash
end
