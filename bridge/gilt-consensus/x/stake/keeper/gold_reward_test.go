package keeper_test

import (
	"context"

	sdkmath "cosmossdk.io/math"
	"github.com/cosmos/cosmos-sdk/codec/address"
	"github.com/cosmos/cosmos-sdk/crypto/keys/secp256k1"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/golang/mock/gomock"

	util "github.com/giltchain/gilt-consensus/common/hex"
	pricefeedtypes "github.com/giltchain/gilt-consensus/x/pricefeed/types"
	staketestutil "github.com/giltchain/gilt-consensus/x/stake/testutil"
	"github.com/giltchain/gilt-consensus/x/stake/types"
)

type staticPricefeedKeeper struct {
	params pricefeedtypes.Params
	price  pricefeedtypes.PriceSnapshot
	fresh  bool
}

func (k staticPricefeedKeeper) GetParams(context.Context) (pricefeedtypes.Params, error) {
	return k.params, nil
}

func (k staticPricefeedKeeper) GetLatestPriceSnapshot(context.Context) (pricefeedtypes.PriceSnapshot, error) {
	return k.price, nil
}

func (k staticPricefeedKeeper) IsLatestPriceFresh(context.Context) (bool, error) {
	return k.fresh, nil
}

func (s *KeeperTestSuite) TestGoldDelegationEscrowsAndUpdatesValidatorAccounting() {
	ctx, keeper, require := s.ctx, s.stakeKeeper, s.Require()
	valSet := staketestutil.LoadRandomValidatorSet(require, 1, keeper, ctx, false, 0, 0)
	validator := valSet.Validators[0]

	delegatorKey := secp256k1.GenPrivKey()
	delegator := util.FormatAddress(delegatorKey.PubKey().Address().String())
	delegatorBytes, err := address.NewHexCodec().StringToBytes(delegator)
	require.NoError(err)
	delegatorAddr := sdk.AccAddress(delegatorBytes)

	amount := sdkmath.NewInt(1_000)
	coins := sdk.NewCoins(sdk.NewCoin(types.GoldDenom, amount))
	s.bankKeeper.EXPECT().
		SendCoinsFromAccountToModule(gomock.Any(), delegatorAddr, types.ModuleName, coins).
		Return(nil)

	_, err = s.msgServer.DelegateGold(ctx, types.NewMsgDelegateGold(delegator, validator.ValId, amount))
	require.NoError(err)

	delegation, err := keeper.GetGoldDelegation(ctx, delegator, validator.ValId)
	require.NoError(err)
	require.True(delegation.Amount.Equal(amount))

	updatedValidator, err := keeper.GetValidatorFromValID(ctx, validator.ValId)
	require.NoError(err)
	require.True(updatedValidator.DelegatedGoldStake.Equal(amount))

	undelegateAmount := sdkmath.NewInt(400)
	undelegateCoins := sdk.NewCoins(sdk.NewCoin(types.GoldDenom, undelegateAmount))
	s.bankKeeper.EXPECT().
		SendCoinsFromModuleToAccount(gomock.Any(), types.ModuleName, delegatorAddr, undelegateCoins).
		Return(nil)

	_, err = s.msgServer.UndelegateGold(ctx, types.NewMsgUndelegateGold(delegator, validator.ValId, undelegateAmount))
	require.NoError(err)

	delegation, err = keeper.GetGoldDelegation(ctx, delegator, validator.ValId)
	require.NoError(err)
	require.True(delegation.Amount.Equal(amount.Sub(undelegateAmount)))

	updatedValidator, err = keeper.GetValidatorFromValID(ctx, validator.ValId)
	require.NoError(err)
	require.True(updatedValidator.DelegatedGoldStake.Equal(amount.Sub(undelegateAmount)))
}

func (s *KeeperTestSuite) TestCurrentValidatorRewardsUseEffectiveRewardWeight() {
	ctx, keeper, require := s.ctx, s.stakeKeeper, s.Require()
	staketestutil.LoadRandomValidatorSet(require, 2, keeper, ctx, false, 0, 0)
	validators := keeper.GetAllValidators(ctx)
	require.Len(validators, 2)

	scale := sdkmath.NewInt(pricefeedtypes.PriceScale)
	validators[0].SelfGiltStake = sdkmath.NewInt(100).Mul(scale)
	validators[0].DelegatedGoldStake = sdkmath.ZeroInt()
	validators[0].RewardWeightEpoch = 0
	validators[1].SelfGiltStake = sdkmath.NewInt(100).Mul(scale)
	validators[1].DelegatedGoldStake = sdkmath.NewInt(100).Mul(scale)
	validators[1].RewardWeightEpoch = 0
	require.NoError(keeper.AddValidator(ctx, *validators[0]))
	require.NoError(keeper.AddValidator(ctx, *validators[1]))

	price := pricefeedtypes.PriceSnapshot{
		Epoch:           1,
		GiltPriceInGold: scale,
		SourceAdapter:   pricefeedtypes.AdapterManual,
		BlockHeight:     1,
		ValidUntilEpoch: 5,
	}
	keeper.SetPricefeedKeeper(staticPricefeedKeeper{
		params: pricefeedtypes.DefaultParams(),
		price:  price,
		fresh:  true,
	})
	s.checkpointKeeper.EXPECT().GetAckCount(gomock.Any()).AnyTimes().Return(uint64(0), nil)

	allocations, err := keeper.AllocateCurrentValidatorRewards(ctx, sdkmath.NewInt(3_000))
	require.NoError(err)
	require.Len(allocations, 2)

	amountBySigner := map[string]sdkmath.Int{}
	for _, allocation := range allocations {
		amountBySigner[allocation.Signer] = allocation.Amount
	}
	require.True(amountBySigner[util.FormatAddress(validators[0].Signer)].Equal(sdkmath.NewInt(1_000)))
	require.True(amountBySigner[util.FormatAddress(validators[1].Signer)].Equal(sdkmath.NewInt(2_000)))
}

func (s *KeeperTestSuite) TestExpiredRewardPricePreventsRewardAllocation() {
	ctx, keeper, require := s.ctx, s.stakeKeeper, s.Require()
	staketestutil.LoadRandomValidatorSet(require, 1, keeper, ctx, false, 0, 0)

	scale := sdkmath.NewInt(pricefeedtypes.PriceScale)
	keeper.SetPricefeedKeeper(staticPricefeedKeeper{
		params: pricefeedtypes.DefaultParams(),
		price: pricefeedtypes.PriceSnapshot{
			Epoch:           1,
			GiltPriceInGold: scale,
			SourceAdapter:   pricefeedtypes.AdapterManual,
			BlockHeight:     1,
			ValidUntilEpoch: 1,
		},
		fresh: true,
	})
	s.checkpointKeeper.EXPECT().GetAckCount(gomock.Any()).AnyTimes().Return(uint64(1), nil)

	allocations, err := keeper.AllocateCurrentValidatorRewards(ctx, sdkmath.NewInt(1_000))
	require.NoError(err)
	require.Empty(allocations)
}
