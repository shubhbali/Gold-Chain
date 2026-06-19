defmodule Indexer.Transform.Goldchain.Lifecycle.TransferIds do
  @moduledoc """
  Builds bridge lifecycle identifiers without unsafe participant/asset/amount fallback correlation.

  Logs with a protocol transfer ID share a canonical transfer ID. Logs without one are
  intentionally marked with a per-log uncorrelatable ID so they cannot be grouped with
  other bridge legs by heuristic hashes.
  """

  alias Indexer.Helper

  @spec canonical_transfer_id(integer() | nil, atom() | nil, map()) :: String.t()
  def canonical_transfer_id(nil, direction, log) do
    "xfer-uncorrelatable-#{direction || :unknown}-#{log_ref(log)}"
  end

  def canonical_transfer_id(transfer_id, direction, _log) do
    "xfer-#{transfer_id}-#{direction || :unknown}"
  end

  @spec canonical_event_id(String.t()) :: String.t()
  def canonical_event_id(canonical_transfer_id) do
    "0x" <> Base.encode16(ExKeccak.hash_256("canonical:#{canonical_transfer_id}"), case: :lower)
  end

  defp log_ref(log) do
    tx_hash = Helper.address_hash_to_string(log.transaction_hash, true)
    log_index = log.index || 0
    "#{tx_hash}-#{log_index}"
  end
end
