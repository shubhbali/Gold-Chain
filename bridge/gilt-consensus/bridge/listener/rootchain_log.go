package listener

import (
	"bytes"
	"encoding/json"

	"github.com/ethereum/go-ethereum/accounts/abi"
	"github.com/ethereum/go-ethereum/core/types"

	"github.com/giltchain/gilt-consensus/bridge/util"
	"github.com/giltchain/gilt-consensus/contracts/stakinginfo"
	"github.com/giltchain/gilt-consensus/contracts/statesender"
	"github.com/giltchain/gilt-consensus/helper"
)

const (
	failedToMarshalLog    = "RootChainListener: failed to marshal log"
	failedToParseEventLog = "RootChainListener: error while parsing event"
)

// handleLog handles the given log
func (rl *RootChainListener) handleLog(vLog types.Log, selectedEvent *abi.Event) {
	rl.Logger.Debug("RootChainListener: receivedEvent", "eventName", selectedEvent.Name)

	switch selectedEvent.Name {
	case helper.NewHeaderBlockEvent:
		rl.handleNewHeaderBlockLog(vLog, selectedEvent)
	case helper.StakedEvent:
		rl.handleStakedLog(vLog, selectedEvent)
	case helper.StakeUpdateEvent:
		rl.handleStakeUpdateLog(vLog, selectedEvent)
	case helper.SignerChangeEvent:
		rl.handleSignerChangeLog(vLog, selectedEvent)
	case helper.UnstakeInitEvent:
		rl.handleUnstakeInitLog(vLog, selectedEvent)
	case helper.StateSyncedEvent:
		rl.handleStateSyncedLog(vLog, selectedEvent)
	case helper.TopUpFeeEvent:
		rl.handleTopUpFeeLog(vLog, selectedEvent)
	case helper.SlashedEvent:
		rl.handleSlashedLog(vLog, selectedEvent)
	case helper.UnJailedEvent:
		rl.handleUnJailedLog(vLog, selectedEvent)
	}
}

func (rl *RootChainListener) handleNewHeaderBlockLog(vLog types.Log, selectedEvent *abi.Event) {
	logBytes, err := json.Marshal(vLog)
	if err != nil {
		rl.Logger.Error(failedToMarshalLog, "error", err)
	}

	if isCurrentValidator, delay := util.CalculateTaskDelay(selectedEvent, rl.cliCtx.Codec); isCurrentValidator {
		rl.SendTaskWithDelay("sendCheckpointAckToGiltConsensus", selectedEvent.Name, logBytes, delay, selectedEvent)
	}
}

func (rl *RootChainListener) handleStakedLog(vLog types.Log, selectedEvent *abi.Event) {
	logBytes, err := json.Marshal(vLog)
	if err != nil {
		rl.Logger.Error(failedToMarshalLog, "error", err)
	}

	pubKey := helper.GetPubKey()

	event := new(stakinginfo.StakinginfoStaked)
	if err = helper.UnpackLog(rl.stakingInfoAbi, event, selectedEvent.Name, &vLog); err != nil {
		rl.Logger.Error(failedToParseEventLog, "name", selectedEvent.Name, "error", err)
	}

	if len(pubKey) < 1 {
		rl.Logger.Error("RootChainListener: public key length is invalid", "length", len(pubKey))
		return
	}

	if !helper.IsPubKeyFirstByteValid(pubKey[0:1]) {
		rl.Logger.Error("RootChainListener: public key first byte mismatch", "expected", "0x04", "received", pubKey[0:1])
	}

	if bytes.Equal(event.SignerPubkey, pubKey[1:]) {
		delay := util.TaskDelayBetweenEachVal
		rl.SendTaskWithDelay("sendValidatorJoinToGiltConsensus", selectedEvent.Name, logBytes, delay, event)
	} else if isCurrentValidator, delay := util.CalculateTaskDelay(event, rl.cliCtx.Codec); isCurrentValidator {
		delay = delay + util.TaskDelayBetweenEachVal
		rl.SendTaskWithDelay("sendValidatorJoinToGiltConsensus", selectedEvent.Name, logBytes, delay, event)
	}
}

func (rl *RootChainListener) handleStakeUpdateLog(vLog types.Log, selectedEvent *abi.Event) {
	logBytes, err := json.Marshal(vLog)
	if err != nil {
		rl.Logger.Error(failedToMarshalLog, "Error", err)
	}

	event := new(stakinginfo.StakinginfoStakeUpdate)
	if err = helper.UnpackLog(rl.stakingInfoAbi, event, selectedEvent.Name, &vLog); err != nil {
		rl.Logger.Error(failedToParseEventLog, "name", selectedEvent.Name, "error", err)
	}

	if util.IsEventSender(event.ValidatorId.Uint64(), rl.cliCtx.Codec) {
		rl.SendTaskWithDelay("sendStakeUpdateToGiltConsensus", selectedEvent.Name, logBytes, 0, event)
	} else if isCurrentValidator, delay := util.CalculateTaskDelay(event, rl.cliCtx.Codec); isCurrentValidator {
		rl.SendTaskWithDelay("sendStakeUpdateToGiltConsensus", selectedEvent.Name, logBytes, delay, event)
	}
}

func (rl *RootChainListener) handleSignerChangeLog(vLog types.Log, selectedEvent *abi.Event) {
	logBytes, err := json.Marshal(vLog)
	if err != nil {
		rl.Logger.Error(failedToMarshalLog, "Error", err)
	}

	pubKey := helper.GetPubKey()

	event := new(stakinginfo.StakinginfoSignerChange)
	if err = helper.UnpackLog(rl.stakingInfoAbi, event, selectedEvent.Name, &vLog); err != nil {
		rl.Logger.Error(failedToParseEventLog, "name", selectedEvent.Name, "error", err)
	}

	if bytes.Equal(event.SignerPubkey, pubKey[1:]) && helper.IsPubKeyFirstByteValid(pubKey[0:1]) {
		rl.SendTaskWithDelay("sendSignerChangeToGiltConsensus", selectedEvent.Name, logBytes, 0, event)
	} else if isCurrentValidator, delay := util.CalculateTaskDelay(event, rl.cliCtx.Codec); isCurrentValidator {
		rl.SendTaskWithDelay("sendSignerChangeToGiltConsensus", selectedEvent.Name, logBytes, delay, event)
	}
}

func (rl *RootChainListener) handleUnstakeInitLog(vLog types.Log, selectedEvent *abi.Event) {
	logBytes, err := json.Marshal(vLog)
	if err != nil {
		rl.Logger.Error(failedToMarshalLog, "Error", err)
	}

	event := new(stakinginfo.StakinginfoUnstakeInit)
	if err = helper.UnpackLog(rl.stakingInfoAbi, event, selectedEvent.Name, &vLog); err != nil {
		rl.Logger.Error(failedToParseEventLog, "name", selectedEvent.Name, "error", err)
	}

	if util.IsEventSender(event.ValidatorId.Uint64(), rl.cliCtx.Codec) {
		rl.SendTaskWithDelay("sendUnstakeInitToGiltConsensus", selectedEvent.Name, logBytes, 0, event)
	} else if isCurrentValidator, delay := util.CalculateTaskDelay(event, rl.cliCtx.Codec); isCurrentValidator {
		rl.SendTaskWithDelay("sendUnstakeInitToGiltConsensus", selectedEvent.Name, logBytes, delay, event)
	}
}

func (rl *RootChainListener) handleStateSyncedLog(vLog types.Log, selectedEvent *abi.Event) {
	logBytes, err := json.Marshal(vLog)
	if err != nil {
		rl.Logger.Error(failedToMarshalLog, "Error", err)
	}

	event := new(statesender.StatesenderStateSynced)
	if err = helper.UnpackLog(rl.stateSenderAbi, event, selectedEvent.Name, &vLog); err != nil {
		rl.Logger.Error(failedToParseEventLog, "name", selectedEvent.Name, "error", err)
	}

	rl.Logger.Info("RootChainListener: StateSyncedEvent detected", "stateSyncId", event.Id)

	if isCurrentValidator, delay := util.CalculateTaskDelay(event, rl.cliCtx.Codec); isCurrentValidator {
		rl.SendTaskWithDelay("sendStateSyncedToGiltConsensus", selectedEvent.Name, logBytes, delay, event)
	}
}

func (rl *RootChainListener) handleTopUpFeeLog(vLog types.Log, selectedEvent *abi.Event) {
	logBytes, err := json.Marshal(vLog)
	if err != nil {
		rl.Logger.Error(failedToMarshalLog, "Error", err)
	}

	event := new(stakinginfo.StakinginfoTopUpFee)
	if err = helper.UnpackLog(rl.stakingInfoAbi, event, selectedEvent.Name, &vLog); err != nil {
		rl.Logger.Error("RootChainListener: error while parsing event", "name", selectedEvent.Name, "error", err)
	}

	if bytes.Equal(event.User.Bytes(), helper.GetAddress()) {
		rl.SendTaskWithDelay("sendTopUpFeeToGiltConsensus", selectedEvent.Name, logBytes, 0, event)
	} else if isCurrentValidator, delay := util.CalculateTaskDelay(event, rl.cliCtx.Codec); isCurrentValidator {
		rl.SendTaskWithDelay("sendTopUpFeeToGiltConsensus", selectedEvent.Name, logBytes, delay, event)
	}
}

func (rl *RootChainListener) handleSlashedLog(vLog types.Log, selectedEvent *abi.Event) {
	logBytes, err := json.Marshal(vLog)
	if err != nil {
		rl.Logger.Error(failedToMarshalLog, "Error", err)
	}

	if isCurrentValidator, delay := util.CalculateTaskDelay(selectedEvent, rl.cliCtx.Codec); isCurrentValidator {
		rl.SendTaskWithDelay("sendTickAckToGiltConsensus", selectedEvent.Name, logBytes, delay, selectedEvent)
	}
}

func (rl *RootChainListener) handleUnJailedLog(vLog types.Log, selectedEvent *abi.Event) {
	logBytes, err := json.Marshal(vLog)
	if err != nil {
		rl.Logger.Error(failedToMarshalLog, "Error", err)
	}

	event := new(stakinginfo.StakinginfoUnJailed)
	if err = helper.UnpackLog(rl.stakingInfoAbi, event, selectedEvent.Name, &vLog); err != nil {
		rl.Logger.Error("RootChainListener: error while parsing event", "name", selectedEvent.Name, "error", err)
	}

	if util.IsEventSender(event.ValidatorId.Uint64(), rl.cliCtx.Codec) {
		rl.SendTaskWithDelay("sendUnjailToGiltConsensus", selectedEvent.Name, logBytes, 0, event)
	} else if isCurrentValidator, delay := util.CalculateTaskDelay(event, rl.cliCtx.Codec); isCurrentValidator {
		rl.SendTaskWithDelay("sendUnjailToGiltConsensus", selectedEvent.Name, logBytes, delay, event)
	}
}
