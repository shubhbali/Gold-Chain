package cli

import (
	"context"
	"errors"
	"fmt"

	"cosmossdk.io/log"
	abci "github.com/cometbft/cometbft/abci/types"
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/tx"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/x/auth/ante"
	authsign "github.com/cosmos/cosmos-sdk/x/auth/signing"
	authtypes "github.com/cosmos/cosmos-sdk/x/auth/types"

	"github.com/giltchain/gilt-consensus/bridge/util"
)

const errorFetchingAccount = "error fetching account"

func BroadcastMsg(clientCtx client.Context, sender string, msg sdk.Msg, logger log.Logger) error {
	// create tx factory
	txf, err := MakeTxFactory(clientCtx, sender, logger)
	if err != nil {
		logger.Error("Error creating tx factory", "Error", err)
		return err
	}
	// setting this to true to as the if block in BroadcastTx
	// might cause a canceled transaction.
	clientCtx.SkipConfirm = true
	account, err := util.GetAccount(context.Background(), clientCtx, sender)
	if err != nil {
		logger.Error(errorFetchingAccount, "address", sender, "err", err)
		return err
	}
	clientCtx = clientCtx.WithFromAddress(account.GetAddress())
	from := clientCtx.GetFromAddress()
	authQueryClient := authtypes.NewQueryClient(clientCtx)
	_, err = authQueryClient.Account(context.Background(), &authtypes.QueryAccountRequest{Address: from.String()})
	if err != nil {
		logger.Error(errorFetchingAccount, "Error", err)
		return err
	}

	_, err = txf.AccountRetriever().GetAccount(clientCtx, from)
	if err != nil {
		logger.Error("Error ensuring account exists", "Error", err)
		return err
	}

	txResponse, err := broadcastTxWithFromKey(clientCtx, txf, msg)
	if err != nil {
		logger.Error("Error broadcasting tx", "Error", err)
		return err
	}
	// Now check if the transaction response is not okay
	if txResponse.Code != abci.CodeTypeOK {
		logger.Error("Transaction response returned a non-ok code", "txResponseCode", txResponse.Code, "txResponseLog", txResponse.RawLog)
		return fmt.Errorf("broadcast succeeded but received non-ok response code: %d", txResponse.Code)
	}

	logger.Info(fmt.Sprintf("Tx with hash %s broadcasted successfully.", txResponse.TxHash))

	return nil
}

func broadcastTxWithFromKey(clientCtx client.Context, txf tx.Factory, msg sdk.Msg) (*sdk.TxResponse, error) {
	if clientCtx.Keyring == nil {
		return nil, errors.New("keyring is required for tx signing")
	}
	if clientCtx.FromName == "" {
		return nil, errors.New("from key name is required for tx signing")
	}

	txf, err := txf.Prepare(clientCtx)
	if err != nil {
		return nil, err
	}

	if txf.SimulateAndExecute() || clientCtx.Simulate {
		if clientCtx.Offline {
			return nil, errors.New("cannot estimate gas in offline mode")
		}
		_, adjusted, err := tx.CalculateGas(clientCtx, txf, msg)
		if err != nil {
			return &sdk.TxResponse{Code: 1}, err
		}
		txf = txf.WithGas(adjusted)
	}

	if clientCtx.Simulate {
		return &sdk.TxResponse{Code: abci.CodeTypeOK}, nil
	}

	txBuilder, err := txf.BuildUnsignedTx(msg)
	if err != nil {
		return nil, err
	}

	if !clientCtx.SkipConfirm {
		return nil, errors.New("interactive confirmation is not supported in BroadcastMsg path")
	}

	if err := tx.Sign(clientCtx.CmdContext, txf, clientCtx.FromName, txBuilder, true); err != nil {
		return nil, err
	}

	txBytes, err := clientCtx.TxConfig.TxEncoder()(txBuilder.GetTx())
	if err != nil {
		return nil, err
	}

	res, err := clientCtx.BroadcastTx(txBytes)
	if err != nil {
		return nil, err
	}

	return res, nil
}

func MakeTxFactory(cliCtx client.Context, address string, logger log.Logger) (tx.Factory, error) {
	account, err := util.GetAccount(context.Background(), cliCtx, address)
	if err != nil {
		logger.Error("Error fetching account", "address", address, "err", err)
		return tx.Factory{}, err
	}

	accNum := account.GetAccountNumber()
	accSeq := account.GetSequence()

	signMode, err := authsign.APISignModeToInternal(cliCtx.TxConfig.SignModeHandler().DefaultMode())
	if err != nil {
		logger.Error("Error getting sign mode", "err", err)
		return tx.Factory{}, err
	}

	authParams, err := util.GetAccountParamsURL(cliCtx.Codec)
	if err != nil {
		logger.Error("Error getting account params", "err", err)
		return tx.Factory{}, err
	}

	chainParam, err := util.GetChainmanagerParams(cliCtx.Codec)
	if err != nil {
		return tx.Factory{}, err
	}

	txf := tx.Factory{}.
		WithTxConfig(cliCtx.TxConfig).
		WithAccountRetriever(cliCtx.AccountRetriever).
		WithChainID(chainParam.ChainParams.GiltConsensusChainId).
		WithSignMode(signMode).
		WithAccountNumber(accNum).
		WithSequence(accSeq).
		WithKeybase(cliCtx.Keyring).
		WithFees(ante.DefaultFeeWantedPerTx.String()).
		WithGas(authParams.MaxTxGas)

	return txf, nil
}
