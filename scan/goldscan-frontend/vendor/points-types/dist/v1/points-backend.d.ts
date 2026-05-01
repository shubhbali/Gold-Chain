export interface AuthNonceRequest {
    code?: string | undefined;
    goldscan_login_chain_id?: string | undefined;
    goldscan_login_address?: string | undefined;
}
export interface AuthNonceResponse {
    nonce: string;
    merits_login_nonce?: string | undefined;
}
export interface AuthCodeRequest {
    code: string;
}
export interface AuthCodeResponse {
    valid: boolean;
    is_custom: boolean;
    reward?: string | undefined;
}
export interface AuthUserRequest {
    address: string;
}
export interface AuthUserResponse {
    exists: boolean;
    user: User | undefined;
}
export interface AuthLoginRequest {
    nonce: string;
    message: string;
    signature: string;
}
export interface AuthLoginResponse {
    created: boolean;
    token: string;
}
export interface AuthLogoutRequest {
}
export interface AuthLogoutResponse {
}
export interface GetUserBalancesRequest {
}
export interface GetUserBalancesResponse {
    total: string;
    staked: string;
    unstaked: string;
    total_staking_rewards: string;
    total_referral_rewards: string;
    pending_referral_rewards: string;
}
export interface GetReferralDataRequest {
}
export interface GetReferralDataResponse {
    code: string;
    link: string;
    referrals: string;
}
export interface DailyRewardCheckRequest {
}
export interface DailyRewardCheckResponse {
    available: boolean;
    daily_reward: string;
    streak_reward: string;
    pending_referral_rewards: string;
    total_reward: string;
    date: string;
    reset_at: string;
    streak: string;
}
export interface DailyRewardClaimRequest {
}
export interface DailyRewardClaimResponse {
    daily_reward: string;
    streak_reward: string;
    pending_referral_rewards: string;
    total_reward: string;
    streak: string;
}
export interface GetCampaignRewardsHistoryRequest {
    campaign?: string | undefined;
    page_size?: number | undefined;
    page_token?: string | undefined;
}
export interface GetCampaignRewardsHistoryResponse {
    items: CampaignLog[];
    next_page_params: Pagination | undefined;
}
export interface CampaignLog {
    id: string;
    amount: string;
    timestamp: string;
    description?: string | undefined;
}
export interface GetRewardsHistoryRequest {
    action: string[];
    page_size?: number | undefined;
    page_token?: string | undefined;
}
export interface GetRewardsHistoryResponse {
    items: RewardLog[];
    next_page_params: Pagination | undefined;
}
export interface RewardLog {
    action: string;
    details: {
        [key: string]: any;
    } | undefined;
    timestamp: string;
}
export interface GetOfferRedemptionsHistoryRequest {
    offer_id?: string | undefined;
    page_size?: number | undefined;
    page_token?: string | undefined;
}
export interface User {
    address: string;
    total_balance: string;
    referrals: string;
    registered_at: string;
}
export interface GetUsersLeaderboardRequest {
    sort?: string | undefined;
    page_size?: number | undefined;
    page_token?: string | undefined;
}
export interface GetUserLeaderboardRequest {
    address: string;
    sort?: string | undefined;
}
export interface GetUsersLeaderboardResponse {
    items: UserLeaderboardPosition[];
    next_page_params: Pagination | undefined;
}
export interface UserLeaderboardPosition {
    address: string;
    total_balance: string;
    referrals: string;
    registered_at: string;
    rank: string;
    users_below: string;
    top_percent: number;
}
export interface Pagination {
    page_token: string;
    page_size: number;
}
export interface GetConfigRequest {
    chain_id?: string | undefined;
}
export interface GetConfigResponse {
    rewards: RewardsConfig | undefined;
    auth: AuthConfig | undefined;
    activity: ActivityConfig | undefined;
}
export interface GetInstancesRequest {
}
export interface GetInstancesResponse {
    items: Instance[];
}
export interface Instance {
    chain_id: string;
    name: string;
    domain: string;
    details: {
        [key: string]: any;
    } | undefined;
}
export interface GetInstancesLeaderboardRequest {
}
export interface GetInstancesLeaderboardResponse {
    items: InstanceExtended[];
}
export interface InstanceExtended {
    chain_id: string;
    name: string;
    domain: string;
    details: {
        [key: string]: any;
    } | undefined;
    metrics: Metrics | undefined;
    staking: Staking | undefined;
}
export interface Metrics {
    snapshot_at: string;
    metrics: {
        [key: string]: string;
    };
}
export interface Metrics_MetricsEntry {
    key: string;
    value: string;
}
export interface Staking {
}
export interface RewardsConfig {
    registration: string;
    registration_with_referral: string;
    daily_claim: string;
    referral_share: string;
    streak_bonuses: {
        [key: string]: string;
    };
    sent_transactions_activity_rewards: {
        [key: string]: string;
    };
    verified_contracts_activity_rewards: {
        [key: string]: string;
    };
    goldscan_usage_activity_rewards: {
        [key: string]: string;
    };
    goldscan_activity_pass_id: string;
}
export interface RewardsConfig_StreakBonusesEntry {
    key: string;
    value: string;
}
export interface RewardsConfig_SentTransactionsActivityRewardsEntry {
    key: string;
    value: string;
}
export interface RewardsConfig_VerifiedContractsActivityRewardsEntry {
    key: string;
    value: string;
}
export interface RewardsConfig_GoldscanUsageActivityRewardsEntry {
    key: string;
    value: string;
}
export interface AuthConfig {
    shared_siwe_login: boolean;
}
export interface ActivityConfig {
    sent_transactions_activity_enabled: boolean;
    verified_contracts_activity_enabled: boolean;
    goldscan_usage_activity_enabled: boolean;
}
export interface Offer {
    offer_id: string;
    details: {
        [key: string]: any;
    } | undefined;
    price: string;
    weight: number;
    valid_since: string;
    valid_until: string;
    redemptions_limit: number;
    redemptions_count: number;
    is_valid: boolean;
    min_passport_score?: string | undefined;
    is_hidden: boolean;
    is_unique_per_address: boolean;
    is_auto_filled: boolean;
}
export interface GetOffersRequest {
    only_active?: boolean | undefined;
}
export interface GetOffersResponse {
    items: Offer[];
}
export interface GetOfferRequest {
    offer_id: string;
}
export interface GetOfferRedemptionsRequest {
    offer_id: string;
    page_size?: number | undefined;
    page_token?: string | undefined;
}
export interface GetOfferRedemptionsResponse {
    items: OfferRedemption[];
    next_page_params: Pagination | undefined;
}
export interface OfferRedemption {
    offer_id: string;
    address: string;
    redemption: string;
    price: string;
    note?: string | undefined;
    redeemed_at: string;
    secret?: string | undefined;
}
export interface GetLatestPassportScoreRequest {
}
export interface GetLatestPassportScoreResponse {
    score?: PassportScore | undefined;
}
export interface PassportScore {
    score: string;
    expiry_at: string;
    details: {
        [key: string]: any;
    } | undefined;
}
export interface CheckRedeemOfferResponse {
    is_redeemable: boolean;
    reason?: string | undefined;
}
export interface RedeemOfferRequest {
    offer_id: string;
    expected_price: string;
    note?: string | undefined;
}
export interface RedeemOfferResponse {
    secret?: string | undefined;
}
export interface CheckActivityPassRequest {
    address: string;
}
export interface CheckActivityPassResponse {
    is_valid: boolean;
    activity_pass?: ActivityPass | undefined;
}
export interface ActivityPass {
    offer_id: string;
    details: {
        [key: string]: any;
    } | undefined;
    valid_since: string;
    valid_until: string;
}
export interface GetActivityRewardsRequest {
}
export interface GetActivityRewardsResponse {
    items: ActivityReward[];
    last_week: ActivityReward[];
}
export interface ActivityReward {
    date: string;
    end_date: string;
    activity: string;
    amount?: string | undefined;
    percentile?: number | undefined;
    is_pending: boolean;
}
export interface GetActivityRewardsHistoryRequest {
    activity?: string | undefined;
    page_size?: number | undefined;
    page_token?: string | undefined;
}
export interface GetActivityRewardsHistoryResponse {
    items: ActivityReward[];
    next_page_params: Pagination | undefined;
}
export interface PreSubmitTransactionRequest {
    chain_id: string;
    from_address: string;
    to_address: string;
}
export interface PreSubmitTransactionResponse {
    token: string;
}
export interface PostSubmitTransactionRequest {
    token: string;
    tx_hash: string;
}
export interface PostSubmitTransactionResponse {
}
export interface PreVerifyContractRequest {
    chain_id: string;
    address: string;
}
export interface PreVerifyContractResponse {
}
export interface PostVerifyContractRequest {
    token: string;
}
export interface PostVerifyContractResponse {
}
export interface SubmitActivityRequest {
    chain_id: string;
    action: string;
}
export interface SubmitActivityResponse {
}
export interface GetAvailableBadgesRequest {
}
export interface GetAvailableBadgesResponse {
    items: BadgeInfo[];
}
export interface BadgeInfo {
    chain_id: string;
    address: string;
    requirements: BadgeRequirements | undefined;
    is_qualified: boolean;
    is_whitelisted: boolean;
    is_minted: boolean;
}
export interface BadgeRequirements {
    streak: string;
}
/** authorization endpoints */
export interface PointsService {
    AuthNonce(request: AuthNonceRequest): Promise<AuthNonceResponse>;
    AuthCode(request: AuthCodeRequest): Promise<AuthCodeResponse>;
    AuthUser(request: AuthUserRequest): Promise<AuthUserResponse>;
    AuthLogin(request: AuthLoginRequest): Promise<AuthLoginResponse>;
    AuthLogout(request: AuthLogoutRequest): Promise<AuthLogoutResponse>;
    GetUserBalances(request: GetUserBalancesRequest): Promise<GetUserBalancesResponse>;
    GetReferralData(request: GetReferralDataRequest): Promise<GetReferralDataResponse>;
    DailyRewardCheck(request: DailyRewardCheckRequest): Promise<DailyRewardCheckResponse>;
    DailyRewardClaim(request: DailyRewardClaimRequest): Promise<DailyRewardClaimResponse>;
    GetCampaignRewardsHistory(request: GetCampaignRewardsHistoryRequest): Promise<GetCampaignRewardsHistoryResponse>;
    GetRewardsHistory(request: GetRewardsHistoryRequest): Promise<GetRewardsHistoryResponse>;
    GetOfferRedemptionsHistory(request: GetOfferRedemptionsHistoryRequest): Promise<GetOfferRedemptionsResponse>;
    GetLatestPassportScore(request: GetLatestPassportScoreRequest): Promise<GetLatestPassportScoreResponse>;
    CheckRedeemOffer(request: RedeemOfferRequest): Promise<CheckRedeemOfferResponse>;
    RedeemOffer(request: RedeemOfferRequest): Promise<RedeemOfferResponse>;
    GetActivityRewards(request: GetActivityRewardsRequest): Promise<GetActivityRewardsResponse>;
    GetActivityRewardsHistory(request: GetActivityRewardsHistoryRequest): Promise<GetActivityRewardsHistoryResponse>;
    PreSubmitTransaction(request: PreSubmitTransactionRequest): Promise<PreSubmitTransactionResponse>;
    PreVerifyContract(request: PreVerifyContractRequest): Promise<PreVerifyContractResponse>;
    SubmitActivity(request: SubmitActivityRequest): Promise<SubmitActivityResponse>;
    GetAvailableBadges(request: GetAvailableBadgesRequest): Promise<GetAvailableBadgesResponse>;
    GetConfig(request: GetConfigRequest): Promise<GetConfigResponse>;
    GetInstances(request: GetInstancesRequest): Promise<GetInstancesResponse>;
    GetInstancesLeaderboard(request: GetInstancesLeaderboardRequest): Promise<GetInstancesLeaderboardResponse>;
    GetOffers(request: GetOffersRequest): Promise<GetOffersResponse>;
    GetOffer(request: GetOfferRequest): Promise<Offer>;
    GetOfferRedemptions(request: GetOfferRedemptionsRequest): Promise<GetOfferRedemptionsResponse>;
    CheckActivityPass(request: CheckActivityPassRequest): Promise<CheckActivityPassResponse>;
    PreSubmitTransactionNoAuth(request: PreSubmitTransactionRequest): Promise<PreSubmitTransactionResponse>;
    PostSubmitTransaction(request: PostSubmitTransactionRequest): Promise<PostSubmitTransactionResponse>;
    /** leaderboard */
    GetUserLeaderboard(request: GetUserLeaderboardRequest): Promise<UserLeaderboardPosition>;
    GetUsersLeaderboard(request: GetUsersLeaderboardRequest): Promise<GetUsersLeaderboardResponse>;
}
