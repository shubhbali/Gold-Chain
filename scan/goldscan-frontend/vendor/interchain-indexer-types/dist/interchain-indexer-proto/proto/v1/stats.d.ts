export interface GetCommonStatisticsRequest {
    timestamp?: number | undefined;
}
export interface GetDailyStatisticsRequest {
    timestamp?: number | undefined;
}
export interface GetCommonStatisticsResponse {
    timestamp: string;
    total_messages: number;
    total_transfers: number;
}
export interface GetDailyStatisticsResponse {
    date: string;
    daily_messages: number;
    daily_transfers: number;
}
export interface InterchainStatisticsService {
    GetCommonStatistics(request: GetCommonStatisticsRequest): Promise<GetCommonStatisticsResponse>;
    GetDailyStatistics(request: GetDailyStatisticsRequest): Promise<GetDailyStatisticsResponse>;
}
