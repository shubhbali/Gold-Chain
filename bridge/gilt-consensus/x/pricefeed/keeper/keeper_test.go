package keeper_test

import (
	"testing"

	sdkmath "cosmossdk.io/math"
	storetypes "cosmossdk.io/store/types"
	"github.com/cosmos/cosmos-sdk/runtime"
	"github.com/cosmos/cosmos-sdk/testutil"
	sdk "github.com/cosmos/cosmos-sdk/types"
	moduletestutil "github.com/cosmos/cosmos-sdk/types/module/testutil"
	authtypes "github.com/cosmos/cosmos-sdk/x/auth/types"
	govtypes "github.com/cosmos/cosmos-sdk/x/gov/types"
	"github.com/stretchr/testify/require"

	"github.com/giltchain/gilt-consensus/x/pricefeed/keeper"
	"github.com/giltchain/gilt-consensus/x/pricefeed/types"
)

func TestPriceSnapshotUsesActiveAdapterAndRoute(t *testing.T) {
	ctx, k := setupKeeper(t)

	manualPrice := priceSnapshot(1, types.AdapterManual, "", types.PriceScale)
	require.NoError(t, k.SetPriceSnapshot(ctx, manualPrice))

	dexPrice := priceSnapshot(2, types.AdapterDexTwap, "wGOLD/wGILT:stable", types.PriceScale)
	require.ErrorContains(t, k.SetPriceSnapshot(ctx, dexPrice), "does not match active adapter")

	params := types.DefaultParams()
	params.ActiveAdapter = types.AdapterDexTwap
	params.AdapterRoute = "wGOLD/wGILT:stable"
	require.NoError(t, k.SetParams(ctx, params))

	wrongRoute := priceSnapshot(2, types.AdapterDexTwap, "wrong-route", types.PriceScale)
	require.ErrorContains(t, k.SetPriceSnapshot(ctx, wrongRoute), "snapshot route does not match")

	require.NoError(t, k.SetPriceSnapshot(ctx, dexPrice))
	latest, err := k.GetLatestPriceSnapshot(ctx)
	require.NoError(t, err)
	require.Equal(t, types.AdapterDexTwap, latest.SourceAdapter)
	require.Equal(t, "wGOLD/wGILT:stable", latest.AdapterRoute)
}

func TestPriceSnapshotRejectsExcessiveDeviation(t *testing.T) {
	ctx, k := setupKeeper(t)

	require.NoError(t, k.SetPriceSnapshot(ctx, priceSnapshot(1, types.AdapterManual, "", types.PriceScale)))
	require.ErrorContains(t, k.SetPriceSnapshot(ctx, priceSnapshot(2, types.AdapterManual, "", types.PriceScale*2)), "price movement exceeds")
}

func TestPriceSnapshotEpochMustIncrease(t *testing.T) {
	ctx, k := setupKeeper(t)

	require.NoError(t, k.SetPriceSnapshot(ctx, priceSnapshot(2, types.AdapterManual, "", types.PriceScale)))
	require.ErrorContains(t, k.SetPriceSnapshot(ctx, priceSnapshot(1, types.AdapterManual, "", types.PriceScale)), "epoch must increase")
	require.ErrorContains(t, k.SetPriceSnapshot(ctx, priceSnapshot(2, types.AdapterManual, "", types.PriceScale)), "epoch must increase")
	require.NoError(t, k.SetPriceSnapshot(ctx, priceSnapshot(3, types.AdapterManual, "", types.PriceScale)))
}

func TestPriceSnapshotFreshnessUsesBlockAge(t *testing.T) {
	ctx, k := setupKeeper(t)
	ctx = ctx.WithBlockHeight(100)

	snapshot := priceSnapshot(1, types.AdapterManual, "", types.PriceScale)
	require.NoError(t, k.SetPriceSnapshot(ctx, snapshot))

	fresh, err := k.IsLatestPriceFresh(ctx.WithBlockHeight(100 + int64(types.DefaultMaxPriceAgeBlocks)))
	require.NoError(t, err)
	require.True(t, fresh)

	fresh, err = k.IsLatestPriceFresh(ctx.WithBlockHeight(101 + int64(types.DefaultMaxPriceAgeBlocks)))
	require.NoError(t, err)
	require.False(t, fresh)
}

func TestUpdateParamsCannotBypassScheduledAdapterSwitch(t *testing.T) {
	ctx, k := setupKeeper(t)
	msgServer := keeper.NewMsgServerImpl(k)

	params := types.DefaultParams()
	params.ActiveAdapter = types.AdapterDexTwap
	_, err := msgServer.UpdateParams(ctx, &types.MsgUpdateParams{
		Authority: k.GetAuthority(),
		Params:    params,
	})
	require.ErrorContains(t, err, "active_adapter must be changed")

	params = types.DefaultParams()
	params.MaxPriceDeviationBps = 1000
	_, err = msgServer.UpdateParams(ctx, &types.MsgUpdateParams{
		Authority: k.GetAuthority(),
		Params:    params,
	})
	require.NoError(t, err)
}

func setupKeeper(t *testing.T) (sdk.Context, keeper.Keeper) {
	t.Helper()

	key := storetypes.NewKVStoreKey(types.StoreKey)
	testCtx := testutil.DefaultContextWithDB(t, key, storetypes.NewTransientStoreKey("transient_pricefeed_test"))
	encCfg := moduletestutil.MakeTestEncodingConfig()
	authority := authtypes.NewModuleAddress(govtypes.ModuleName).String()
	k := keeper.NewKeeper(encCfg.Codec, runtime.NewKVStoreService(key), authority)
	require.NoError(t, k.SetParams(testCtx.Ctx, types.DefaultParams()))

	return testCtx.Ctx, k
}

func priceSnapshot(epoch uint64, adapter string, route string, price int64) types.PriceSnapshot {
	return types.PriceSnapshot{
		Epoch:           epoch,
		GiltPriceInGold: sdkmath.NewInt(price),
		SourceAdapter:   adapter,
		AdapterRoute:    route,
		ValidUntilEpoch: epoch,
	}
}
