package pricefeed

import (
	autocliv1 "cosmossdk.io/api/cosmos/autocli/v1"

	"github.com/giltchain/gilt-consensus/api/giltconsensusv2/pricefeed"
)

// AutoCLIOptions implements the autocli.HasAutoCLIConfig interface.
func (AppModule) AutoCLIOptions() *autocliv1.ModuleOptions {
	return &autocliv1.ModuleOptions{
		Query: &autocliv1.ServiceCommandDescriptor{
			Service: pricefeed.Query_ServiceDesc.ServiceName,
			RpcCommandOptions: []*autocliv1.RpcCommandOptions{
				{
					RpcMethod: "Params",
					Use:       "params",
					Short:     "Query pricefeed params",
				},
				{
					RpcMethod: "LatestPrice",
					Use:       "latest",
					Short:     "Query latest GILT/GOLD price",
				},
				{
					RpcMethod: "PriceByEpoch",
					Use:       "price [epoch]",
					Short:     "Query GILT/GOLD price by epoch",
					PositionalArgs: []*autocliv1.PositionalArgDescriptor{
						{ProtoField: "epoch"},
					},
				},
			},
		},
	}
}
