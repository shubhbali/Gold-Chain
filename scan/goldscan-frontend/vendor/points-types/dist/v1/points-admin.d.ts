import { type GetUserBalancesResponse, type OfferRedemption, type Pagination, type PassportScore } from "./points-backend";
export interface AdminGetUserInfoRequest {
    address_or_code: string;
}
export interface AdminGetUserInfoResponse {
    address: string;
    balances: GetUserBalancesResponse | undefined;
    logs: UserLog[];
    code?: string | undefined;
    invited_users: string[];
    passport_score?: PassportScore | undefined;
}
export interface UserLog {
    id: string;
    action: string;
    details: {
        [key: string]: any;
    } | undefined;
    timestamp: string;
}
export interface AdminGetUsersBasicInfoRequest {
    address: string[];
}
export interface AdminGetUsersBasicInfoResponse {
    items: UserBasicInfo[];
}
export interface UserBasicInfo {
    address: string;
    is_active: boolean;
    balances?: GetUserBalancesResponse | undefined;
}
export interface AdminDistributeRequest {
    id: string;
    description: string;
    distributions: Distribution[];
    create_missing_accounts: boolean;
    expected_total: string;
}
export interface Distribution {
    address: string;
    amount: string;
}
export interface AdminDistributeResponse {
    accounts_distributed: string;
    accounts_created: string;
}
export interface AdminGetDistributionRequest {
    distribution_id: string;
}
export interface AdminGetDistributionResponse {
    id: string;
    description: string;
    total_receivers: string;
    total_accounts_created: string;
    total_distributed: string;
    distributions: Distribution[];
    distributed_at: string;
}
export interface AdminGetNetworkRequest {
    chain_id: string;
}
export interface AdminNetwork {
    chain_id: string;
    name: string;
    domain: string;
    active: boolean;
    rpc_url?: string | undefined;
    goldscan_api_key?: string | undefined;
    block_timestamp_skew?: number | undefined;
    sent_transactions_activity_enabled: boolean;
    verified_contracts_activity_enabled: boolean;
    goldscan_usage_activity_enabled: boolean;
    details: {
        [key: string]: any;
    } | undefined;
}
export interface AdminGetNetworksRequest {
}
export interface AdminGetNetworksResponse {
    items: AdminNetwork[];
}
export interface AdminAddNetworkResponse {
}
export interface AdminUpdateNetworkResponse {
}
export interface AdminUpdateReferralCodeRequest {
    address: string;
    old_code: string;
    new_code: string;
}
export interface AdminUpdateReferralCodeResponse {
}
export interface AdminOffer {
    offer_id: string;
    details: {
        [key: string]: any;
    } | undefined;
    price: string;
    weight: number;
    valid_since: string;
    valid_until: string;
    redemptions_limit: number;
    min_passport_score?: string | undefined;
    is_hidden: boolean;
    is_unique_per_address: boolean;
    is_auto_filled: boolean;
}
export interface AdminAddOfferResponse {
}
export interface AdminUpdateOfferResponse {
}
export interface AdminGetOfferRedemptionsRequest {
    offer_id: string;
    page_size?: number | undefined;
    page_token?: string | undefined;
}
export interface AdminGetOfferRedemptionsResponse {
    items: OfferRedemption[];
    next_page_params: Pagination | undefined;
}
export interface AdminAddOfferSecretsRequest {
    offer_id: string;
    details: string[];
}
export interface AdminAddOfferSecretsResponse {
}
export interface AdminGetOfferSecretsRequest {
    offer_id: string;
    is_redeemed?: boolean | undefined;
    page_size?: number | undefined;
    page_token?: string | undefined;
}
export interface AdminGetOfferSecretsResponse {
    items: OfferSecret[];
    next_page_params: Pagination | undefined;
}
export interface OfferSecret {
    secret_id: number;
    offer_id: string;
    details: string;
    is_redeemed: boolean;
}
export interface AdminDeleteOfferSecretRequest {
    offer_id: string;
    secret_id: number;
}
export interface AdminDeleteOfferSecretResponse {
}
export interface AdminAddCustomReferralCodeRequest {
    code?: string | undefined;
    bonus: string;
    limit: number;
}
export interface AdminAddCustomReferralCodeResponse {
    code: string;
}
export interface AdminUpdateCustomReferralCodeRequest {
    code: string;
    bonus: string;
    limit: number;
}
export interface AdminUpdateCustomReferralCodeResponse {
}
export interface AdminGetCustomReferralCodesRequest {
}
export interface AdminGetCustomReferralCodesResponse {
    items: CustomReferralCode[];
}
export interface CustomReferralCode {
    code: string;
    bonus: string;
    limit: number;
    count: number;
}
export interface PointsAdminService {
    AdminGetUserInfo(request: AdminGetUserInfoRequest): Promise<AdminGetUserInfoResponse>;
    AdminGetUsersBasicInfo(request: AdminGetUsersBasicInfoRequest): Promise<AdminGetUsersBasicInfoResponse>;
    AdminDistribute(request: AdminDistributeRequest): Promise<AdminDistributeResponse>;
    AdminGetDistribution(request: AdminGetDistributionRequest): Promise<AdminGetDistributionResponse>;
    AdminGetNetwork(request: AdminGetNetworkRequest): Promise<AdminNetwork>;
    AdminGetNetworks(request: AdminGetNetworksRequest): Promise<AdminGetNetworksResponse>;
    AdminAddNetwork(request: AdminNetwork): Promise<AdminAddNetworkResponse>;
    AdminUpdateNetwork(request: AdminNetwork): Promise<AdminUpdateNetworkResponse>;
    AdminUpdateReferralCode(request: AdminUpdateReferralCodeRequest): Promise<AdminUpdateReferralCodeResponse>;
    AdminAddOffer(request: AdminOffer): Promise<AdminAddOfferResponse>;
    AdminUpdateOffer(request: AdminOffer): Promise<AdminUpdateOfferResponse>;
    AdminGetOfferRedemptions(request: AdminGetOfferRedemptionsRequest): Promise<AdminGetOfferRedemptionsResponse>;
    AdminAddOfferSecrets(request: AdminAddOfferSecretsRequest): Promise<AdminAddOfferSecretsResponse>;
    AdminGetOfferSecrets(request: AdminGetOfferSecretsRequest): Promise<AdminGetOfferSecretsResponse>;
    AdminDeleteOfferSecret(request: AdminDeleteOfferSecretRequest): Promise<AdminDeleteOfferSecretResponse>;
    AdminAddCustomReferralCode(request: AdminAddCustomReferralCodeRequest): Promise<AdminAddCustomReferralCodeResponse>;
    AdminUpdateCustomReferralCode(request: AdminUpdateCustomReferralCodeRequest): Promise<AdminUpdateCustomReferralCodeResponse>;
    AdminGetCustomReferralCodes(request: AdminGetCustomReferralCodesRequest): Promise<AdminGetCustomReferralCodesResponse>;
}
