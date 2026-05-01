package keeper_test

import (
	"cosmossdk.io/math"
	"github.com/cosmos/cosmos-sdk/crypto/keys/secp256k1"
	"github.com/golang/mock/gomock"

	util "github.com/giltchain/gilt-consensus/common/hex"
	"github.com/giltchain/gilt-consensus/x/stake/types"
)

var oneGilt = math.NewInt(1000000000000000000)

const TxHash1 = "0x000000000000000000000000000000000000000000000000000000000000dead"

func (s *KeeperTestSuite) TestNativeValidatorApprovalAndJoin() {
	ctx, msgServer, keeper, require := s.ctx, s.msgServer, s.stakeKeeper, s.Require()
	validators := s.seedNativeValidators(4)
	operator := secp256k1.GenPrivKey().PubKey().Address().String()

	joinPubKey := secp256k1.GenPrivKey().PubKey()
	approveMsg, err := types.NewMsgApproveValidator(validators[0].OperatorAddress(), 5, operator, 1, oneGilt, joinPubKey, 1)
	require.NoError(err)
	_, err = msgServer.ApproveValidator(ctx, approveMsg)
	require.NoError(err)

	joinMsg, err := types.NewMsgValidatorJoin(operator, 5, 1, oneGilt, joinPubKey, 1)
	require.NoError(err)
	_, err = msgServer.ValidatorJoin(ctx, joinMsg)
	require.Error(err)
	require.Contains(err.Error(), "pending 2/3 vote finalization")

	approveMsg, err = types.NewMsgApproveValidator(validators[1].OperatorAddress(), 5, operator, 1, oneGilt, joinPubKey, 1)
	require.NoError(err)
	_, err = msgServer.ApproveValidator(ctx, approveMsg)
	require.NoError(err)

	approveMsg, err = types.NewMsgApproveValidator(validators[2].OperatorAddress(), 5, operator, 1, oneGilt, joinPubKey, 1)
	require.NoError(err)
	_, err = msgServer.ApproveValidator(ctx, approveMsg)
	require.NoError(err)

	s.bankKeeper.EXPECT().
		SendCoinsFromAccountToModule(gomock.Any(), gomock.Any(), types.ModuleName, gomock.Any()).
		Return(nil).
		Times(1)

	_, err = msgServer.ValidatorJoin(ctx, joinMsg)
	require.NoError(err)

	validator, err := keeper.GetValidatorFromValID(ctx, 5)
	require.NoError(err)
	require.Equal(util.FormatAddress(operator), validator.OperatorAddress())
	require.Equal(oneGilt, validator.SelfGiltStake)
}

func (s *KeeperTestSuite) TestNativeValidatorApprovalRejectsDuplicateVote() {
	ctx, msgServer, require := s.ctx, s.msgServer, s.Require()
	validators := s.seedNativeValidators(4)

	operator := secp256k1.GenPrivKey().PubKey().Address().String()
	joinPubKey := secp256k1.GenPrivKey().PubKey()

	approveMsg, err := types.NewMsgApproveValidator(validators[0].OperatorAddress(), 10, operator, 1, oneGilt, joinPubKey, 1)
	require.NoError(err)
	_, err = msgServer.ApproveValidator(ctx, approveMsg)
	require.NoError(err)

	_, err = msgServer.ApproveValidator(ctx, approveMsg)
	require.Error(err)
	require.Contains(err.Error(), "already voted")
}

func (s *KeeperTestSuite) TestNativeValidatorApprovalRequiresActiveValidatorVoter() {
	ctx, msgServer, require := s.ctx, s.msgServer, s.Require()
	s.seedNativeValidators(4)

	operator := secp256k1.GenPrivKey().PubKey().Address().String()
	joinPubKey := secp256k1.GenPrivKey().PubKey()
	outsider := secp256k1.GenPrivKey().PubKey().Address().String()

	approveMsg, err := types.NewMsgApproveValidator(outsider, 10, operator, 1, oneGilt, joinPubKey, 1)
	require.NoError(err)
	_, err = msgServer.ApproveValidator(ctx, approveMsg)
	require.Error(err)
	require.Contains(err.Error(), "only active validators can vote")
}

func (s *KeeperTestSuite) TestNativeValidatorApprovalRequiresStrictlyMoreThanTwoThirdsPower() {
	ctx, msgServer, keeper, require := s.ctx, s.msgServer, s.stakeKeeper, s.Require()
	validators := s.seedNativeValidators(3)
	operator := secp256k1.GenPrivKey().PubKey().Address().String()
	joinPubKey := secp256k1.GenPrivKey().PubKey()

	voteMsg, err := types.NewMsgApproveValidator(validators[0].OperatorAddress(), 15, operator, 1, oneGilt, joinPubKey, 1)
	require.NoError(err)
	_, err = msgServer.ApproveValidator(ctx, voteMsg)
	require.NoError(err)

	voteMsg, err = types.NewMsgApproveValidator(validators[1].OperatorAddress(), 15, operator, 1, oneGilt, joinPubKey, 1)
	require.NoError(err)
	_, err = msgServer.ApproveValidator(ctx, voteMsg)
	require.NoError(err)

	yesPower, totalPower, finalized, err := keeper.GetValidatorApprovalVoteStatus(ctx, 15)
	require.NoError(err)
	require.Equal(uint64(2), yesPower)
	require.Equal(uint64(3), totalPower)
	require.False(finalized)

	joinMsg, err := types.NewMsgValidatorJoin(operator, 15, 1, oneGilt, joinPubKey, 1)
	require.NoError(err)
	_, err = msgServer.ValidatorJoin(ctx, joinMsg)
	require.Error(err)
	require.Contains(err.Error(), "pending 2/3 vote finalization")

	voteMsg, err = types.NewMsgApproveValidator(validators[2].OperatorAddress(), 15, operator, 1, oneGilt, joinPubKey, 1)
	require.NoError(err)
	_, err = msgServer.ApproveValidator(ctx, voteMsg)
	require.NoError(err)

	yesPower, totalPower, finalized, err = keeper.GetValidatorApprovalVoteStatus(ctx, 15)
	require.NoError(err)
	require.Equal(uint64(3), yesPower)
	require.Equal(uint64(3), totalPower)
	require.True(finalized)

	s.bankKeeper.EXPECT().
		SendCoinsFromAccountToModule(gomock.Any(), gomock.Any(), types.ModuleName, gomock.Any()).
		Return(nil).
		Times(1)

	_, err = msgServer.ValidatorJoin(ctx, joinMsg)
	require.NoError(err)
}

func (s *KeeperTestSuite) TestNativeValidatorApprovalRejectsNextNonceWhilePending() {
	ctx, msgServer, require := s.ctx, s.msgServer, s.Require()
	validators := s.seedNativeValidators(3)
	operator := secp256k1.GenPrivKey().PubKey().Address().String()
	joinPubKey := secp256k1.GenPrivKey().PubKey()

	voteMsg, err := types.NewMsgApproveValidator(validators[0].OperatorAddress(), 16, operator, 1, oneGilt, joinPubKey, 1)
	require.NoError(err)
	_, err = msgServer.ApproveValidator(ctx, voteMsg)
	require.NoError(err)

	nextNonceMsg, err := types.NewMsgApproveValidator(validators[1].OperatorAddress(), 16, operator, 1, oneGilt, joinPubKey, 2)
	require.NoError(err)
	_, err = msgServer.ApproveValidator(ctx, nextNonceMsg)
	require.Error(err)
	require.Contains(err.Error(), "still pending and not finalized")
}

func (s *KeeperTestSuite) TestNativeValidatorApprovalRejectsMismatchedPendingPayload() {
	ctx, msgServer, require := s.ctx, s.msgServer, s.Require()
	validators := s.seedNativeValidators(3)
	operator := secp256k1.GenPrivKey().PubKey().Address().String()
	joinPubKey := secp256k1.GenPrivKey().PubKey()

	voteMsg, err := types.NewMsgApproveValidator(validators[0].OperatorAddress(), 17, operator, 1, oneGilt, joinPubKey, 1)
	require.NoError(err)
	_, err = msgServer.ApproveValidator(ctx, voteMsg)
	require.NoError(err)

	mismatchedMsg, err := types.NewMsgApproveValidator(validators[1].OperatorAddress(), 17, operator, 1, oneGilt.MulRaw(2), joinPubKey, 1)
	require.NoError(err)
	_, err = msgServer.ApproveValidator(ctx, mismatchedMsg)
	require.Error(err)
	require.Contains(err.Error(), "payload does not match existing pending proposal")
}

func (s *KeeperTestSuite) TestNativeValidatorApprovalNewNonceForExistingValidatorRequiresOperatorProposal() {
	ctx, msgServer, require := s.ctx, s.msgServer, s.Require()
	validators := s.seedNativeValidators(4)

	target := validators[0]
	nonOperatorVoter := validators[1]
	msg, err := types.NewMsgApproveValidator(
		nonOperatorVoter.OperatorAddress(),
		target.ValId,
		target.OperatorAddress(),
		target.StartEpoch,
		target.SelfGiltStake,
		secp256k1.GenPrivKey().PubKey(),
		1,
	)
	require.NoError(err)

	_, err = msgServer.ApproveValidator(ctx, msg)
	require.Error(err)
	require.Contains(err.Error(), "only the validator operator can propose updates for an existing validator")
}

func (s *KeeperTestSuite) TestNativeValidatorApprovalSnapshotVoterCanVoteAfterSetDrift() {
	ctx, msgServer, keeper, require := s.ctx, s.msgServer, s.stakeKeeper, s.Require()
	validators := s.seedNativeValidators(3)
	operator := secp256k1.GenPrivKey().PubKey().Address().String()
	joinPubKey := secp256k1.GenPrivKey().PubKey()

	firstVote, err := types.NewMsgApproveValidator(validators[0].OperatorAddress(), 18, operator, 1, oneGilt, joinPubKey, 1)
	require.NoError(err)
	_, err = msgServer.ApproveValidator(ctx, firstVote)
	require.NoError(err)

	currentSet, err := keeper.GetValidatorSet(ctx)
	require.NoError(err)
	drifted := make([]*types.Validator, 0, len(currentSet.Validators)-1)
	for _, validator := range currentSet.Validators {
		if validator.ValId == validators[1].ValId {
			continue
		}
		drifted = append(drifted, validator.Copy())
	}
	s.overwriteNativeValidatorSet(drifted)

	removedSnapshotVoterVote, err := types.NewMsgApproveValidator(validators[1].OperatorAddress(), 18, operator, 1, oneGilt, joinPubKey, 1)
	require.NoError(err)
	_, err = msgServer.ApproveValidator(ctx, removedSnapshotVoterVote)
	require.NoError(err)

	yesPower, totalPower, finalized, err := keeper.GetValidatorApprovalVoteStatus(ctx, 18)
	require.NoError(err)
	require.Equal(uint64(2), yesPower)
	require.Equal(uint64(3), totalPower)
	require.False(finalized)
}

func (s *KeeperTestSuite) TestNativeValidatorApprovalRejectsPostSnapshotValidator() {
	ctx, msgServer, keeper, require := s.ctx, s.msgServer, s.stakeKeeper, s.Require()
	validators := s.seedNativeValidators(3)
	operator := secp256k1.GenPrivKey().PubKey().Address().String()
	joinPubKey := secp256k1.GenPrivKey().PubKey()

	firstVote, err := types.NewMsgApproveValidator(validators[0].OperatorAddress(), 19, operator, 1, oneGilt, joinPubKey, 1)
	require.NoError(err)
	_, err = msgServer.ApproveValidator(ctx, firstVote)
	require.NoError(err)

	postSnapshotPubKey := secp256k1.GenPrivKey().PubKey()
	postSnapshotValidator, err := types.NewValidator(90, 1, 0, 1, 1, postSnapshotPubKey, postSnapshotPubKey.Address().String())
	require.NoError(err)
	postSnapshotValidator.SelfGiltStake = oneGilt
	postSnapshotValidator.NormalizeLifecycleAccounting()
	require.NoError(keeper.AddValidator(ctx, *postSnapshotValidator))

	currentSet, err := keeper.GetValidatorSet(ctx)
	require.NoError(err)
	drifted := make([]*types.Validator, 0, len(currentSet.Validators)+1)
	for _, validator := range currentSet.Validators {
		drifted = append(drifted, validator.Copy())
	}
	drifted = append(drifted, postSnapshotValidator.Copy())
	s.overwriteNativeValidatorSet(drifted)

	postSnapshotVote, err := types.NewMsgApproveValidator(postSnapshotValidator.OperatorAddress(), 19, operator, 1, oneGilt, joinPubKey, 1)
	require.NoError(err)
	_, err = msgServer.ApproveValidator(ctx, postSnapshotVote)
	require.Error(err)
	require.Contains(err.Error(), "not eligible in this approval snapshot")
}

func (s *KeeperTestSuite) TestNativeValidatorApprovalFinalizesUnderValidatorSetDrift() {
	ctx, msgServer, keeper, require := s.ctx, s.msgServer, s.stakeKeeper, s.Require()
	validators := s.seedNativeValidators(4)
	operator := secp256k1.GenPrivKey().PubKey().Address().String()
	joinPubKey := secp256k1.GenPrivKey().PubKey()

	firstVote, err := types.NewMsgApproveValidator(validators[0].OperatorAddress(), 20, operator, 1, oneGilt, joinPubKey, 1)
	require.NoError(err)
	_, err = msgServer.ApproveValidator(ctx, firstVote)
	require.NoError(err)

	postSnapshotPubKey := secp256k1.GenPrivKey().PubKey()
	postSnapshotValidator, err := types.NewValidator(91, 1, 0, 1, 1, postSnapshotPubKey, postSnapshotPubKey.Address().String())
	require.NoError(err)
	postSnapshotValidator.SelfGiltStake = oneGilt
	postSnapshotValidator.NormalizeLifecycleAccounting()
	require.NoError(keeper.AddValidator(ctx, *postSnapshotValidator))

	currentSet, err := keeper.GetValidatorSet(ctx)
	require.NoError(err)
	drifted := make([]*types.Validator, 0, len(currentSet.Validators))
	for _, validator := range currentSet.Validators {
		if validator.ValId == validators[1].ValId {
			continue
		}
		drifted = append(drifted, validator.Copy())
	}
	drifted = append(drifted, postSnapshotValidator.Copy())
	s.overwriteNativeValidatorSet(drifted)

	secondVote, err := types.NewMsgApproveValidator(validators[1].OperatorAddress(), 20, operator, 1, oneGilt, joinPubKey, 1)
	require.NoError(err)
	_, err = msgServer.ApproveValidator(ctx, secondVote)
	require.NoError(err)

	thirdVote, err := types.NewMsgApproveValidator(validators[2].OperatorAddress(), 20, operator, 1, oneGilt, joinPubKey, 1)
	require.NoError(err)
	_, err = msgServer.ApproveValidator(ctx, thirdVote)
	require.NoError(err)

	yesPower, totalPower, finalized, err := keeper.GetValidatorApprovalVoteStatus(ctx, 20)
	require.NoError(err)
	require.Equal(uint64(3), yesPower)
	require.Equal(uint64(4), totalPower)
	require.True(finalized)
}

func (s *KeeperTestSuite) TestNativeValidatorApprovalRejectsOperatorConflictWithActiveValidator() {
	ctx, msgServer, require := s.ctx, s.msgServer, s.Require()
	validators := s.seedNativeValidators(4)

	conflictingOperator := validators[2].OperatorAddress()
	joinPubKey := secp256k1.GenPrivKey().PubKey()
	msg, err := types.NewMsgApproveValidator(validators[0].OperatorAddress(), 21, conflictingOperator, 1, oneGilt, joinPubKey, 1)
	require.NoError(err)

	_, err = msgServer.ApproveValidator(ctx, msg)
	require.Error(err)
	require.Contains(err.Error(), "already controls active validator")
}

func (s *KeeperTestSuite) TestNativeValidatorApprovalRejectsOperatorConflictWithPendingProposal() {
	ctx, msgServer, require := s.ctx, s.msgServer, s.Require()
	validators := s.seedNativeValidators(4)

	targetOperator := secp256k1.GenPrivKey().PubKey().Address().String()
	joinPubKey := secp256k1.GenPrivKey().PubKey()

	firstMsg, err := types.NewMsgApproveValidator(validators[0].OperatorAddress(), 22, targetOperator, 1, oneGilt, joinPubKey, 1)
	require.NoError(err)
	_, err = msgServer.ApproveValidator(ctx, firstMsg)
	require.NoError(err)

	secondMsg, err := types.NewMsgApproveValidator(validators[1].OperatorAddress(), 23, targetOperator, 1, oneGilt, joinPubKey, 1)
	require.NoError(err)
	_, err = msgServer.ApproveValidator(ctx, secondMsg)
	require.Error(err)
	require.Contains(err.Error(), "already has pending validator approval")
}

func (s *KeeperTestSuite) TestNativeValidatorJoinRejectsOperatorConflictWithActiveValidator() {
	ctx, msgServer, keeper, require := s.ctx, s.msgServer, s.stakeKeeper, s.Require()
	validators := s.seedNativeValidators(4)

	conflictingOperator := validators[1].OperatorAddress()
	joinPubKey := secp256k1.GenPrivKey().PubKey()
	require.NoError(keeper.SetValidatorApproval(ctx, types.ValidatorApproval{
		ValId:           24,
		Operator:        conflictingOperator,
		ActivationEpoch: 1,
		MaxGiltStake:    oneGilt,
		SignerPubKey:    joinPubKey.Bytes(),
		Nonce:           1,
	}))

	joinMsg, err := types.NewMsgValidatorJoin(conflictingOperator, 24, 1, oneGilt, joinPubKey, 1)
	require.NoError(err)

	_, err = msgServer.ValidatorJoin(ctx, joinMsg)
	require.Error(err)
	require.Contains(err.Error(), "already controls active validator")
}

func (s *KeeperTestSuite) TestNativeStakeUpdateOnlyIncreasesApprovedGiltStake() {
	ctx, msgServer, keeper, require := s.ctx, s.msgServer, s.stakeKeeper, s.Require()
	validators := s.seedNativeValidators(6)
	s.checkpointKeeper.EXPECT().GetAckCount(gomock.Any()).AnyTimes().Return(uint64(0), nil)

	approval := types.ValidatorApproval{
		ValId:           validators[0].ValId,
		Operator:        validators[0].OperatorAddress(),
		ActivationEpoch: validators[0].StartEpoch,
		MaxGiltStake:    oneGilt.MulRaw(2),
		SignerPubKey:    validators[0].PubKey,
		Nonce:           1,
	}
	require.NoError(keeper.SetValidatorApproval(ctx, approval))

	msg, err := types.NewMsgStakeUpdate(validators[0].OperatorAddress(), validators[0].ValId, oneGilt.MulRaw(2), 2)
	require.NoError(err)
	s.bankKeeper.EXPECT().
		SendCoinsFromAccountToModule(gomock.Any(), gomock.Any(), types.ModuleName, gomock.Any()).
		Return(nil).
		Times(1)

	_, err = msgServer.StakeUpdate(ctx, msg)
	require.NoError(err)

	updated, err := keeper.GetValidatorFromValID(ctx, validators[0].ValId)
	require.NoError(err)
	require.Equal(oneGilt.MulRaw(2), updated.SelfGiltStake)
	require.Equal(int64(2), updated.VotingPower)
}

func (s *KeeperTestSuite) TestNativeSignerUpdateUsesOperator() {
	ctx, msgServer, keeper, require := s.ctx, s.msgServer, s.stakeKeeper, s.Require()
	validators := s.seedNativeValidators(4)

	newSignerPubKey := secp256k1.GenPrivKey().PubKey()
	require.NoError(keeper.SetValidatorApproval(ctx, types.ValidatorApproval{
		ValId:           validators[0].ValId,
		Operator:        validators[0].OperatorAddress(),
		ActivationEpoch: validators[0].StartEpoch,
		MaxGiltStake:    validators[0].SelfGiltStake,
		SignerPubKey:    newSignerPubKey.Bytes(),
		Nonce:           2,
	}))
	msg, err := types.NewMsgSignerUpdate(validators[0].OperatorAddress(), validators[0].ValId, newSignerPubKey.Bytes(), 2)
	require.NoError(err)

	_, err = msgServer.SignerUpdate(ctx, msg)
	require.NoError(err)

	updated, err := keeper.GetValidatorFromValID(ctx, validators[0].ValId)
	require.NoError(err)
	require.Equal(util.FormatAddress(newSignerPubKey.Address().String()), updated.Signer)

	old, err := keeper.GetValidatorInfo(ctx, validators[0].Signer)
	require.NoError(err)
	require.Equal(int64(0), old.VotingPower)
	require.True(old.SelfGiltStake.IsZero())
}

func (s *KeeperTestSuite) TestNativeSignerUpdateRequiresApprovedSigner() {
	ctx, msgServer, require := s.ctx, s.msgServer, s.Require()
	validators := s.seedNativeValidators(4)

	newSignerPubKey := secp256k1.GenPrivKey().PubKey()
	msg, err := types.NewMsgSignerUpdate(validators[0].OperatorAddress(), validators[0].ValId, newSignerPubKey.Bytes(), 2)
	require.NoError(err)

	_, err = msgServer.SignerUpdate(ctx, msg)
	require.Error(err)
	require.Contains(err.Error(), "validator signer approval is missing")
}

func (s *KeeperTestSuite) TestNativeStakeUpdateAfterSignerUpdateRespectsPowerCap() {
	ctx, msgServer, keeper, require := s.ctx, s.msgServer, s.stakeKeeper, s.Require()
	validators := s.seedNativeValidators(4)
	s.checkpointKeeper.EXPECT().GetAckCount(gomock.Any()).AnyTimes().Return(uint64(0), nil)

	newSignerPubKey := secp256k1.GenPrivKey().PubKey()
	require.NoError(keeper.SetValidatorApproval(ctx, types.ValidatorApproval{
		ValId:           validators[0].ValId,
		Operator:        validators[0].OperatorAddress(),
		ActivationEpoch: validators[0].StartEpoch,
		MaxGiltStake:    oneGilt.MulRaw(2),
		SignerPubKey:    newSignerPubKey.Bytes(),
		Nonce:           2,
	}))
	signerMsg, err := types.NewMsgSignerUpdate(validators[0].OperatorAddress(), validators[0].ValId, newSignerPubKey.Bytes(), 2)
	require.NoError(err)
	_, err = msgServer.SignerUpdate(ctx, signerMsg)
	require.NoError(err)

	stakeMsg, err := types.NewMsgStakeUpdate(validators[0].OperatorAddress(), validators[0].ValId, oneGilt.MulRaw(2), 3)
	require.NoError(err)
	_, err = msgServer.StakeUpdate(ctx, stakeMsg)
	require.Error(err)
	require.Contains(err.Error(), "exceeds max voting power cap")
}

func (s *KeeperTestSuite) TestNativeValidatorExitRespectsMinimumActiveSet() {
	ctx, msgServer, keeper, require := s.ctx, s.msgServer, s.stakeKeeper, s.Require()
	validators := s.seedNativeValidators(5)
	s.checkpointKeeper.EXPECT().GetAckCount(gomock.Any()).AnyTimes().Return(uint64(0), nil)

	msg, err := types.NewMsgValidatorExit(validators[0].OperatorAddress(), validators[0].ValId, 2)
	require.NoError(err)

	_, err = msgServer.ValidatorExit(ctx, msg)
	require.NoError(err)

	updated, err := keeper.GetValidatorFromValID(ctx, validators[0].ValId)
	require.NoError(err)
	require.Equal(int64(0), updated.VotingPower)
	require.Equal(uint64(3), updated.EndEpoch)
}

func (s *KeeperTestSuite) TestNativeValidatorExitRejectsDroppingBelowMinimumActiveSet() {
	ctx, msgServer, require := s.ctx, s.msgServer, s.Require()
	validators := s.seedNativeValidators(4)
	s.checkpointKeeper.EXPECT().GetAckCount(gomock.Any()).AnyTimes().Return(uint64(0), nil)

	msg, err := types.NewMsgValidatorExit(validators[0].OperatorAddress(), validators[0].ValId, 2)
	require.NoError(err)

	_, err = msgServer.ValidatorExit(ctx, msg)
	require.Error(err)
	require.Contains(err.Error(), "below minimum")
}

func (s *KeeperTestSuite) TestWithdrawValidatorStakeAfterUnbonding() {
	ctx, msgServer, keeper, require := s.ctx, s.msgServer, s.stakeKeeper, s.Require()
	validators := s.seedNativeValidators(4)
	validators[0].VotingPower = 0
	validators[0].EndEpoch = 2
	require.NoError(keeper.AddValidator(ctx, validators[0]))
	s.checkpointKeeper.EXPECT().GetAckCount(gomock.Any()).AnyTimes().Return(uint64(3), nil)

	msg := types.NewMsgWithdrawValidatorStake(validators[0].OperatorAddress(), validators[0].ValId)
	s.bankKeeper.EXPECT().
		SendCoinsFromModuleToAccount(gomock.Any(), types.ModuleName, gomock.Any(), gomock.Any()).
		Return(nil).
		Times(1)

	_, err := msgServer.WithdrawValidatorStake(ctx, msg)
	require.NoError(err)

	updated, err := keeper.GetValidatorFromValID(ctx, validators[0].ValId)
	require.NoError(err)
	require.True(updated.SelfGiltStake.IsZero())
}

func (s *KeeperTestSuite) seedNativeValidators(count int) []types.Validator {
	ctx, keeper, require := s.ctx, s.stakeKeeper, s.Require()
	validators := make([]types.Validator, 0, count)
	setValidators := make([]*types.Validator, 0, count)

	for i := 0; i < count; i++ {
		pubKey := secp256k1.GenPrivKey().PubKey()
		validator, err := types.NewValidator(uint64(i+1), 1, 0, 1, 1, pubKey, pubKey.Address().String())
		require.NoError(err)
		validator.SelfGiltStake = oneGilt
		validator.NormalizeLifecycleAccounting()

		require.NoError(keeper.AddValidator(ctx, *validator))
		validators = append(validators, *validator)
		setValidators = append(setValidators, validator)
	}

	validatorSet := types.NewValidatorSet(setValidators)
	require.NoError(keeper.UpdateValidatorSetInStore(ctx, *validatorSet))
	require.NoError(keeper.UpdatePreviousBlockValidatorSetInStore(ctx, *validatorSet))
	require.NoError(keeper.UpdatePenultimateBlockValidatorSetInStore(ctx, *validatorSet))
	return validators
}

func (s *KeeperTestSuite) overwriteNativeValidatorSet(validators []*types.Validator) {
	ctx, keeper, require := s.ctx, s.stakeKeeper, s.Require()
	validatorSet := types.NewValidatorSet(validators)
	require.NoError(keeper.UpdateValidatorSetInStore(ctx, *validatorSet))
	require.NoError(keeper.UpdatePreviousBlockValidatorSetInStore(ctx, *validatorSet))
	require.NoError(keeper.UpdatePenultimateBlockValidatorSetInStore(ctx, *validatorSet))
}
