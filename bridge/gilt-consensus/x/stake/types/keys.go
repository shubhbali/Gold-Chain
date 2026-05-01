package types

import (
	"github.com/cosmos/cosmos-sdk/crypto/keys/secp256k1"
)

const (
	// ModuleName is the name of the staking module
	ModuleName = "stake"

	// StoreKey is the string store representation
	StoreKey = ModuleName

	// RouterKey is the msg router key for the stake module
	RouterKey = ModuleName

	// DefaultLogIndexUnit represents the default unit for txHash+logIndex
	DefaultLogIndexUnit = 100000

	// GoldDenom is the native GOLD bank denom escrowed for validator reward staking.
	GoldDenom = "gold"

	// GiltDenom is the native GILT bank denom escrowed for validator self-stake.
	GiltDenom = "gilt"
)

var (
	ValidatorsKey                   = []byte{0x21} // prefix for each key to a validator
	ValidatorSetKey                 = []byte{0x22} // prefix for each key for the validator map
	CurrentValidatorSetKey          = []byte{0x23} // key to store the current validator set
	StakeSequenceKey                = []byte{0x24} // prefix for each key for the staking sequence map
	SignerKey                       = []byte{0x25} // prefix for signer address for signer map
	LastBlockTxsKey                 = []byte{0x26} // key to store last block's txs
	PreviousBlockValidatorSetKey    = []byte{0x27} // key to store the previous block's validator set
	PenultimateBlockValidatorSetKey = []byte{0x28} // key to store the validator set from 2 blocks ago
	GoldDelegationKey               = []byte{0x29} // prefix for GOLD delegations
	ValidatorApprovalKey            = []byte{0x2a} // prefix for native validator approvals
	ValidatorLifecycleParamsKey     = []byte{0x2b} // key to store native validator lifecycle params
	ValidatorApprovalVoteKey        = []byte{0x2c} // prefix for validator-approval yes-vote markers
	ValidatorApprovalVoterPowerKey  = []byte{0x2d} // prefix for validator-approval snapshot voter powers
	ValidatorApprovalSnapshotKey    = []byte{0x2e} // prefix for validator-approval snapshot total power
	ValidatorApprovalYesPowerKey    = []byte{0x2f} // prefix for validator-approval yes voting power
	ValidatorApprovalFinalizedKey   = []byte{0x30} // prefix for validator-approval finalization flags
)

type PubKey [65]byte

// EmptyPubKey represents an empty pub key
var EmptyPubKey = PubKey{}

var Secp256k1Type = secp256k1.GenPrivKey().PubKey().Type()
