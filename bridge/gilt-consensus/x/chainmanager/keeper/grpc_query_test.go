package keeper_test

import (
	"github.com/giltchain/gilt-consensus/x/chainmanager/types"
)

func (s *KeeperTestSuite) TestGRPCQueryParams() {
	queryClient, require, ctx := s.queryClient, s.Require(), s.ctx

	expParams := types.DefaultParams()
	res, err := queryClient.GetChainManagerParams(ctx, &types.QueryParamsRequest{})
	require.NoError(err)
	require.NotNil(res)
	require.Equal(expParams, res.Params)
}
