package keeper

import (
	"bytes"
	"encoding/hex"
	"errors"
	"strconv"
	"time"

	"github.com/cosmos/cosmos-sdk/codec/address"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/ethereum/go-ethereum/common"

	"github.com/giltchain/gilt-consensus/helper"
	"github.com/giltchain/gilt-consensus/metrics/api"
	"github.com/giltchain/gilt-consensus/sidetxs"
	giltconsensusTypes "github.com/giltchain/gilt-consensus/types"
	"github.com/giltchain/gilt-consensus/x/clerk/types"
)

type sideMsgServer struct {
	Keeper
}

var msgEventRecord = sdk.MsgTypeURL(&types.MsgEventRecord{})

// NewSideMsgServerImpl returns an implementation of the clerk SideMsgServer interface
// for the provided Keeper.
func NewSideMsgServerImpl(keeper Keeper) sidetxs.SideMsgServer {
	return &sideMsgServer{Keeper: keeper}
}

// SideTxHandler returns a side handler for clerk type messages.
func (srv *sideMsgServer) SideTxHandler(methodName string) sidetxs.SideTxHandler {
	switch methodName {
	case msgEventRecord:
		return srv.SideHandleMsgEventRecord
	default:
		return nil
	}
}

// PostTxHandler returns a post-handler for clerk type messages.
func (srv *sideMsgServer) PostTxHandler(methodName string) sidetxs.PostTxHandler {
	switch methodName {
	case msgEventRecord:
		return srv.PostHandleMsgEventRecord
	default:
		return nil
	}
}

func (srv *sideMsgServer) SideHandleMsgEventRecord(ctx sdk.Context, m sdk.Msg) (result sidetxs.Vote) {
	var err error
	startTime := time.Now()
	defer recordClerkMetric(api.SideHandleMsgEventRecordMethod, api.SideType, startTime, &err)

	msg, ok := m.(*types.MsgEventRecord)
	if !ok {
		srv.Logger(ctx).Error(helper.ErrTypeMismatch("MsgEventRecord"))
		return sidetxs.Vote_VOTE_NO
	}

	srv.Logger(ctx).Debug(helper.LogValidatingExternalCall("ClerkEventRecord"),
		"txHash", msg.TxHash,
		"logIndex", msg.LogIndex,
		"blockNumber", msg.BlockNumber,
	)

	// check if the event record exists
	if exists := srv.HasEventRecord(ctx, msg.Id); exists {
		srv.Logger(ctx).Info("Msg event record already present in clerk side handler, voting NO")
		return sidetxs.Vote_VOTE_NO
	}

	// chainManager params
	params, err := srv.ChainKeeper.GetParams(ctx)
	if err != nil {
		srv.Logger(ctx).Error(giltconsensusTypes.ErrMsgFailedToGetChainManagerParams, giltconsensusTypes.LogKeyError, err)
		return sidetxs.Vote_VOTE_NO
	}

	chainParams := params.ChainParams

	// check chain id
	if !helper.ValidateChainID(msg.ChainId, chainParams.GiltChainId, srv.Logger(ctx), "clerk") {
		return sidetxs.Vote_VOTE_NO
	}

	// sequence id
	sequence := helper.CalculateSequence(msg.BlockNumber, msg.LogIndex)

	// check if the event has already been processed
	if srv.HasRecordSequence(ctx, sequence) {
		srv.Logger(ctx).Error(helper.LogEventAlreadyProcessedIn("clerk"), giltconsensusTypes.LogKeySequence, sequence)
		return sidetxs.Vote_VOTE_NO
	}

	// get and validate confirmed tx receipt
	receipt := helper.FetchAndValidateReceipt(
		srv.contractCaller,
		helper.ReceiptValidationParams{
			TxHash:         common.HexToHash(msg.TxHash).Bytes(),
			MsgBlockNumber: msg.BlockNumber,
			Confirmations:  params.GetMainChainTxConfirmations(),
			ModuleName:     "clerk",
		},
		srv.Logger(ctx),
	)
	if receipt == nil {
		return sidetxs.Vote_VOTE_NO
	}

	// get event log for clerk
	eventLog, err := srv.contractCaller.DecodeStateSyncedEvent(chainParams.StateSenderAddress, receipt, msg.LogIndex)
	if err != nil || eventLog == nil {
		srv.Logger(ctx).Error(giltconsensusTypes.ErrMsgErrorFetchingLog)
		return sidetxs.Vote_VOTE_NO
	}

	// check if the message and the event log match
	if eventLog.Id.Uint64() != msg.Id {
		srv.Logger(ctx).Error(giltconsensusTypes.ErrMsgIDMismatch, giltconsensusTypes.LogKeyMsgID, msg.Id, "stateIdFromTx", eventLog.Id)
		return sidetxs.Vote_VOTE_NO
	}

	ac := address.NewHexCodec()
	msgContractAddrBytes, err := ac.StringToBytes(msg.ContractAddress)
	if err != nil {
		srv.Logger(ctx).Error(
			"Could not generate bytes from msg contract address",
			"MsgContractAddress", msg.ContractAddress,
		)
		return sidetxs.Vote_VOTE_NO
	}
	eventLogContractAddrBytes, err := ac.StringToBytes(eventLog.ContractAddress.String())
	if err != nil {
		srv.Logger(ctx).Error(
			"Could not generate bytes from event logs contract address",
			"EventContractAddress", eventLog.ContractAddress.String(),
		)
		return sidetxs.Vote_VOTE_NO
	}

	if !bytes.Equal(eventLogContractAddrBytes, msgContractAddrBytes) {
		srv.Logger(ctx).Error(
			"ContractAddress from event does not match with Msg ContractAddress",
			"EventContractAddress", eventLog.ContractAddress.String(),
			"MsgContractAddress", msg.ContractAddress,
		)

		return sidetxs.Vote_VOTE_NO
	}

	if !bytes.Equal(eventLog.Data, msg.Data) {
		if !(len(eventLog.Data) > helper.MaxStateSyncSize && bytes.Equal(msg.Data, []byte(""))) {
			srv.Logger(ctx).Error(
				"Data from event does not match with Msg Data",
				"EventData", hex.EncodeToString(eventLog.Data),
				"MsgData", string(msg.Data),
			)

			return sidetxs.Vote_VOTE_NO
		}
	}

	return sidetxs.Vote_VOTE_YES
}

func (srv *sideMsgServer) PostHandleMsgEventRecord(ctx sdk.Context, m sdk.Msg, sideTxResult sidetxs.Vote) error {
	var err error
	startTime := time.Now()
	defer recordClerkMetric(api.PostHandleMsgEventRecordMethod, api.PostType, startTime, &err)

	logger := srv.Logger(ctx)

	msg, ok := m.(*types.MsgEventRecord)
	if !ok {
		err := errors.New(helper.ErrTypeMismatch("MsgEventRecord"))
		logger.Error(err.Error())
	}

	// Ensure canonical lifecycle exists even if side-tx vote is rejected.
	if err := srv.EnsureBridgeLifecyclePending(
		ctx,
		msg.ChainId,
		msg.TxHash,
		msg.LogIndex,
		msg.Id,
		ctx.BlockTime(),
	); err != nil {
		logger.Error("failed to initialize canonical bridge lifecycle", "error", err)
		return err
	}

	// Skip handler if clerk is not approved
	if !helper.IsSideTxApproved(sideTxResult) {
		logger.Debug(helper.ErrSkippingMsg("ClerkEventRecord"))
		if err := srv.SetBridgeLifecycleState(
			ctx,
			msg.ChainId,
			msg.TxHash,
			msg.LogIndex,
			msg.Id,
			types.BridgeLifecycleFailedRetryable,
			"side-tx vote rejected",
			ctx.BlockTime(),
		); err != nil {
			logger.Debug("unable to move lifecycle to failed_retryable", "error", err)
		}
		return nil
	}

	// check for replay
	if srv.HasEventRecord(ctx, msg.Id) {
		logger.Debug("Skipping new clerk record as it's already processed")
		return errors.New("clerk record already processed")
	}

	if err := srv.SetBridgeLifecycleState(
		ctx,
		msg.ChainId,
		msg.TxHash,
		msg.LogIndex,
		msg.Id,
		types.BridgeLifecycleConfirmed,
		"",
		ctx.BlockTime(),
	); err != nil {
		logger.Error("failed to persist canonical bridge lifecycle confirmed state", "error", err)
		return err
	}
	if err := srv.SetBridgeLifecycleState(
		ctx,
		msg.ChainId,
		msg.TxHash,
		msg.LogIndex,
		msg.Id,
		types.BridgeLifecycleFinalizedAction,
		"",
		ctx.BlockTime(),
	); err != nil {
		logger.Error("failed to persist canonical bridge lifecycle finalized_actionable state", "error", err)
		return err
	}
	if err := srv.SetBridgeLifecycleState(
		ctx,
		msg.ChainId,
		msg.TxHash,
		msg.LogIndex,
		msg.Id,
		types.BridgeLifecycleSubmitted,
		"",
		ctx.BlockTime(),
	); err != nil {
		logger.Error("failed to persist canonical bridge lifecycle submitted state", "error", err)
		return err
	}

	logger.Debug("Persisting clerk state", "sideTxResult", sideTxResult)

	// sequence id
	sequence := helper.CalculateSequence(msg.BlockNumber, msg.LogIndex)

	// create the event record
	record := types.NewEventRecord(
		msg.TxHash,
		msg.LogIndex,
		msg.Id,
		msg.ContractAddress,
		msg.Data,
		msg.ChainId,
		ctx.BlockTime(),
	)

	// save event into state
	if err := srv.SetEventRecord(ctx, record); err != nil {
		logger.Error("Unable to update event record", "id", msg.Id, giltconsensusTypes.LogKeyError, err)
		_ = srv.SetBridgeLifecycleState(
			ctx,
			msg.ChainId,
			msg.TxHash,
			msg.LogIndex,
			msg.Id,
			types.BridgeLifecycleFailedRetryable,
			"failed to persist event record",
			ctx.BlockTime(),
		)
		return err
	}

	// save the record sequence
	srv.SetRecordSequence(ctx, sequence)

	if err := srv.SetBridgeLifecycleState(
		ctx,
		msg.ChainId,
		msg.TxHash,
		msg.LogIndex,
		msg.Id,
		types.BridgeLifecycleCompleted,
		"",
		ctx.BlockTime(),
	); err != nil {
		logger.Error("failed to persist canonical bridge lifecycle completed state", "error", err)
		return err
	}

	// tx bytes
	txBytes := ctx.TxBytes()
	hash := txBytes

	// add events
	ctx.EventManager().EmitEvents(sdk.Events{
		sdk.NewEvent(
			types.EventTypeRecord,
			sdk.NewAttribute(sdk.AttributeKeyAction, msg.Type()),                            // action
			sdk.NewAttribute(sdk.AttributeKeyModule, types.AttributeValueCategory),          // module name
			sdk.NewAttribute(giltconsensusTypes.AttributeKeyTxHash, common.Bytes2Hex(hash)), // tx hash
			sdk.NewAttribute(types.AttributeKeyRecordTxLogIndex, strconv.FormatUint(msg.LogIndex, 10)),
			sdk.NewAttribute(giltconsensusTypes.AttributeKeySideTxResult, sideTxResult.String()), // result
			sdk.NewAttribute(types.AttributeKeyRecordID, strconv.FormatUint(msg.Id, 10)),
			sdk.NewAttribute(types.AttributeKeyRecordContract, msg.ContractAddress),
		),
	})

	return nil
}

// recordClerkMetric records metrics for side and post-handlers.
func recordClerkMetric(method string, apiType string, start time.Time, err *error) {
	success := *err == nil
	api.RecordAPICallWithStart(api.ClerkSubsystem, method, apiType, success, start)
}
