package span

import (
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/consensus/gilt/valset"

	stakeTypes "github.com/giltchain/gilt-consensus/x/stake/types"
)

func ConvertGiltConsensusValSetToGiltValSet(giltconsensusValSet stakeTypes.ValidatorSet) valset.ValidatorSet {
	validators := make([]*valset.Validator, len(giltconsensusValSet.Validators))
	for i, v := range giltconsensusValSet.Validators {
		validators[i] = &valset.Validator{
			ID:               v.ValId,
			Address:          common.HexToAddress(v.Signer),
			VotingPower:      v.VotingPower,
			ProposerPriority: v.ProposerPriority,
		}
	}

	resValSet := valset.ValidatorSet{
		Validators: validators,
	}

	if giltconsensusValSet.Proposer != nil {
		resValSet.Proposer = &valset.Validator{
			ID:               giltconsensusValSet.Proposer.ValId,
			Address:          common.HexToAddress(giltconsensusValSet.Proposer.Signer),
			VotingPower:      giltconsensusValSet.Proposer.VotingPower,
			ProposerPriority: giltconsensusValSet.Proposer.ProposerPriority,
		}
	}

	resValSet.UpdateTotalVotingPower()
	resValSet.UpdateValidatorMap()

	return resValSet
}

func ConvertGiltValSetToGiltConsensusValSet(giltValSet *valset.ValidatorSet) stakeTypes.ValidatorSet {
	validators := make([]*stakeTypes.Validator, len(giltValSet.Validators))
	for i, v := range giltValSet.Validators {
		validators[i] = &stakeTypes.Validator{
			ValId:            v.ID,
			Signer:           v.Address.Hex(),
			VotingPower:      v.VotingPower,
			ProposerPriority: v.ProposerPriority,
		}
	}

	proposer := &stakeTypes.Validator{
		ValId:            giltValSet.Proposer.ID,
		Signer:           giltValSet.Proposer.Address.Hex(),
		VotingPower:      giltValSet.Proposer.VotingPower,
		ProposerPriority: giltValSet.Proposer.ProposerPriority,
	}

	return stakeTypes.ValidatorSet{
		Validators: validators,
		Proposer:   proposer,
	}
}

func ConvertGiltValidatorsToGiltConsensusValidators(giltValidators []*valset.Validator) []stakeTypes.Validator {
	validators := make([]stakeTypes.Validator, len(giltValidators))
	for i, v := range giltValidators {
		validators[i] = stakeTypes.Validator{
			ValId:            v.ID,
			Signer:           v.Address.Hex(),
			VotingPower:      v.VotingPower,
			ProposerPriority: v.ProposerPriority,
		}
	}
	return validators
}

func ConvertGiltConsensusValidatorsToGiltValidators(giltconsensusValidators []stakeTypes.Validator) []valset.Validator {
	validators := make([]valset.Validator, len(giltconsensusValidators))
	for i, v := range giltconsensusValidators {
		validators[i] = valset.Validator{
			ID:               v.ValId,
			Address:          common.HexToAddress(v.Signer),
			VotingPower:      v.VotingPower,
			ProposerPriority: v.ProposerPriority,
		}
	}
	return validators
}

func ConvertGiltConsensusValidatorsToGiltValidatorsByRef(giltconsensusValidators []*stakeTypes.Validator) []*valset.Validator {
	validators := make([]*valset.Validator, len(giltconsensusValidators))
	for i, v := range giltconsensusValidators {
		validators[i] = &valset.Validator{
			ID:               v.ValId,
			Address:          common.HexToAddress(v.Signer),
			VotingPower:      v.VotingPower,
			ProposerPriority: v.ProposerPriority,
		}
	}
	return validators
}
