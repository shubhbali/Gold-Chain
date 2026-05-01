export interface GetFullStatusRequest {
}
export interface GetStatusRequest {
    indexer_name: string;
}
export interface IndexerStatus {
    name: string;
    description?: string | undefined;
    state: string;
    init_timestamp: string;
    extra_info?: {
        [key: string]: any;
    } | undefined;
}
export interface FullStatus {
    indexers: IndexerStatus[];
}
export interface StatusService {
    GetFullStatus(request: GetFullStatusRequest): Promise<FullStatus>;
    GetStatusByIndexerName(request: GetStatusRequest): Promise<IndexerStatus>;
}
