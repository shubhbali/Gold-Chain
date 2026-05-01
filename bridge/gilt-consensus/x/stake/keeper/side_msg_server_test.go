package keeper_test

import (
	"testing"

	"github.com/stretchr/testify/require"

	"github.com/giltchain/gilt-consensus/sidetxs"
	stakeKeeper "github.com/giltchain/gilt-consensus/x/stake/keeper"
	"github.com/giltchain/gilt-consensus/x/stake/types"
)

func TestNativeValidatorLifecycleDoesNotRegisterSideTxHandlers(t *testing.T) {
	cfg := sidetxs.NewSideTxConfigurator()
	types.RegisterSideMsgServer(cfg, stakeKeeper.NewSideMsgServerImpl(nil))

	require.Nil(t, cfg.GetSideHandler(&types.MsgApproveValidator{}))
	require.Nil(t, cfg.GetPostHandler(&types.MsgApproveValidator{}))
	require.Nil(t, cfg.GetSideHandler(&types.MsgValidatorJoin{}))
	require.Nil(t, cfg.GetPostHandler(&types.MsgValidatorJoin{}))
	require.Nil(t, cfg.GetSideHandler(&types.MsgStakeUpdate{}))
	require.Nil(t, cfg.GetPostHandler(&types.MsgStakeUpdate{}))
	require.Nil(t, cfg.GetSideHandler(&types.MsgSignerUpdate{}))
	require.Nil(t, cfg.GetPostHandler(&types.MsgSignerUpdate{}))
	require.Nil(t, cfg.GetSideHandler(&types.MsgValidatorExit{}))
	require.Nil(t, cfg.GetPostHandler(&types.MsgValidatorExit{}))
	require.Nil(t, cfg.GetSideHandler(&types.MsgWithdrawValidatorStake{}))
	require.Nil(t, cfg.GetPostHandler(&types.MsgWithdrawValidatorStake{}))
}
