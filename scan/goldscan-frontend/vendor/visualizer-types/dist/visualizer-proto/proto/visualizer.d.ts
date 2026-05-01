export declare const protobufPackage = "goldscan.visualizer.v1";
export interface VisualizeContractsRequest {
    sources: {
        [key: string]: string;
    };
    output_mask: string[] | undefined;
}
export interface VisualizeContractsRequest_SourcesEntry {
    key: string;
    value: string;
}
export interface VisualizeStorageRequest {
    sources: {
        [key: string]: string;
    };
    file_name: string;
    contract_name: string;
    output_mask: string[] | undefined;
}
export interface VisualizeStorageRequest_SourcesEntry {
    key: string;
    value: string;
}
/**
 * The client should decide on what type they are interested in
 * and specify it through `request.output_mask` field. If omitted,
 * all types would be calculated and returned to the client.
 */
export interface VisualizeResponse {
    png?: Uint8Array | undefined;
    svg?: Uint8Array | undefined;
}
export interface SolidityVisualizer {
    VisualizeContracts(request: VisualizeContractsRequest): Promise<VisualizeResponse>;
    VisualizeStorage(request: VisualizeStorageRequest): Promise<VisualizeResponse>;
}
