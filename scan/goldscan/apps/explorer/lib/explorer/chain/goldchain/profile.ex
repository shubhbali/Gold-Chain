defmodule Explorer.Chain.Goldchain.Profile do
  @moduledoc """
  Validates the runtime configuration contract for Gold Chain indexing and decoding.

  The same codepath is used across testnet and mainnet; only profile values differ.
  """

  alias Indexer.Helper, as: IndexerHelper

  @required_keys ~w(
    root_rpc
    root_start_block
    poll_interval
    root_finality_confirmations
    child_finality_confirmations
    root_bridge_contracts
    child_bridge_contracts
    validator_contracts
    staking_contracts
    governance_contracts
    migration_contracts
  )a

  @spec validate_runtime_config!() :: :ok
  def validate_runtime_config! do
    if Application.get_env(:explorer, :chain_type) == :goldchain do
      config = Application.get_env(:explorer, __MODULE__, [])
      chain_id = Application.get_env(:goldscan_web, :chain_id)
      chain_metadata = Application.get_env(:goldscan_web, GoldScanWeb.Chain, [])

      missing_keys =
        @required_keys
        |> Enum.filter(fn key ->
          case Keyword.get(config, key) do
            nil -> true
            "" -> true
            [] -> true
            _ -> false
          end
        end)

      if missing_keys != [] do
        raise """
        Gold Chain profile configuration is incomplete.
        Missing required keys: #{Enum.join(Enum.map(missing_keys, &to_string/1), ", ")}
        """
      end

      validate_url!(Keyword.fetch!(config, :root_rpc), :root_rpc)
      validate_non_negative_integer!(Keyword.fetch!(config, :root_start_block), :root_start_block)
      validate_positive_integer!(Keyword.fetch!(config, :poll_interval), :poll_interval)
      validate_positive_integer!(Keyword.fetch!(config, :root_finality_confirmations), :root_finality_confirmations)
      validate_positive_integer!(Keyword.fetch!(config, :child_finality_confirmations), :child_finality_confirmations)
      validate_chain_id!(chain_id)
      validate_non_empty_string!(Keyword.get(chain_metadata, :network), :network)
      validate_non_empty_string!(Keyword.get(chain_metadata, :subnetwork), :subnetwork)

      [
        :root_bridge_contracts,
        :child_bridge_contracts,
        :validator_contracts,
        :staking_contracts,
        :governance_contracts,
        :migration_contracts
      ]
      |> Enum.each(fn key ->
        validate_address_list!(Keyword.fetch!(config, key), key)
      end)

      validate_route_asset_map!(
        Keyword.get(config, :root_route_asset_by_token, %{}),
        :root_route_asset_by_token
      )

    end

    :ok
  end

  defp validate_url!(url, key) when is_binary(url) do
    uri = URI.parse(url)

    if is_nil(uri.scheme) or is_nil(uri.host) do
      raise "Invalid Gold Chain profile URL for #{key}: #{inspect(url)}"
    end
  end

  defp validate_url!(value, key), do: raise("Invalid Gold Chain profile URL for #{key}: #{inspect(value)}")

  defp validate_non_negative_integer!(value, key)
       when is_integer(value) and value >= 0,
       do: :ok

  defp validate_non_negative_integer!(value, key),
    do: raise("Invalid non-negative integer for #{key}: #{inspect(value)}")

  defp validate_positive_integer!(value, key)
       when is_integer(value) and value > 0,
       do: :ok

  defp validate_positive_integer!(value, key),
    do: raise("Invalid positive integer for #{key}: #{inspect(value)}")

  defp validate_chain_id!(value) when is_integer(value) and value > 0, do: :ok

  defp validate_chain_id!(value) when is_binary(value) do
    case Integer.parse(value) do
      {chain_id, ""} when chain_id > 0 -> :ok
      _ -> raise("Invalid CHAIN_ID for goldchain profile: #{inspect(value)}")
    end
  end

  defp validate_chain_id!(value), do: raise("Invalid CHAIN_ID for goldchain profile: #{inspect(value)}")

  defp validate_non_empty_string!(value, _key) when is_binary(value) and value != "", do: :ok

  defp validate_non_empty_string!(value, key),
    do: raise("Invalid #{key} for goldchain profile: #{inspect(value)}")

  defp validate_address_list!(values, _key) when is_list(values) and values == [], do: :ok

  defp validate_address_list!(values, key) when is_list(values) do
    invalid =
      values
      |> Enum.reject(&IndexerHelper.address_correct?/1)

    if invalid != [] do
      raise "Invalid address list for #{key}: #{inspect(invalid)}"
    end
  end

  defp validate_address_list!(value, key),
    do: raise("Invalid address list for #{key}: #{inspect(value)}")

  defp validate_route_asset_map!(map, _key) when is_map(map) do
    invalid_entries =
      map
      |> Enum.reject(fn {token, route_asset} ->
        token_valid? = is_binary(token) and IndexerHelper.address_correct?(token)

        route_asset_valid? =
          case route_asset do
            :paxg -> true
            :xaut -> true
            "paxg" -> true
            "xaut" -> true
            "PAXG" -> true
            "XAUT" -> true
            _ -> false
          end

        token_valid? and route_asset_valid?
      end)

    if invalid_entries != [] do
      raise "Invalid root route asset mapping entries: #{inspect(invalid_entries)}"
    end
  end

  defp validate_route_asset_map!(value, key),
    do: raise("Invalid route asset map for #{key}: #{inspect(value)}")

end
