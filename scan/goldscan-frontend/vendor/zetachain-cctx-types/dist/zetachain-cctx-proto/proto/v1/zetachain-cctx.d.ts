export declare enum Direction {
    ASC = "ASC",
    DESC = "DESC",
    UNRECOGNIZED = "UNRECOGNIZED"
}
export declare enum CoinType {
    ZETA = "ZETA",
    /** GAS - Ether, BNB, Matic, Klay, BTC, etc */
    GAS = "GAS",
    /** ERC20 - ERC20 token */
    ERC20 = "ERC20",
    /** CMD - no asset, used for admin command */
    CMD = "CMD",
    /** NO_ASSET_CALL - no asset, used for contract call */
    NO_ASSET_CALL = "NO_ASSET_CALL",
    UNRECOGNIZED = "UNRECOGNIZED"
}
export declare enum CctxStatus {
    /** PENDING_INBOUND - some observer sees inbound tx */
    PENDING_INBOUND = "PENDING_INBOUND",
    /** PENDING_OUTBOUND - super majority observer see inbound tx */
    PENDING_OUTBOUND = "PENDING_OUTBOUND",
    /** OUTBOUND_MINED - the corresponding outbound tx is mined */
    OUTBOUND_MINED = "OUTBOUND_MINED",
    /** PENDING_REVERT - outbound cannot succeed; should revert inbound */
    PENDING_REVERT = "PENDING_REVERT",
    /** REVERTED - inbound reverted. */
    REVERTED = "REVERTED",
    /** ABORTED - inbound tx error or invalid paramters and cannot revert; just abort. */
    ABORTED = "ABORTED",
    UNRECOGNIZED = "UNRECOGNIZED"
}
export declare enum CctxStatusReduced {
    PENDING = "PENDING",
    SUCCESS = "SUCCESS",
    FAILED = "FAILED",
    UNRECOGNIZED = "UNRECOGNIZED"
}
export declare enum TxFinalizationStatus {
    /** NOT_FINALIZED - the corresponding tx is not finalized */
    NOT_FINALIZED = "NOT_FINALIZED",
    /** FINALIZED - the corresponding tx is finalized but not executed yet */
    FINALIZED = "FINALIZED",
    /** EXECUTED - the corresponding tx is executed */
    EXECUTED = "EXECUTED",
    UNRECOGNIZED = "UNRECOGNIZED"
}
export declare enum ConfirmationMode {
    /** SAFE - an inbound/outbound is confirmed using safe confirmation count */
    SAFE = "SAFE",
    /** FAST - an inbound/outbound is confirmed using fast confirmation count */
    FAST = "FAST",
    UNRECOGNIZED = "UNRECOGNIZED"
}
/** InboundStatus represents the status of an observed inbound */
export declare enum InboundStatus {
    INBOUND_SUCCESS = "INBOUND_SUCCESS",
    /**
     * INSUFFICIENT_DEPOSITOR_FEE - this field is specifically for Bitcoin when the deposit amount is less than
     * depositor fee
     */
    INSUFFICIENT_DEPOSITOR_FEE = "INSUFFICIENT_DEPOSITOR_FEE",
    /** INVALID_RECEIVER_ADDRESS - the receiver address parsed from the inbound is invalid */
    INVALID_RECEIVER_ADDRESS = "INVALID_RECEIVER_ADDRESS",
    /** INVALID_MEMO - parse memo is invalid */
    INVALID_MEMO = "INVALID_MEMO",
    UNRECOGNIZED = "UNRECOGNIZED"
}
/**
 * ProtocolContractVersion represents the version of the protocol contract used
 * for cctx workflow
 */
export declare enum ProtocolContractVersion {
    V1 = "V1",
    V2 = "V2",
    UNRECOGNIZED = "UNRECOGNIZED"
}
export interface ListTokensRequest {
}
export interface GetCctxInfoRequest {
    cctx_id: string;
}
export interface ListCctxsRequest {
    limit: number;
    page_key?: number | undefined;
    direction: Direction;
    /** Comma-separated values for multiple filters */
    status_reduced?: string | undefined;
    /** "0x123,0x456,0x789" */
    sender_address?: string | undefined;
    /** "0xabc,0xdef,0xghi" */
    receiver_address?: string | undefined;
    /** "0x123,0x456,0x789" */
    asset?: string | undefined;
    /** "Zeta,Gas,Erc20" */
    coin_type?: string | undefined;
    /** "1,56,137" */
    source_chain_id?: string | undefined;
    /** "1,56,137" */
    target_chain_id?: string | undefined;
    /** "ETH,BTC,USDC" */
    token_symbol?: string | undefined;
    start_timestamp?: number | undefined;
    end_timestamp?: number | undefined;
    /** hash of the inbound tx or cctx hash */
    hash?: string | undefined;
}
export interface ListCctxsResponse {
    items: CctxListItem[];
    next_page_params: Pagination | undefined;
}
export interface Pagination {
    page_key: number;
    limit: number;
    direction: Direction;
}
export interface InboundParams {
    /** this address is the immediate contract/EOA that calls */
    sender: string;
    /** the Connector.send() */
    sender_chain_id: number;
    /** this address is the EOA that signs the inbound tx */
    tx_origin: string;
    coin_type: CoinType;
    /** for ERC20 coin type, the asset is an address of the ERC20 contract */
    asset: string;
    amount: string;
    observed_hash: string;
    observed_external_height: number;
    ballot_index: string;
    finalized_zeta_height: number;
    tx_finalization_status: TxFinalizationStatus;
    /**
     * this field describes if a smart contract call should be made for a inbound
     * with assets only used for protocol contract version 2
     */
    is_cross_chain_call: boolean;
    /** status of the inbound observation */
    status: InboundStatus;
    /** confirmation mode used for the inbound */
    confirmation_mode: ConfirmationMode;
}
export interface ZetaAccounting {
    /**
     * aborted_zeta_amount stores the total aborted amount for cctx of coin-type
     * ZETA
     */
    aborted_zeta_amount: string;
}
export interface CallOptions {
    gas_limit?: number | undefined;
    is_arbitrary_call?: boolean | undefined;
}
export interface OutboundParams {
    receiver: string;
    receiver_chain_id: number;
    coin_type: CoinType;
    amount: string;
    tss_nonce: number;
    /** Deprecated (v21), use CallOptions */
    gas_limit: number;
    gas_price: string;
    gas_priority_fee: string;
    /**
     * the above are commands for zetaclients
     * the following fields are used when the outbound tx is mined
     */
    hash?: string | undefined;
    ballot_index: string;
    observed_external_height: number;
    gas_used: number;
    effective_gas_price: string;
    effective_gas_limit: number;
    tss_pubkey: string;
    tx_finalization_status: TxFinalizationStatus;
    call_options: CallOptions | undefined;
    /** confirmation mode used for the outbound */
    confirmation_mode: ConfirmationMode;
}
export interface Status {
    status: CctxStatus;
    /**
     * status_message carries information about the status transitions:
     * why they were triggered, old and new status.
     */
    status_message: string;
    /**
     * error_message carries information about the error that caused the tx
     * to be PendingRevert, Reverted or Aborted.
     */
    error_message: string;
    last_update_timestamp: number;
    is_abort_refunded: boolean;
    /** when the CCTX was created. only populated on new transactions. */
    created_timestamp: number;
    /**
     * error_message_revert carries information about the revert outbound tx ,
     * which is created if the first outbound tx fails
     */
    error_message_revert: string;
    /** error_message_abort carries information when aborting the CCTX fails */
    error_message_abort: string;
}
/** RevertOptions represents the options for reverting a cctx */
export interface RevertOptions {
    revert_address: string;
    call_on_revert: boolean;
    abort_address: string;
    revert_message?: string | undefined;
    revert_gas_limit: string;
}
export interface CctxListItem {
    index: string;
    status: CctxStatus;
    status_reduced: CctxStatusReduced;
    amount: string;
    source_chain_id: number;
    target_chain_id: number;
    created_timestamp: number;
    last_update_timestamp: number;
    sender_address: string;
    receiver_address: string;
    asset: string;
    coin_type: CoinType;
    token_symbol?: string | undefined;
    zrc20_contract_address?: string | undefined;
    decimals?: number | undefined;
}
export interface RelatedCctx {
    index: string;
    depth: number;
    source_chain_id: number;
    status: CctxStatus;
    status_reduced: CctxStatusReduced;
    inbound_amount: string;
    inbound_coin_type: CoinType;
    outbound_params: RelatedOutboundParams[];
    token_symbol?: string | undefined;
    token_name?: string | undefined;
    token_decimals?: number | undefined;
    token_zrc20_contract_address?: string | undefined;
    token_icon_url?: string | undefined;
    created_timestamp: number;
    parent_index?: string | undefined;
    inbound_asset?: string | undefined;
}
export interface RelatedOutboundParams {
    amount: string;
    chain_id: number;
    coin_type: CoinType;
    gas_used: number;
}
export interface CrossChainTx {
    creator: string;
    index: string;
    zeta_fees: string;
    /** Not used by protocol , just relayed across */
    relayed_message: string;
    cctx_status: Status | undefined;
    cctx_status_reduced: CctxStatusReduced;
    inbound_params: InboundParams | undefined;
    outbound_params: OutboundParams[];
    protocol_contract_version: ProtocolContractVersion;
    revert_options?: RevertOptions | undefined;
    related_cctxs: RelatedCctx[];
    token_symbol?: string | undefined;
    token_name?: string | undefined;
    zrc20_contract_address?: string | undefined;
    icon_url?: string | undefined;
    decimals?: number | undefined;
}
export interface GetTokenInfoRequest {
    asset: string;
}
export interface Token {
    foreign_chain_id: number;
    decimals: number;
    name: string;
    symbol: string;
    zrc20_contract_address: string;
    icon_url?: string | undefined;
    coin_type: CoinType;
}
export interface Tokens {
    tokens: Token[];
}
export interface CctxInfo {
    GetCctxInfo(request: GetCctxInfoRequest): Promise<CrossChainTx>;
    ListCctxs(request: ListCctxsRequest): Promise<ListCctxsResponse>;
}
export interface TokenInfo {
    GetTokenInfo(request: GetTokenInfoRequest): Promise<Token>;
    ListTokens(request: ListTokensRequest): Promise<Tokens>;
}
