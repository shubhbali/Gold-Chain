import { type Chain, type ChainBlockNumber, type Domain, type Hash, type MarketplaceDapp, type Pagination, type ProtocolInfo, type TokenType } from "./multichain-aggregator";
export interface AddressHash {
    hash: string;
}
export interface InteropMessage {
    sender?: AddressHash | undefined;
    target?: AddressHash | undefined;
    nonce: number;
    init_chain_id: string;
    init_transaction_hash?: string | undefined;
    timestamp?: string | undefined;
    relay_chain_id: string;
    relay_transaction_hash?: string | undefined;
    payload?: string | undefined;
    status: InteropMessage_Status;
    transfer?: InteropMessage_InteropMessageTransfer | undefined;
    message_type: string;
    method: string;
    decoded_payload?: {
        [key: string]: any;
    } | undefined;
}
export declare enum InteropMessage_Status {
    PENDING = "PENDING",
    FAILED = "FAILED",
    SUCCESS = "SUCCESS",
    EXPIRED = "EXPIRED",
    UNRECOGNIZED = "UNRECOGNIZED"
}
export interface InteropMessage_TokenDetails {
    address_hash: string;
}
export interface InteropMessage_TransferTotal {
    value: string;
}
export interface InteropMessage_InteropMessageTransfer {
    token?: InteropMessage_TokenDetails | undefined;
    from: AddressHash | undefined;
    to: AddressHash | undefined;
    total: InteropMessage_TransferTotal | undefined;
}
export interface ListClusterChainsRequest {
    cluster_id: string;
    /**
     * Metric used to sort chains. Supported values: active_accounts, daily_transactions,
     * new_addresses, tps. Defaults to active_accounts.
     */
    sort?: string | undefined;
    /** Sort order: "asc" or "desc". Defaults to "desc" (higher values first). */
    order?: string | undefined;
}
export interface ListClusterChainsResponse {
    items: Chain[];
}
export interface WeeklyMetric {
    current_full_week: string;
    previous_full_week: string;
    wow_diff_percent: string;
}
export interface ChainMetrics {
    chain_id: string;
    tps?: string | undefined;
    new_addresses?: WeeklyMetric | undefined;
    daily_transactions?: WeeklyMetric | undefined;
    active_accounts?: WeeklyMetric | undefined;
}
export interface ListChainMetricsRequest {
    cluster_id: string;
    /**
     * Metric used to sort chain metrics. Supported values: active_accounts, daily_transactions,
     * new_addresses, tps. Defaults to active_accounts.
     */
    sort?: string | undefined;
    /** Sort order: "asc" or "desc". Defaults to "desc" (higher values first). */
    order?: string | undefined;
}
export interface ListChainMetricsResponse {
    items: ChainMetrics[];
}
export interface ListInteropMessagesRequest {
    cluster_id: string;
    init_chain_id?: string | undefined;
    relay_chain_id?: string | undefined;
    nonce?: number | undefined;
    /** Address of the sender or receiver. */
    address?: string | undefined;
    /** Message direction: "from" or "to". Valid only when address is provided. */
    direction?: string | undefined;
    page_size?: number | undefined;
    page_token?: string | undefined;
}
export interface ListInteropMessagesResponse {
    items: InteropMessage[];
    next_page_params: Pagination | undefined;
}
export interface CountInteropMessagesRequest {
    cluster_id: string;
    chain_id: string;
}
export interface CountInteropMessagesResponse {
    count: number;
}
export interface GetInteropMessageRequest {
    cluster_id: string;
    init_chain_id: string;
    nonce: number;
}
export interface GetInteropMessageResponse {
    message: InteropMessage | undefined;
}
export interface AggregatedTokenInfo {
    address_hash: string;
    circulating_market_cap?: string | undefined;
    decimals?: string | undefined;
    holders_count?: string | undefined;
    icon_url?: string | undefined;
    name?: string | undefined;
    symbol?: string | undefined;
    total_supply?: string | undefined;
    type: TokenType;
    exchange_rate?: string | undefined;
    /** Map of chain id to chain-specific information. */
    chain_infos: {
        [key: string]: AggregatedTokenInfo_ChainInfo;
    };
}
export interface AggregatedTokenInfo_ChainInfo {
    holders_count?: string | undefined;
    total_supply?: string | undefined;
    is_verified: boolean;
    contract_name?: string | undefined;
}
export interface AggregatedTokenInfo_ChainInfosEntry {
    key: string;
    value: AggregatedTokenInfo_ChainInfo | undefined;
}
export interface GetAddressRequest {
    cluster_id: string;
    address_hash: string;
}
export interface AddressPortfolio {
    total_value: string;
    chain_values: {
        [key: string]: string;
    };
}
export interface AddressPortfolio_ChainValuesEntry {
    key: string;
    value: string;
}
export interface GetAddressPortfolioRequest {
    cluster_id: string;
    address_hash: string;
    /** Comma-separated list of chain ids to filter by. */
    chain_id: string[];
}
export interface GetAddressPortfolioResponse {
    portfolio: AddressPortfolio | undefined;
}
export interface BasicDomainInfo {
    name: string;
    protocol: ProtocolInfo | undefined;
}
export interface GetAddressResponse {
    hash: string;
    /** Map of chain id to chain-specific information. */
    chain_infos: {
        [key: string]: GetAddressResponse_ChainInfo;
    };
    has_tokens: boolean;
    has_interop_message_transfers: boolean;
    /** Sum of coin balances across all chains. */
    coin_balance: string;
    /** Exchange rate of the cluster native coin. */
    exchange_rate?: string | undefined;
    domains: BasicDomainInfo[];
}
/** Chain-specific information. */
export interface GetAddressResponse_ChainInfo {
    coin_balance: string;
    is_contract: boolean;
    is_verified: boolean;
    contract_name?: string | undefined;
}
export interface GetAddressResponse_ChainInfosEntry {
    key: string;
    value: GetAddressResponse_ChainInfo | undefined;
}
export interface ListAddressTokensRequest {
    cluster_id: string;
    address_hash: string;
    /** List of comma-separated token types to filter by. See `TokenType`. */
    type?: string | undefined;
    /** Comma-separated list of chain ids to filter by. */
    chain_id: string[];
    query?: string | undefined;
    /** If true, include tokens with poor reputation in the results. By default they are excluded. */
    include_poor_reputation_tokens?: boolean | undefined;
    page_size?: number | undefined;
    page_token?: string | undefined;
}
export interface ListAddressTokensResponse {
    items: ListAddressTokensResponse_AggregatedTokenBalanceInfo[];
    next_page_params: Pagination | undefined;
}
export interface ListAddressTokensResponse_AggregatedTokenBalanceInfo {
    token: AggregatedTokenInfo | undefined;
    token_id?: string | undefined;
    value: string;
    chain_values: {
        [key: string]: string;
    };
}
export interface ListAddressTokensResponse_AggregatedTokenBalanceInfo_ChainValuesEntry {
    key: string;
    value: string;
}
export interface ListClusterTokensRequest {
    cluster_id: string;
    /** Comma-separated token types to filter by. See `TokenType`. */
    type?: string | undefined;
    /** Comma-separated list of chain ids to filter by. */
    chain_id: string[];
    query?: string | undefined;
    page_size?: number | undefined;
    page_token?: string | undefined;
}
export interface ListClusterTokensResponse {
    items: AggregatedTokenInfo[];
    next_page_params: Pagination | undefined;
}
export interface GetAggregatedTokenRequest {
    cluster_id: string;
    address_hash: string;
    chain_id: string;
}
export interface GetAggregatedTokenResponse {
    token: AggregatedTokenInfo | undefined;
}
export interface ListTokenHoldersRequest {
    cluster_id: string;
    address_hash: string;
    chain_id: string;
    page_size?: number | undefined;
    page_token?: string | undefined;
}
export interface ListTokenHoldersResponse {
    items: ListTokenHoldersResponse_TokenHolder[];
    next_page_params: Pagination | undefined;
}
export interface ListTokenHoldersResponse_TokenHolder {
    address: AddressHash | undefined;
    token_id?: string | undefined;
    value: string;
}
export interface ListDomainProtocolsRequest {
    cluster_id: string;
}
export interface ListDomainProtocolsResponse {
    items: ProtocolInfo[];
}
export interface SearchByQueryRequest {
    cluster_id: string;
    q: string;
    /** Comma-separated list of chain ids to filter by. */
    chain_id: string[];
    page_size?: number | undefined;
    page_token?: string | undefined;
}
export interface SearchTransactionsResponse {
    items: Hash[];
    next_page_params: Pagination | undefined;
}
export interface SearchBlocksResponse {
    items: Hash[];
    next_page_params: Pagination | undefined;
}
export interface SearchBlockNumbersResponse {
    items: ChainBlockNumber[];
    next_page_params: Pagination | undefined;
}
export interface SearchAddressesResponse {
    items: GetAddressResponse[];
    next_page_params: Pagination | undefined;
}
export interface SearchNftsResponse {
    items: AggregatedTokenInfo[];
    next_page_params: Pagination | undefined;
}
export interface SearchTokensResponse {
    items: AggregatedTokenInfo[];
    next_page_params: Pagination | undefined;
}
export interface SearchDomainsResponse {
    items: Domain[];
    next_page_params: Pagination | undefined;
}
export interface SearchDappsResponse {
    items: MarketplaceDapp[];
    next_page_params: Pagination | undefined;
}
export interface ClusterQuickSearchRequest {
    cluster_id: string;
    q: string;
    unlimited_per_chain: boolean;
}
export interface ClusterQuickSearchResponse {
    addresses: GetAddressResponse[];
    blocks: Hash[];
    transactions: Hash[];
    block_numbers: ChainBlockNumber[];
    dapps: MarketplaceDapp[];
    tokens: AggregatedTokenInfo[];
    nfts: AggregatedTokenInfo[];
    domains: Domain[];
}
export interface CheckRedirectRequest {
    cluster_id: string;
    q: string;
}
export interface CheckRedirectResponse {
    redirect: boolean;
    type?: string | undefined;
    parameter?: string | undefined;
    chain_id?: string | undefined;
}
export interface LookupAddressDomainsRequest {
    cluster_id: string;
    address_hash: string;
    page_size?: number | undefined;
    page_token?: string | undefined;
}
export interface LookupAddressDomainsResponse {
    items: Domain[];
    next_page_params: Pagination | undefined;
}
/** ClusterExplorerService provides read-only APIs for exploring a multichain cluster. */
export interface ClusterExplorerService {
    /** Lists all chains in the cluster, optionally sorted by a metric (e.g. active_accounts, tps). */
    ListClusterChains(request: ListClusterChainsRequest): Promise<ListClusterChainsResponse>;
    /** Returns chain-level metrics (TPS, new addresses, daily transactions, active accounts) with week-over-week deltas. */
    ListChainMetrics(request: ListChainMetricsRequest): Promise<ListChainMetricsResponse>;
    /** Lists interop (cross-chain) messages with optional filters (chains, nonce, address, direction); supports pagination. */
    ListInteropMessages(request: ListInteropMessagesRequest): Promise<ListInteropMessagesResponse>;
    /** Returns the count of interop messages for a given chain in the cluster. */
    CountInteropMessages(request: CountInteropMessagesRequest): Promise<CountInteropMessagesResponse>;
    /** Fetches a single interop message by init_chain_id and nonce. */
    GetInteropMessage(request: GetInteropMessageRequest): Promise<GetInteropMessageResponse>;
    /** Returns aggregated address info across the cluster: balances, contract/verification status, domains. */
    GetAddress(request: GetAddressRequest): Promise<GetAddressResponse>;
    /** Returns total portfolio value for an address, optionally filtered by chain ids. */
    GetAddressPortfolio(request: GetAddressPortfolioRequest): Promise<GetAddressPortfolioResponse>;
    /** Lists token balances for an address with optional type/chain/query filters and pagination. */
    ListAddressTokens(request: ListAddressTokensRequest): Promise<ListAddressTokensResponse>;
    /** Lists tokens present in the cluster with optional type/chain/query filters and pagination. */
    ListClusterTokens(request: ListClusterTokensRequest): Promise<ListClusterTokensResponse>;
    /** Returns aggregated token info for a given token address and chain in the cluster. */
    GetAggregatedToken(request: GetAggregatedTokenRequest): Promise<GetAggregatedTokenResponse>;
    /** Lists holders of a token (by address and chain) with pagination. */
    ListTokenHolders(request: ListTokenHoldersRequest): Promise<ListTokenHoldersResponse>;
    /** Lists domain name protocols (e.g. ENS) supported in the cluster. */
    ListDomainProtocols(request: ListDomainProtocolsRequest): Promise<ListDomainProtocolsResponse>;
    /** Full-text search for addresses by query string; optional chain filter and pagination. */
    SearchAddresses(request: SearchByQueryRequest): Promise<SearchAddressesResponse>;
    /** Full-text search for NFTs by query string; optional chain filter and pagination. */
    SearchNfts(request: SearchByQueryRequest): Promise<SearchNftsResponse>;
    /** Full-text search for transactions (returns transaction hashes); optional chain filter and pagination. */
    SearchTransactions(request: SearchByQueryRequest): Promise<SearchTransactionsResponse>;
    /** Full-text search for blocks (returns block hashes); optional chain filter and pagination. */
    SearchBlocks(request: SearchByQueryRequest): Promise<SearchBlocksResponse>;
    /** Full-text search for block numbers (returns chain + block number); optional chain filter and pagination. */
    SearchBlockNumbers(request: SearchByQueryRequest): Promise<SearchBlockNumbersResponse>;
    /** Full-text search for tokens; optional chain filter and pagination. */
    SearchTokens(request: SearchByQueryRequest): Promise<SearchTokensResponse>;
    /** Full-text search for domains; optional chain filter and pagination. */
    SearchDomains(request: SearchByQueryRequest): Promise<SearchDomainsResponse>;
    /** Full-text search for dapps; optional chain filter and pagination. */
    SearchDapps(request: SearchByQueryRequest): Promise<SearchDappsResponse>;
    /** Unified quick search across addresses, blocks, transactions, block numbers, dapps, tokens, NFTs, and domains; supports unlimited results per chain. */
    QuickSearch(request: ClusterQuickSearchRequest): Promise<ClusterQuickSearchResponse>;
    /** Checks whether the given query should redirect to a specific entity type and chain (e.g. block, transaction, address). */
    CheckRedirect(request: CheckRedirectRequest): Promise<CheckRedirectResponse>;
    /** Lists domains (e.g. ENS names) associated with an address in the cluster; supports pagination. */
    LookupAddressDomains(request: LookupAddressDomainsRequest): Promise<LookupAddressDomainsResponse>;
}
