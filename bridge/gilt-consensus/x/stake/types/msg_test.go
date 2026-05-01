package types_test

import (
	"bytes"
	"testing"

	"cosmossdk.io/math"
	"github.com/cosmos/cosmos-sdk/codec"
	codectypes "github.com/cosmos/cosmos-sdk/codec/types"
	cryptocodec "github.com/cosmos/cosmos-sdk/crypto/codec"
	"github.com/cosmos/cosmos-sdk/crypto/keys/secp256k1"
	cryptotypes "github.com/cosmos/cosmos-sdk/crypto/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"

	"github.com/giltchain/gilt-consensus/x/stake/types"
)

func TestMsgDecode(t *testing.T) {
	registry := codectypes.NewInterfaceRegistry()
	cryptocodec.RegisterInterfaces(registry)
	types.RegisterInterfaces(registry)
	cdc := codec.NewProtoCodec(registry)

	// testing the pubKey serialization
	pk1 := secp256k1.GenPrivKey().PubKey()
	pk1bz, err := cdc.MarshalInterface(pk1)
	require.NoError(t, err)
	var pkUnmarshalled cryptotypes.PubKey
	err = cdc.UnmarshalInterface(pk1bz, &pkUnmarshalled)
	require.NoError(t, err)
	require.True(t, pk1.Equals(pkUnmarshalled.(*secp256k1.PubKey)))

	msgApproveValidator, err := types.NewMsgApproveValidator(
		pk1.Address().String(),
		uint64(1),
		pk1.Address().String(),
		uint64(1),
		math.NewInt(int64(1000000000000000000)),
		pk1,
		uint64(1),
	)

	require.NoError(t, err)
	msgSerialized, err := cdc.MarshalInterface(msgApproveValidator)
	require.NoError(t, err)

	var msgUnmarshalled sdk.Msg
	err = cdc.UnmarshalInterface(msgSerialized, &msgUnmarshalled)
	require.NoError(t, err)
	msgApproveValidator2, ok := msgUnmarshalled.(*types.MsgApproveValidator)
	require.True(t, ok)
	require.Equal(t, msgApproveValidator.From, msgApproveValidator2.From)
	require.Equal(t, msgApproveValidator.Operator, msgApproveValidator2.Operator)
	require.Equal(t, msgApproveValidator.ValId, msgApproveValidator2.ValId)
	require.Equal(t, msgApproveValidator.Nonce, msgApproveValidator2.Nonce)
	require.True(t, bytes.Equal(msgApproveValidator.SignerPubKey, msgApproveValidator2.SignerPubKey))

	msgValJoin, err := types.NewMsgValidatorJoin(
		pk1.Address().String(),
		uint64(1),
		uint64(1),
		math.NewInt(int64(1000000000000000000)),
		pk1,
		uint64(1),
	)

	require.NoError(t, err)
	msgSerialized, err = cdc.MarshalInterface(msgValJoin)
	require.NoError(t, err)

	err = cdc.UnmarshalInterface(msgSerialized, &msgUnmarshalled)
	require.NoError(t, err)
	msgValJoin2, ok := msgUnmarshalled.(*types.MsgValidatorJoin)
	require.True(t, ok)
	require.Equal(t, msgValJoin.From, msgValJoin2.From)
	require.True(t, bytes.Equal(msgValJoin.SignerPubKey, msgValJoin2.SignerPubKey))
	require.Equal(t, msgValJoin.ActivationEpoch, msgValJoin2.ActivationEpoch)
	require.Equal(t, msgValJoin.ValId, msgValJoin2.ValId)

	msgSignerUpdate, err := types.NewMsgSignerUpdate(
		pk1.Address().String(),
		uint64(1),
		pk1.Bytes(),
		uint64(1),
	)

	require.NoError(t, err)
	msgSerialized, err = cdc.MarshalInterface(msgSignerUpdate)
	require.NoError(t, err)

	err = cdc.UnmarshalInterface(msgSerialized, &msgUnmarshalled)
	require.NoError(t, err)
	msgSignerUpdate2, ok := msgUnmarshalled.(*types.MsgSignerUpdate)
	require.True(t, ok)
	require.Equal(t, msgSignerUpdate.From, msgSignerUpdate2.From)
	require.True(t, bytes.Equal(msgSignerUpdate.NewSignerPubKey, msgSignerUpdate2.NewSignerPubKey))
	require.Equal(t, msgSignerUpdate.ValId, msgSignerUpdate2.ValId)

	msgStakeUpdate, err := types.NewMsgStakeUpdate(
		pk1.Address().String(),
		uint64(1),
		math.NewInt(int64(100000)),
		uint64(1),
	)

	require.NoError(t, err)
	msgSerialized, err = cdc.MarshalInterface(msgStakeUpdate)
	require.NoError(t, err)

	err = cdc.UnmarshalInterface(msgSerialized, &msgUnmarshalled)
	require.NoError(t, err)
	msgStakeUpdate2, ok := msgUnmarshalled.(*types.MsgStakeUpdate)
	require.True(t, ok)
	require.Equal(t, msgStakeUpdate.From, msgStakeUpdate2.From)
	require.Equal(t, msgStakeUpdate.ValId, msgStakeUpdate2.ValId)
	require.Equal(t, msgStakeUpdate.NewAmount, msgStakeUpdate2.NewAmount)

	msgValidatorExit, err := types.NewMsgValidatorExit(
		pk1.Address().String(),
		uint64(1),
		uint64(1),
	)

	require.NoError(t, err)
	msgSerialized, err = cdc.MarshalInterface(msgValidatorExit)
	require.NoError(t, err)

	err = cdc.UnmarshalInterface(msgSerialized, &msgUnmarshalled)
	require.NoError(t, err)
	msgValidatorExit2, ok := msgUnmarshalled.(*types.MsgValidatorExit)
	require.True(t, ok)
	require.Equal(t, msgValidatorExit.From, msgValidatorExit2.From)
	require.Equal(t, msgValidatorExit.ValId, msgValidatorExit2.ValId)
	require.Equal(t, msgValidatorExit.Nonce, msgValidatorExit2.Nonce)

	msgWithdraw := types.NewMsgWithdrawValidatorStake(pk1.Address().String(), uint64(1))
	msgSerialized, err = cdc.MarshalInterface(msgWithdraw)
	require.NoError(t, err)

	err = cdc.UnmarshalInterface(msgSerialized, &msgUnmarshalled)
	require.NoError(t, err)
	msgWithdraw2, ok := msgUnmarshalled.(*types.MsgWithdrawValidatorStake)
	require.True(t, ok)
	require.Equal(t, msgWithdraw.From, msgWithdraw2.From)
	require.Equal(t, msgWithdraw.ValId, msgWithdraw2.ValId)
}

func TestValidatorSignerPublicKeyRejectsInvalidCurvePoint(t *testing.T) {
	t.Parallel()

	pk := secp256k1.GenPrivKey().PubKey()
	invalidPubKey := append([]byte{0x04}, bytes.Repeat([]byte{0xff}, secp256k1.PubKeySize-1)...)

	tests := []struct {
		name string
		msg  interface{ ValidateBasic() error }
	}{
		{
			name: "approval",
			msg: &types.MsgApproveValidator{
				From:            pk.Address().String(),
				ValId:           1,
				Operator:        pk.Address().String(),
				ActivationEpoch: 1,
				MaxGiltStake:    math.NewInt(1000000000000000000),
				SignerPubKey:    invalidPubKey,
				Nonce:           1,
			},
		},
		{
			name: "join",
			msg: &types.MsgValidatorJoin{
				From:            pk.Address().String(),
				ValId:           1,
				ActivationEpoch: 1,
				Amount:          math.NewInt(1000000000000000000),
				SignerPubKey:    invalidPubKey,
				Nonce:           1,
			},
		},
		{
			name: "signer update",
			msg: &types.MsgSignerUpdate{
				From:            pk.Address().String(),
				ValId:           1,
				NewSignerPubKey: invalidPubKey,
				Nonce:           1,
			},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			t.Parallel()

			err := tt.msg.ValidateBasic()
			require.Error(t, err)
			require.Contains(t, err.Error(), "valid secp256k1 public key")
		})
	}
}
