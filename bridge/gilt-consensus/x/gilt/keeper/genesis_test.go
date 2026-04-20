package keeper_test

import "github.com/giltchain/gilt-consensus/x/gilt/types"

// TestInitExportGenesis test import and export genesis state
func (s *KeeperTestSuite) TestInitExportGenesis() {
	keeper, ctx, require := s.giltKeeper, s.ctx, s.Require()

	params := types.DefaultParams()
	genSpansPtr := s.genTestSpans(5)
	genSpans := make([]types.Span, len(genSpansPtr))
	for i, spanPtr := range genSpansPtr {
		genSpans[i] = *spanPtr
	}

	genesisState := &types.GenesisState{
		Params: params,
		Spans:  genSpans,
	}

	keeper.InitGenesis(ctx, genesisState)

	actualParams := keeper.ExportGenesis(ctx)
	require.Equal(genesisState, actualParams)
}
