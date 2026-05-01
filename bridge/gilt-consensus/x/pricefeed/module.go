package pricefeed

import (
	"context"
	"encoding/json"
	"fmt"

	"cosmossdk.io/core/appmodule"
	"github.com/cometbft/cometbft/types/time"
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/codec"
	codectypes "github.com/cosmos/cosmos-sdk/codec/types"
	"github.com/cosmos/cosmos-sdk/telemetry"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/module"
	"github.com/cosmos/cosmos-sdk/types/simulation"
	gwruntime "github.com/grpc-ecosystem/grpc-gateway/runtime"

	"github.com/giltchain/gilt-consensus/x/pricefeed/keeper"
	"github.com/giltchain/gilt-consensus/x/pricefeed/types"
)

// ConsensusVersion defines the current x/pricefeed module consensus version.
const ConsensusVersion = 1

var (
	_ module.HasGenesis     = AppModule{}
	_ module.HasServices    = AppModule{}
	_ module.AppModuleBasic = AppModule{}
	_ appmodule.AppModule   = AppModule{}
)

// AppModule implements the pricefeed module.
type AppModule struct {
	keeper keeper.Keeper
}

// NewAppModule creates a new pricefeed module.
func NewAppModule(keeper keeper.Keeper) AppModule {
	return AppModule{keeper: keeper}
}

// Name returns the x/pricefeed module's name.
func (AppModule) Name() string {
	return types.ModuleName
}

// RegisterLegacyAminoCodec registers the x/pricefeed module's types on the LegacyAmino codec.
func (AppModule) RegisterLegacyAminoCodec(cdc *codec.LegacyAmino) {
	types.RegisterLegacyAminoCodec(cdc)
}

// DefaultGenesis returns default genesis state.
func (AppModule) DefaultGenesis(cdc codec.JSONCodec) json.RawMessage {
	return cdc.MustMarshalJSON(types.DefaultGenesisState())
}

// ValidateGenesis performs genesis state validation.
func (AppModule) ValidateGenesis(cdc codec.JSONCodec, _ client.TxEncodingConfig, bz json.RawMessage) error {
	var data types.GenesisState
	if err := cdc.UnmarshalJSON(bz, &data); err != nil {
		return fmt.Errorf("failed to unmarshal %s genesis state: %w", types.ModuleName, err)
	}
	return data.Validate()
}

// RegisterGRPCGatewayRoutes registers gRPC Gateway routes.
func (AppModule) RegisterGRPCGatewayRoutes(clientCtx client.Context, mux *gwruntime.ServeMux) {
	if err := types.RegisterQueryHandlerClient(context.Background(), mux, types.NewQueryClient(clientCtx)); err != nil {
		panic(err)
	}
}

// RegisterInterfaces registers interfaces and implementations.
func (AppModule) RegisterInterfaces(registry codectypes.InterfaceRegistry) {
	types.RegisterInterfaces(registry)
}

// IsAppModule implements appmodule.AppModule.
func (AppModule) IsAppModule() {}

// RegisterServices registers module services.
func (am AppModule) RegisterServices(cfg module.Configurator) {
	types.RegisterMsgServer(cfg.MsgServer(), keeper.NewMsgServerImpl(am.keeper))
	types.RegisterQueryServer(cfg.QueryServer(), keeper.NewQueryServer(am.keeper))
}

// QuerierRoute returns the module querier route name.
func (AppModule) QuerierRoute() string { return types.RouterKey }

// InitGenesis initializes pricefeed genesis state.
func (am AppModule) InitGenesis(ctx sdk.Context, cdc codec.JSONCodec, data json.RawMessage) {
	start := time.Now()
	var genesisState types.GenesisState
	cdc.MustUnmarshalJSON(data, &genesisState)
	telemetry.MeasureSince(start, "InitGenesis", types.ModuleName, "unmarshal")
	am.keeper.InitGenesis(ctx, &genesisState)
}

// ExportGenesis exports pricefeed genesis state.
func (am AppModule) ExportGenesis(ctx sdk.Context, cdc codec.JSONCodec) json.RawMessage {
	return cdc.MustMarshalJSON(am.keeper.ExportGenesis(ctx))
}

// RegisterStoreDecoder registers a decoder for x/pricefeed module's types.
func (AppModule) RegisterStoreDecoder(_ simulation.StoreDecoderRegistry) {}

// WeightedOperations returns simulation operations.
func (AppModule) WeightedOperations(_ module.SimulationState) []simulation.WeightedOperation {
	return nil
}

// ConsensusVersion implements AppModule/ConsensusVersion.
func (AppModule) ConsensusVersion() uint64 {
	return ConsensusVersion
}
