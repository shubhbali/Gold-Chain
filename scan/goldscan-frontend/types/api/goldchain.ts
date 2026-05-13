import type { AddressParam } from './addressParams';

export type GoldchainBridgeFinalityStatus = 'pending' | 'finalized' | 'reverted' | 'disputed';
export type GoldchainBridgeState = 'locked' | 'synced' | 'minted_or_credited' | 'burned_or_debited' | 'released' | 'failed';
export type GoldchainRouteAsset = 'paxg' | 'xaut' | 'PAXG' | 'XAUT' | null;

export interface GoldchainBridgeTransferItem {
  canonical_transfer_id: string;
  block_number: number;
  log_index: number;
  l1_block_number: number | null;
  l2_block_number: number | null;
  l1_transaction_hash: string | null;
  l2_transaction_hash: string | null;
  user: AddressParam | string | null;
  timestamp: string | null;
  finality_status: GoldchainBridgeFinalityStatus;
  bridge_state: GoldchainBridgeState;
  route_asset: GoldchainRouteAsset;
  root_amount: string | null;
  child_amount: string | null;
}

export interface GoldchainBridgeTransfersResponse {
  items: Array<GoldchainBridgeTransferItem>;
  next_page_params: {
    block_number: number;
    log_index: number;
    canonical_transfer_id: string;
    items_count: number;
  } | null;
}

