export declare enum OperationType {
    ERROR = "ERROR",
    PENDING = "PENDING",
    TON_TAC_TON = "TON_TAC_TON",
    TAC_TON = "TAC_TON",
    TON_TAC = "TON_TAC",
    ROLLBACK = "ROLLBACK",
    UNKNOWN = "UNKNOWN",
    INSUFFICIENT_FEE = "INSUFFICIENT_FEE",
    UNRECOGNIZED = "UNRECOGNIZED"
}
export declare enum BlockchainType {
    TAC = "TAC",
    TON = "TON",
    UNKNOWN_BLOCKCHAIN = "UNKNOWN_BLOCKCHAIN",
    UNRECOGNIZED = "UNRECOGNIZED"
}
export interface Pagination {
    page_token: number;
    page_items: number;
}
export interface GetOperationsRequest {
    /** multi-search by operation_id, tx_hash and sender */
    q?: string | undefined;
    page_token?: number | undefined;
    page_items?: number | undefined;
}
export interface GetOperationDetailsRequest {
    operation_id: string;
}
export interface GetOperationByTxHashRequest {
    tx_hash: string;
}
export interface OperationsResponse {
    items: OperationBriefDetails[];
    next_page_params?: Pagination | undefined;
}
export interface OperationBriefDetails {
    operation_id: string;
    type: OperationType;
    timestamp: string;
    sender?: BlockchainAddress | undefined;
}
export interface OperationDetails {
    operation_id: string;
    type: OperationType;
    timestamp: string;
    sender?: BlockchainAddress | undefined;
    status_history: OperationStage[];
}
export interface BlockchainAddress {
    address: string;
    blockchain: BlockchainType;
}
export interface OperationRelatedTransaction {
    hash: string;
    type: BlockchainType;
}
export interface OperationStage {
    type: OperationStage_StageType;
    is_exist: boolean;
    is_success?: boolean | undefined;
    timestamp?: string | undefined;
    transactions: OperationRelatedTransaction[];
    note?: string | undefined;
}
export declare enum OperationStage_StageType {
    COLLECTED_IN_TAC = "COLLECTED_IN_TAC",
    INCLUDED_IN_TAC_CONSENSUS = "INCLUDED_IN_TAC_CONSENSUS",
    EXECUTED_IN_TAC = "EXECUTED_IN_TAC",
    COLLECTED_IN_TON = "COLLECTED_IN_TON",
    INCLUDED_IN_TON_CONSENSUS = "INCLUDED_IN_TON_CONSENSUS",
    EXECUTED_IN_TON = "EXECUTED_IN_TON",
    UNRECOGNIZED = "UNRECOGNIZED"
}
export interface OperationsFullResponse {
    items: OperationDetails[];
}
export interface TacService {
    GetOperations(request: GetOperationsRequest): Promise<OperationsResponse>;
    GetOperationDetails(request: GetOperationDetailsRequest): Promise<OperationDetails>;
    GetOperationsByTransaction(request: GetOperationByTxHashRequest): Promise<OperationsFullResponse>;
}
