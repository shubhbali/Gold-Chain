package types

// stake module event types
var (
	EventTypeApproveValidator       = "approve-validator"
	EventTypeValidatorJoin          = "validator-join"
	EventTypeSignerUpdate           = "signer-update"
	EventTypeStakeUpdate            = "stake-update"
	EventTypeValidatorExit          = "validator-exit"
	EventTypeWithdrawValidatorStake = "withdraw-validator-stake"
	EventTypeDelegateGold           = "delegate-gold"
	EventTypeUndelegateGold         = "undelegate-gold"

	AttributeKeySigner         = "signer"
	AttributeKeyOperator       = "operator"
	AttributeKeyVoter          = "voter"
	AttributeKeyValidatorID    = "validator-id"
	AttributeKeyValidatorNonce = "validator-nonce"
	AttributeKeyApprovalYes    = "approval-yes-power"
	AttributeKeyApprovalTotal  = "approval-total-power"
	AttributeKeyApprovalDone   = "approval-finalized"
	AttributeKeyDelegator      = "delegator"
	AttributeKeyAmount         = "amount"

	AttributeValueCategory = ModuleName
)
