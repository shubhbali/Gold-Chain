export declare const protobufPackage = "goldscan.bens.v1";
export declare enum TokenType {
    NATIVE_DOMAIN_TOKEN = "NATIVE_DOMAIN_TOKEN",
    WRAPPED_DOMAIN_TOKEN = "WRAPPED_DOMAIN_TOKEN",
    UNRECOGNIZED = "UNRECOGNIZED"
}
export declare enum Order {
    ORDER_UNSPECIFIED = "ORDER_UNSPECIFIED",
    ASC = "ASC",
    DESC = "DESC",
    UNRECOGNIZED = "UNRECOGNIZED"
}
export interface Domain {
    /** Unique id for the domain, also known as nodehash */
    id: string;
    /** The human readable name, if known. Unknown portions replaced with hash in square brackets (eg, foo.[1234].eth) */
    name: string;
    /** Optional. Resolved address of this domain */
    resolved_address?: Address | undefined;
    /** The account that owns the domain */
    owner: Address | undefined;
    /** Optional. Owner of NameWrapper NFT */
    wrapped_owner?: Address | undefined;
    /** Optional. RFC 3339 datetime of expiry date. */
    registration_date: string;
    /** Optional. RFC 3339 datetime  of expiry date. None means never expires */
    expiry_date?: string | undefined;
    /** Protocol that domain belongs to */
    protocol: ProtocolInfo | undefined;
}
export interface DetailedDomain {
    /** Unique id for the domain, also known as nodehash */
    id: string;
    /** The human readable name, if known. Unknown portions replaced with hash in square brackets (eg, foo.[1234].eth) */
    name: string;
    /** List of NFT tokens related to this domain */
    tokens: Token[];
    /** The account that owns the domain */
    owner: Address | undefined;
    /** Optional. Resolved address of this domain */
    resolved_address?: Address | undefined;
    /** Optional. The account that owns the ERC721 NFT for the domain */
    registrant?: Address | undefined;
    /** Optional. Owner of NameWrapper NFT */
    wrapped_owner?: Address | undefined;
    /** Optional. RFC 3339 datetime  of expiry date. */
    registration_date: string;
    /** Optional. RFC 3339 datetime  of expiry date. None means never expires */
    expiry_date?: string | undefined;
    /**
     * Map chain -> resolved_address that contains other blockchain addresses.
     * This map will contain `current_chain_id` -> `resovled_address` if `resovled_address` is not None
     */
    other_addresses: {
        [key: string]: string;
    };
    /** Information about protocol that domain belongs to */
    protocol: ProtocolInfo | undefined;
    stored_offchain: boolean;
    resolved_with_wildcard: boolean;
    resolver_address?: Address | undefined;
}
export interface DetailedDomain_OtherAddressesEntry {
    key: string;
    value: string;
}
export interface ProtocolInfo {
    id: string;
    short_name: string;
    title: string;
    description: string;
    deployment_goldscan_base_url: string;
    tld_list: string[];
    icon_url?: string | undefined;
    docs_url?: string | undefined;
}
export interface DomainEvent {
    /** Transaction hash where action occured */
    transaction_hash: string;
    /** Timestamp of this transaction */
    timestamp: string;
    /** /Sender of transaction */
    from_address: Address | undefined;
    /** Optional. Action name */
    action?: string | undefined;
}
export interface Token {
    id: string;
    contract_hash: string;
    type: TokenType;
}
export interface Address {
    hash: string;
}
export interface Pagination {
    page_token: string;
    page_size: number;
}
export interface GetDomainRequest {
    /** Name of domain, for example vitalik.eth */
    name: string;
    /** The chain (network) where domain search should be done */
    chain_id: number;
    /** Filtering field to remove expired domains */
    only_active: boolean;
    /** Protocol id of domain, default is first priority protocol on that chain */
    protocol_id?: string | undefined;
}
export interface ListDomainEventsRequest {
    /** Name of domain, for example vitalik.eth */
    name: string;
    /** The chain (network) where domain search should be done */
    chain_id: number;
    /** Sorting field. Default is `timestamp` */
    sort: string;
    /** Order direction. Default is DESC */
    order: Order;
    /** Protocol id of domain, default is first priority protocol on that chain */
    protocol_id?: string | undefined;
}
export interface ListDomainEventsResponse {
    items: DomainEvent[];
}
export interface LookupDomainNameRequest {
    /** Optional. Name of domain, for example vitalik.eth. None means lookup for any name */
    name?: string | undefined;
    /** The chain (network) where domain search should be done */
    chain_id: number;
    /** Filtering field to remove expired domains */
    only_active: boolean;
    /** Sorting field. Default is `registration_date` */
    sort: string;
    /** Order direction. Default is DESC */
    order: Order;
    /** Optional. Max number of items in single response. Default is 50 */
    page_size?: number | undefined;
    /** Optional. Value of `.pagination.page_token` from previous response */
    page_token?: string | undefined;
    /** comma separated list of protocol ids to filter by */
    protocols?: string | undefined;
}
export interface LookupDomainNameResponse {
    /**
     * List of domains that resolved to or owned by requested address
     * Sorted by relevance, so first address could be displayed as main resolved address
     */
    items: Domain[];
    next_page_params: Pagination | undefined;
}
export interface LookupAddressRequest {
    /** Address of EOA or contract */
    address: string;
    /** The chain (network) where domain search should be done */
    chain_id: number;
    /** Include domains resolved to the address */
    resolved_to: boolean;
    /** Include domains owned by the address */
    owned_by: boolean;
    /** Filtering field to remove expired domains */
    only_active: boolean;
    /** Sorting field. Default is `registration_date` */
    sort: string;
    /** Order direction. Defaut is DESC */
    order: Order;
    /** Optional. Max number of items in single response. Default is 50 */
    page_size?: number | undefined;
    /** Optional. Value of `.pagination.page_token` from previous response */
    page_token?: string | undefined;
    /** comma separated list of protocol ids to filter by */
    protocols?: string | undefined;
}
export interface LookupAddressResponse {
    /**
     * List of domains that resolved to or owned by requested address
     * Sorted by relevance, so first address could be displayed as main resolved address
     */
    items: Domain[];
    next_page_params: Pagination | undefined;
}
export interface GetAddressRequest {
    address: string;
    chain_id: number;
    protocol_id?: string | undefined;
}
export interface GetAddressResponse {
    domain: DetailedDomain | undefined;
    resolved_domains_count: number;
}
export interface BatchResolveAddressNamesRequest {
    /** List of requested addresses */
    addresses: string[];
    /** The chain (network) where domain search should be done */
    chain_id: number;
}
export interface BatchResolveAddressNamesResponse {
    names: {
        [key: string]: string;
    };
}
export interface BatchResolveAddressNamesResponse_NamesEntry {
    key: string;
    value: string;
}
export interface GetProtocolsRequest {
    /** The chain (network) where to get protocols */
    chain_id: number;
}
export interface GetProtocolsResponse {
    items: ProtocolInfo[];
}
export interface DomainsExtractor {
    /** Get detailed information about domain for Detailed domain page */
    GetDomain(request: GetDomainRequest): Promise<DetailedDomain>;
    /** Get list of events of domain for Detailed domain page */
    ListDomainEvents(request: ListDomainEventsRequest): Promise<ListDomainEventsResponse>;
    /** Get basic info about domain for ens-lookup and goldscan quick-search. Sorted by `registration_date` */
    LookupDomainName(request: LookupDomainNameRequest): Promise<LookupDomainNameResponse>;
    /** Get basic info about address for ens-lookup and goldscan quick-search. Sorted by `registration_date` */
    LookupAddress(request: LookupAddressRequest): Promise<LookupAddressResponse>;
    /** Get detailed information about main domain of requested address */
    GetAddress(request: GetAddressRequest): Promise<GetAddressResponse>;
    /** Perform batch resolving of list of address for goldscan backend requests */
    BatchResolveAddressNames(request: BatchResolveAddressNamesRequest): Promise<BatchResolveAddressNamesResponse>;
    /** Get list of supported protocols */
    GetProtocols(request: GetProtocolsRequest): Promise<GetProtocolsResponse>;
}
