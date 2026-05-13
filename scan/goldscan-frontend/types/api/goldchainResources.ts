import type { AddressParam } from './addressParams';

export type GoldchainFinalityStatus = 'pending' | 'finalized' | 'reverted' | 'disputed';

export interface GoldchainValidatorEventItem {
  event_id: string;
  transaction_hash: string;
  log_index: number;
  block_number: number;
  block_timestamp: string | null;
  event_type: string;
  validator_address_hash: AddressParam | string | null;
  operator_address_hash: AddressParam | string | null;
  amount: string | null;
  slash_type: number | null;
  finality_status: GoldchainFinalityStatus;
}

export interface GoldchainStakingEventItem {
  event_id: string;
  transaction_hash: string;
  log_index: number;
  block_number: number;
  block_timestamp: string | null;
  event_type: string;
  operator_address_hash: AddressParam | string | null;
  delegator_address_hash: AddressParam | string | null;
  src_validator_address_hash: AddressParam | string | null;
  dst_validator_address_hash: AddressParam | string | null;
  gilt_amount: string | null;
  shares: string | null;
  old_shares: string | null;
  new_shares: string | null;
  reward_amount: string | null;
  finality_status: GoldchainFinalityStatus;
}

export interface GoldchainGovernanceEventItem {
  event_id: string;
  transaction_hash: string;
  log_index: number;
  block_number: number;
  block_timestamp: string | null;
  event_type: string;
  governance_actor_address_hash: AddressParam | string | null;
  route_asset: string | null;
  amount: string | null;
  token_id: string | null;
  finality_status: GoldchainFinalityStatus;
}

export interface GoldchainDecodedActionItem {
  hash: string;
  protocol: 'goldchain' | string;
  type: string;
  log_index: number;
  data: Record<string, unknown>;
}

export interface GoldchainPaginatedResponse<T> {
  items: Array<T>;
  next_page_params: {
    block_number?: number;
    transaction_hash?: string;
    log_index: number;
    canonical_transfer_id?: string;
    items_count: number;
  } | null;
}
