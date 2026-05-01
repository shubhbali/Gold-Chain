export interface GetIntervalStatisticsRequest {
}
export interface GetOperationStatisticsRequest {
}
export interface GetFullStatisticRequest {
}
export interface GetIntervalStatisticsResponse {
    timestamp: number;
    intervals: IntervalStatistic | undefined;
}
export interface GetOperationStatisticsResponse {
    timestamp: number;
    operations: OperationStatistic | undefined;
}
export interface GetFullStatisticResponse {
    timestamp: number;
    watermark: number;
    intervals: IntervalStatistic | undefined;
    operations: OperationStatistic | undefined;
}
export interface IntervalStatistic {
    first_timestamp: number;
    last_timestamp: number;
    total_intervals: number;
    pending_intervals: number;
    processing_intervals: number;
    finalized_intervals: number;
    failed_intervals: number;
    finalized_period: number;
    sync_completeness: number;
}
export interface OperationStatistic {
    last_timestamp: number;
    total_operations: number;
    pending_operations: number;
    processing_operations: number;
    finalized_operations: number;
    failed_operations: number;
    sync_completeness: number;
}
export interface TacStatistic {
    GetIntervalStatistics(request: GetIntervalStatisticsRequest): Promise<GetIntervalStatisticsResponse>;
    GetOperationStatistics(request: GetOperationStatisticsRequest): Promise<GetOperationStatisticsResponse>;
    GetFullStatistics(request: GetFullStatisticRequest): Promise<GetFullStatisticResponse>;
}
