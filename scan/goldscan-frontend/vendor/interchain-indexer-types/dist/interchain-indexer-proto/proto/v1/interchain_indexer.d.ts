export declare enum MessageStatus {
    MESSAGE_STATUS_INITIATED = "MESSAGE_STATUS_INITIATED",
    MESSAGE_STATUS_COMPLETED = "MESSAGE_STATUS_COMPLETED",
    MESSAGE_STATUS_FAILED = "MESSAGE_STATUS_FAILED",
    UNRECOGNIZED = "UNRECOGNIZED"
}
export interface Pagination {
    page_token?: string | undefined;
    timestamp?: number | undefined;
    message_id?: string | undefined;
    bridge_id?: number | undefined;
    index?: number | undefined;
    direction?: string | undefined;
}
export interface GetMessagesRequest {
    /** multisearch ability */
    q?: string | undefined;
    /** Items on a page: bounded by the API settings */
    page_size?: number | undefined;
    /** If true, return only the last page (pagination token is ignored) */
    last_page?: boolean | undefined;
    /**
     * input pagination token - used by default
     * (packed version of the raw pagination parameters)
     */
    page_token?: string | undefined;
    /**
     * Raw pagination parameters
     * (used when api.use_pagination_token=false)
     */
    timestamp?: number | undefined;
    /** Raw pagination field */
    message_id?: string | undefined;
    /** Raw pagination field */
    bridge_id?: number | undefined;
    /** Raw pagination field */
    direction?: string | undefined;
}
export interface GetMessageDetailsRequest {
    message_id: string;
}
export interface GetMessagesByTransactionRequest {
    tx_hash: string;
    /** Items on a page: bounded by the API settings */
    page_size?: number | undefined;
    /** If true, return only the last page (pagination token is ignored) */
    last_page?: boolean | undefined;
    /**
     * input pagination token - used by default
     * (packed version of the raw pagination parameters)
     */
    page_token?: string | undefined;
    /**
     * Raw pagination parameters
     * (used when api.use_pagination_token=false)
     */
    timestamp?: number | undefined;
    /** Raw pagination field */
    message_id?: string | undefined;
    /** Raw pagination field */
    bridge_id?: number | undefined;
    /** Raw pagination field */
    direction?: string | undefined;
}
export interface GetMessagesByAddressRequest {
    address: string;
    /** Items on a page: bounded by the API settings */
    page_size?: number | undefined;
    /** If true, return only the last page (pagination token is ignored) */
    last_page?: boolean | undefined;
    /**
     * input pagination token - used by default
     * (packed version of the raw pagination parameters)
     */
    page_token?: string | undefined;
    /**
     * Raw pagination parameters
     * (used when api.use_pagination_token=false)
     */
    timestamp?: number | undefined;
    /** Raw pagination field */
    message_id?: string | undefined;
    /** Raw pagination field */
    bridge_id?: number | undefined;
    /** Raw pagination field */
    direction?: string | undefined;
}
export interface AddressInfo {
    hash: string;
    ens_domain_name?: string | undefined;
}
export interface BridgeInfo {
    name: string;
    ui_url?: string | undefined;
    docs_url?: string | undefined;
}
export interface ChainInfo {
    id: string;
    name: string;
    logo?: string | undefined;
    explorer_url?: string | undefined;
    custom_tx_route?: string | undefined;
    custom_address_route?: string | undefined;
    custom_token_route?: string | undefined;
}
export interface InterchainMessage {
    bridge: BridgeInfo | undefined;
    message_id: string;
    status: MessageStatus;
    source_chain: ChainInfo | undefined;
    send_timestamp: string;
    sender?: AddressInfo | undefined;
    source_transaction_hash?: string | undefined;
    destination_chain: ChainInfo | undefined;
    receive_timestamp?: string | undefined;
    recipient?: AddressInfo | undefined;
    destination_transaction_hash?: string | undefined;
    payload?: string | undefined;
    /** additional parsed data */
    extra: {
        [key: string]: string;
    };
    transfers: InterchainTransfer[];
}
export interface InterchainMessage_ExtraEntry {
    key: string;
    value: string;
}
export interface GetMessagesResponse {
    items: InterchainMessage[];
    next_page_params?: Pagination | undefined;
    prev_page_params?: Pagination | undefined;
}
export interface GetTransfersRequest {
    /** multisearch ability */
    q?: string | undefined;
    /** Items on a page: bounded by the API settings */
    page_size?: number | undefined;
    /** If true, return only the last page (pagination token is ignored) */
    last_page?: boolean | undefined;
    /**
     * input pagination token - used by default
     * (packed version of the raw pagination parameters)
     */
    page_token?: string | undefined;
    /**
     * Raw pagination parameters
     * (used when api.use_pagination_token=false)
     */
    timestamp?: number | undefined;
    /** Raw pagination field */
    message_id?: string | undefined;
    /** Raw pagination field */
    bridge_id?: number | undefined;
    /** Raw pagination field */
    index?: number | undefined;
    /** Raw pagination field */
    direction?: string | undefined;
}
export interface GetTransfersByTransactionRequest {
    tx_hash: string;
    /** Items on a page: bounded by the API settings */
    page_size?: number | undefined;
    /** If true, return only the last page (pagination token is ignored) */
    last_page?: boolean | undefined;
    /**
     * input pagination token - used by default
     * (packed version of the raw pagination parameters)
     */
    page_token?: string | undefined;
    /**
     * Raw pagination parameters
     * (used when api.use_pagination_token=false)
     */
    timestamp?: number | undefined;
    /** Raw pagination field */
    message_id?: string | undefined;
    /** Raw pagination field */
    bridge_id?: number | undefined;
    /** Raw pagination field */
    index?: number | undefined;
    /** Raw pagination field */
    direction?: string | undefined;
}
export interface GetTransfersByAddressRequest {
    address: string;
    /** Items on a page: bounded by the API settings */
    page_size?: number | undefined;
    /** If true, return only the last page (pagination token is ignored) */
    last_page?: boolean | undefined;
    /**
     * input pagination token - used by default
     * (packed version of the raw pagination parameters)
     */
    page_token?: string | undefined;
    /**
     * Raw pagination parameters
     * (used when api.use_pagination_token=false)
     */
    timestamp?: number | undefined;
    /** Raw pagination field */
    message_id?: string | undefined;
    /** Raw pagination field */
    bridge_id?: number | undefined;
    /** Raw pagination field */
    index?: number | undefined;
    /** Raw pagination field */
    direction?: string | undefined;
}
export interface TokenInfo {
    address_hash: string;
    name?: string | undefined;
    symbol?: string | undefined;
    decimals?: string | undefined;
    icon_url?: string | undefined;
}
export interface InterchainTransfer {
    bridge: BridgeInfo | undefined;
    message_id: string;
    status: MessageStatus;
    source_chain: ChainInfo | undefined;
    destination_chain: ChainInfo | undefined;
    source_token: TokenInfo | undefined;
    source_amount?: string | undefined;
    source_transaction_hash?: string | undefined;
    sender?: AddressInfo | undefined;
    send_timestamp: string;
    destination_token: TokenInfo | undefined;
    destination_amount?: string | undefined;
    destination_transaction_hash?: string | undefined;
    recipient?: AddressInfo | undefined;
    receive_timestamp?: string | undefined;
}
export interface GetTransfersResponse {
    items: InterchainTransfer[];
    next_page_params?: Pagination | undefined;
    prev_page_params?: Pagination | undefined;
}
export interface InterchainService {
    GetMessages(request: GetMessagesRequest): Promise<GetMessagesResponse>;
    GetMessageDetails(request: GetMessageDetailsRequest): Promise<InterchainMessage>;
    GetMessagesByTransaction(request: GetMessagesByTransactionRequest): Promise<GetMessagesResponse>;
    GetMessagesByAddress(request: GetMessagesByAddressRequest): Promise<GetMessagesResponse>;
    GetTransfers(request: GetTransfersRequest): Promise<GetTransfersResponse>;
    GetTransfersByTransaction(request: GetTransfersByTransactionRequest): Promise<GetTransfersResponse>;
    GetTransfersByAddress(request: GetTransfersByAddressRequest): Promise<GetTransfersResponse>;
}
