package gilt

import (
	autocliv1 "cosmossdk.io/api/cosmos/autocli/v1"

	"github.com/giltchain/gilt-consensus/api/giltconsensusv2/gilt"
)

func (am AppModule) AutoCLIOptions() *autocliv1.ModuleOptions {
	return &autocliv1.ModuleOptions{
		Query: &autocliv1.ServiceCommandDescriptor{
			Service: gilt.Query_ServiceDesc.ServiceName,
			RpcCommandOptions: []*autocliv1.RpcCommandOptions{
				{
					RpcMethod: "GetSpanById",
					Use:       "span-by-id [id]",
					Short:     "Query gilt span by id",
					PositionalArgs: []*autocliv1.PositionalArgDescriptor{
						{ProtoField: "id"},
					},
				},
				{
					RpcMethod: "GetSpanList",
					Use:       "span-list",
					Short:     "Query list of gilt spans",
				},
				{
					RpcMethod: "GetLatestSpan",
					Use:       "latest-span",
					Short:     "Query latest gilt span",
				},
				{
					RpcMethod: "GetNextSpanSeed",
					Use:       "next-span-seed [id]",
					Short:     "Query next gilt span seed",
					PositionalArgs: []*autocliv1.PositionalArgDescriptor{
						{ProtoField: "id"},
					},
				},
				{
					RpcMethod: "GetNextSpan",
					Use:       "next-span",
					Short:     "Query next gilt span",
					PositionalArgs: []*autocliv1.PositionalArgDescriptor{
						{ProtoField: "span_id"},
						{ProtoField: "start_block"},
						{ProtoField: "gilt_chain_id"},
					},
				},
				{
					RpcMethod: "GetGiltParams",
					Use:       "params",
					Short:     "Query gilt params",
				},
				{
					RpcMethod: "GetProducerPlannedDowntime",
					Use:       "producer-planned-downtime [producer_id]",
					Short:     "Query planned downtime for a producer",
					PositionalArgs: []*autocliv1.PositionalArgDescriptor{
						{ProtoField: "producer_id"},
					},
				},
			},
		},
	}
}
