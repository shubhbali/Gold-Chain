// Code generated - retained minimal Gold Chain bridge binding. DO NOT EDIT.

package stakinginfo

import (
	"errors"
	"math/big"
	"strings"

	"github.com/ethereum/go-ethereum/accounts/abi"
	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/types"
)

// StakinginfoMetaData contains only the retained bridge ABI surface.
var StakinginfoMetaData = &bind.MetaData{
	ABI: "[{\"constant\":true,\"inputs\":[],\"name\":\"getAccountStateRoot\",\"outputs\":[{\"internalType\":\"bytes32\",\"name\":\"accountStateRoot\",\"type\":\"bytes32\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"user\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"uint256\",\"name\":\"fee\",\"type\":\"uint256\"}],\"name\":\"TopUpFee\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"uint256\",\"name\":\"nonce\",\"type\":\"uint256\"},{\"indexed\":true,\"internalType\":\"uint256\",\"name\":\"amount\",\"type\":\"uint256\"}],\"name\":\"Slashed\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"uint256\",\"name\":\"validatorId\",\"type\":\"uint256\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"signer\",\"type\":\"address\"}],\"name\":\"UnJailed\",\"type\":\"event\"}]",
}

// Deprecated: Use StakinginfoMetaData.ABI instead.
var StakinginfoABI = StakinginfoMetaData.ABI

// Stakinginfo is a minimal binding for retained bridge reads.
type Stakinginfo struct {
	contract *bind.BoundContract
}

// NewStakinginfo creates a new minimal StakingInfo binding.
func NewStakinginfo(address common.Address, backend bind.ContractBackend) (*Stakinginfo, error) {
	parsed, err := abi.JSON(strings.NewReader(StakinginfoMetaData.ABI))
	if err != nil {
		return nil, err
	}

	return &Stakinginfo{
		contract: bind.NewBoundContract(address, parsed, backend, backend, backend),
	}, nil
}

// GetAccountStateRoot reads the retained account-state root for topup accounting.
func (_Stakinginfo *Stakinginfo) GetAccountStateRoot(opts *bind.CallOpts) ([32]byte, error) {
	var out []interface{}
	err := _Stakinginfo.contract.Call(opts, &out, "getAccountStateRoot")
	if err != nil {
		return [32]byte{}, err
	}
	if len(out) == 0 {
		return [32]byte{}, errors.New("stakinginfo getAccountStateRoot returned no data")
	}

	return *abi.ConvertType(out[0], new([32]byte)).(*[32]byte), nil
}

// StakinginfoTopUpFee represents a retained TopUpFee event.
type StakinginfoTopUpFee struct {
	User common.Address
	Fee  *big.Int
	Raw  types.Log
}

// StakinginfoSlashed represents a retained Slashed event.
type StakinginfoSlashed struct {
	Nonce  *big.Int
	Amount *big.Int
	Raw    types.Log
}

// StakinginfoUnJailed represents a retained UnJailed event.
type StakinginfoUnJailed struct {
	ValidatorId *big.Int
	Signer      common.Address
	Raw         types.Log
}
