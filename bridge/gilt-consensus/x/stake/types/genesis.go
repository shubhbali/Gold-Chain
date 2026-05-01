package types

import (
	"bytes"
	"encoding/json"
	"errors"
	"fmt"
	"sort"

	sdkmath "cosmossdk.io/math"
	"github.com/cosmos/cosmos-sdk/codec"

	util "github.com/giltchain/gilt-consensus/common/hex"
	pricefeedtypes "github.com/giltchain/gilt-consensus/x/pricefeed/types"
)

const (
	DefaultMinActiveValidators      = uint64(4)
	DefaultMaxValidatorPowerBps     = uint64(3333)
	DefaultValidatorUnbondingEpochs = uint64(2)
)

// NewGenesisState creates a new GenesisState instance
func NewGenesisState(validators []*Validator,
	currentValSet ValidatorSet,
	stakingSequences []string,
) *GenesisState {
	return &GenesisState{
		Validators:               validators,
		CurrentValidatorSet:      currentValSet,
		StakingSequences:         stakingSequences,
		ValidatorLifecycleParams: DefaultValidatorLifecycleParams(),
	}
}

// DefaultGenesisState gets the raw genesis message for testing
func DefaultGenesisState() *GenesisState {
	return &GenesisState{
		ValidatorLifecycleParams: DefaultValidatorLifecycleParams(),
	}
}

// DefaultValidatorLifecycleParams returns production-safe native validator defaults.
func DefaultValidatorLifecycleParams() ValidatorLifecycleParams {
	return ValidatorLifecycleParams{
		MinActiveValidators:      DefaultMinActiveValidators,
		MaxValidatorPowerBps:     DefaultMaxValidatorPowerBps,
		ValidatorUnbondingEpochs: DefaultValidatorUnbondingEpochs,
	}
}

// GetGenesisStateFromAppState returns x/stake GenesisState given raw application
// genesis state.
func GetGenesisStateFromAppState(cdc codec.JSONCodec, appState map[string]json.RawMessage) *GenesisState {
	var genesisState GenesisState

	if appState[ModuleName] != nil {
		cdc.MustUnmarshalJSON(appState[ModuleName], &genesisState)
	}

	return &genesisState
}

// SetGenesisStateToAppState sets x/stake GenesisState into the raw application
// genesis state.
func SetGenesisStateToAppState(cdc codec.JSONCodec, appState map[string]json.RawMessage, validators []*Validator, currentValSet ValidatorSet) (map[string]json.RawMessage, error) {
	stakeState := GetGenesisStateFromAppState(cdc, appState)
	normalizeGenesisValidators(validators)
	currentValSet.NormalizeRewardAccounting()

	stakeState.Validators = validators
	stakeState.CurrentValidatorSet = currentValSet
	stakeState.ValidatorLifecycleParams = completeGenesisLifecycleParams(stakeState.ValidatorLifecycleParams, validators, currentValSet)
	stakeState.ValidatorApprovals = completeGenesisValidatorApprovals(stakeState.ValidatorApprovals, validators, currentValSet)

	if err := stakeState.Validate(); err != nil {
		return nil, err
	}

	appState[ModuleName] = cdc.MustMarshalJSON(stakeState)

	return appState, nil
}

// Validate validates the provided stake genesis state to ensure that listed
// validators and staking sequences are valid
func (data GenesisState) Validate() error {
	for _, validator := range data.Validators {
		if err := validator.ValidateBasic(); err != nil {
			return errors.New("invalid validator")
		}
	}
	if err := validateUniqueGenesisValidatorIDs("validator", data.Validators); err != nil {
		return err
	}

	for _, sq := range data.StakingSequences {
		if sq == "" {
			return errors.New("invalid sequence")
		}
	}
	valIDs := make(map[uint64]struct{})
	for _, validator := range data.Validators {
		valIDs[validator.ValId] = struct{}{}
	}
	for _, validator := range data.CurrentValidatorSet.Validators {
		if validator != nil {
			if err := validator.ValidateBasic(); err != nil {
				return errors.New("invalid current validator")
			}
			valIDs[validator.ValId] = struct{}{}
		}
	}
	if err := validateUniqueGenesisValidatorIDs("current validator", data.CurrentValidatorSet.Validators); err != nil {
		return err
	}

	params := data.ValidatorLifecycleParams
	params.NormalizeDefaults()
	if err := params.ValidateBasic(); err != nil {
		return fmt.Errorf("invalid validator lifecycle params: %w", err)
	}
	if err := validateGenesisValidatorSafety(data.Validators, data.CurrentValidatorSet, params); err != nil {
		return err
	}

	approvals := make(map[uint64]ValidatorApproval, len(data.ValidatorApprovals))
	for _, approval := range data.ValidatorApprovals {
		if err := approval.ValidateBasic(); err != nil {
			return fmt.Errorf("invalid validator approval: %w", err)
		}
		if _, ok := approvals[approval.ValId]; ok {
			return fmt.Errorf("duplicate validator approval for validator %d", approval.ValId)
		}
		approval.Normalize()
		approvals[approval.ValId] = approval
	}
	activeValidators := activeGenesisValidators(data.Validators, data.CurrentValidatorSet)
	if err := validateUniqueActiveGenesisOperators(activeValidators); err != nil {
		return err
	}
	if err := validateGenesisValidatorApprovals(activeValidators, approvals); err != nil {
		return err
	}

	delegations := make(map[string]struct{}, len(data.GoldDelegations))
	for _, delegation := range data.GoldDelegations {
		if err := delegation.ValidateBasic(); err != nil {
			return fmt.Errorf("invalid GOLD delegation: %w", err)
		}
		if _, ok := valIDs[delegation.ValId]; !ok {
			return fmt.Errorf("GOLD delegation references missing validator %d", delegation.ValId)
		}
		key := util.FormatAddress(delegation.Delegator) + "/" + fmt.Sprint(delegation.ValId)
		if _, ok := delegations[key]; ok {
			return fmt.Errorf("duplicate GOLD delegation for validator %d and delegator %s", delegation.ValId, delegation.Delegator)
		}
		delegations[key] = struct{}{}
	}

	return nil
}

func validateUniqueGenesisValidatorIDs(label string, validators []*Validator) error {
	seen := make(map[uint64]struct{}, len(validators))
	for _, validator := range validators {
		if validator == nil {
			continue
		}
		if _, ok := seen[validator.ValId]; ok {
			return fmt.Errorf("duplicate %s id %d", label, validator.ValId)
		}
		seen[validator.ValId] = struct{}{}
	}
	return nil
}

// NormalizeDefaults applies defaults to missing lifecycle params for fresh genesis.
func (p *ValidatorLifecycleParams) NormalizeDefaults() {
	if p.MinActiveValidators == 0 {
		p.MinActiveValidators = DefaultMinActiveValidators
	}
	if p.MaxValidatorPowerBps == 0 {
		p.MaxValidatorPowerBps = DefaultMaxValidatorPowerBps
	}
	if p.ValidatorUnbondingEpochs == 0 {
		p.ValidatorUnbondingEpochs = DefaultValidatorUnbondingEpochs
	}
	if p.ApprovalAuthority != "" {
		p.ApprovalAuthority = util.FormatAddress(p.ApprovalAuthority)
	}
}

// ValidateBasic validates native validator safety params.
func (p ValidatorLifecycleParams) ValidateBasic() error {
	p.NormalizeDefaults()
	if p.ApprovalAuthority != "" {
		if err := validateAccountAddress(p.ApprovalAuthority); err != nil {
			return err
		}
	}
	if p.MinActiveValidators < 4 {
		return fmt.Errorf("minimum active validators must be at least 4")
	}
	if p.MaxValidatorPowerBps == 0 || p.MaxValidatorPowerBps > DefaultMaxValidatorPowerBps {
		return fmt.Errorf("max validator power must be between 1 and %d bps", DefaultMaxValidatorPowerBps)
	}
	if p.ValidatorUnbondingEpochs == 0 {
		return fmt.Errorf("validator unbonding epochs must be positive")
	}
	return nil
}

func validateGenesisValidatorSafety(validators []*Validator, currentValSet ValidatorSet, params ValidatorLifecycleParams) error {
	active := validators
	if len(currentValSet.Validators) > 0 {
		active = currentValSet.Validators
	}
	if len(active) == 0 {
		return nil
	}

	activeCount := uint64(0)
	totalPower := int64(0)
	for _, validator := range active {
		if validator == nil || validator.Jailed || validator.VotingPower <= 0 {
			continue
		}
		activeCount++
		totalPower += validator.VotingPower
	}
	if activeCount < params.MinActiveValidators {
		return fmt.Errorf("active validator count %d is below minimum %d", activeCount, params.MinActiveValidators)
	}
	if totalPower <= 0 {
		return fmt.Errorf("active validator total power must be positive")
	}
	for _, validator := range active {
		if validator == nil || validator.Jailed || validator.VotingPower <= 0 {
			continue
		}
		if uint64(validator.VotingPower)*10000 > uint64(totalPower)*params.MaxValidatorPowerBps {
			return fmt.Errorf("validator %d exceeds max voting power cap", validator.ValId)
		}
	}
	return nil
}

func activeGenesisValidators(validators []*Validator, currentValSet ValidatorSet) []*Validator {
	active := validators
	if len(currentValSet.Validators) > 0 {
		active = currentValSet.Validators
	}

	result := make([]*Validator, 0, len(active))
	for _, validator := range active {
		if validator == nil || validator.Jailed || validator.VotingPower <= 0 {
			continue
		}
		validator.NormalizeLifecycleAccounting()
		result = append(result, validator)
	}
	return result
}

func validateUniqueActiveGenesisOperators(active []*Validator) error {
	seen := make(map[string]uint64, len(active))
	for _, validator := range active {
		if validator == nil {
			continue
		}

		operator := validator.OperatorAddress()
		if existingValID, ok := seen[operator]; ok && existingValID != validator.ValId {
			return fmt.Errorf("active validator operator %s is duplicated across validator %d and %d", operator, existingValID, validator.ValId)
		}
		seen[operator] = validator.ValId
	}
	return nil
}

func validateGenesisValidatorApprovals(active []*Validator, approvals map[uint64]ValidatorApproval) error {
	for _, validator := range active {
		approval, ok := approvals[validator.ValId]
		if !ok {
			return fmt.Errorf("active validator %d is missing native approval", validator.ValId)
		}
		if util.FormatAddress(approval.Operator) != validator.OperatorAddress() {
			return fmt.Errorf("approval operator does not match active validator %d", validator.ValId)
		}
		if approval.ActivationEpoch != validator.StartEpoch {
			return fmt.Errorf("approval activation epoch does not match active validator %d", validator.ValId)
		}
		if !bytes.Equal(approval.SignerPubKey, validator.PubKey) {
			return fmt.Errorf("approval signer public key does not match active validator %d", validator.ValId)
		}
		if validator.SelfGiltStake.GT(approval.MaxGiltStake) {
			return fmt.Errorf("active validator %d self-staked GILT exceeds approval cap", validator.ValId)
		}
	}
	return nil
}

func normalizeGenesisValidators(validators []*Validator) {
	for _, validator := range validators {
		if validator != nil {
			validator.NormalizeLifecycleAccounting()
		}
	}
}

func completeGenesisLifecycleParams(params ValidatorLifecycleParams, _ []*Validator, _ ValidatorSet) ValidatorLifecycleParams {
	params.NormalizeDefaults()
	return params
}

func completeGenesisValidatorApprovals(existing []ValidatorApproval, validators []*Validator, currentValSet ValidatorSet) []ValidatorApproval {
	approvalsByID := make(map[uint64]ValidatorApproval, len(existing)+len(validators)+len(currentValSet.Validators))
	for _, approval := range existing {
		approval.Normalize()
		approvalsByID[approval.ValId] = approval
	}

	if len(currentValSet.Validators) > 0 {
		for _, validator := range currentValSet.Validators {
			addGenesisValidatorApproval(approvalsByID, validator)
		}
		for _, validator := range validators {
			addGenesisValidatorApproval(approvalsByID, validator)
		}
	} else {
		for _, validator := range validators {
			addGenesisValidatorApproval(approvalsByID, validator)
		}
	}

	approvals := make([]ValidatorApproval, 0, len(approvalsByID))
	for _, approval := range approvalsByID {
		approvals = append(approvals, approval)
	}
	sort.Slice(approvals, func(i, j int) bool {
		return approvals[i].ValId < approvals[j].ValId
	})
	return approvals
}

func addGenesisValidatorApproval(approvals map[uint64]ValidatorApproval, validator *Validator) {
	if validator == nil || validator.ValId == 0 {
		return
	}
	if _, ok := approvals[validator.ValId]; ok {
		return
	}

	validator.NormalizeLifecycleAccounting()
	maxGiltStake := validator.SelfGiltStake
	if !maxGiltStake.IsPositive() && validator.VotingPower > 0 {
		maxGiltStake = sdkmath.NewInt(validator.VotingPower).MulRaw(pricefeedtypes.PriceScale)
	}
	if !maxGiltStake.IsPositive() {
		return
	}

	approvals[validator.ValId] = ValidatorApproval{
		ValId:           validator.ValId,
		Operator:        validator.OperatorAddress(),
		ActivationEpoch: validator.StartEpoch,
		MaxGiltStake:    maxGiltStake,
		SignerPubKey:    append([]byte(nil), validator.PubKey...),
		Nonce:           validator.Nonce,
	}
}
