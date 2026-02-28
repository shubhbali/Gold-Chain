package qkcapi

import (
	"fmt"
	"strconv"

	"github.com/QuarkChain/goquarkchain/account"
	"github.com/QuarkChain/goquarkchain/common/hexutil"
	"github.com/QuarkChain/goquarkchain/core/types"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ybbus/jsonrpc"
)

type NetApi struct {
	c jsonrpc.RPCClient
}

func NewNetApi(c jsonrpc.RPCClient) *NetApi {
	return &NetApi{c: c}
}

func (e *NetApi) Version() string {
	resp, err := e.c.Call("net_version")
	if err != nil {
		return err.Error()
	}
	return resp.Result.(string)
}

type Web3Api struct {
}

func NewWeb3Api(c jsonrpc.RPCClient) *Web3Api {
	return &Web3Api{}
}

func (e *Web3Api) ClientVersion() string {
	return "GoQuarkChain/release:mainnet1.5.2"
}

func reWriteBlockResult(block map[string]interface{}) map[string]interface{} {
	if block == nil {
		return nil
	}
	// Truncate fields which contain full shard id
	if block["id"] != nil {
		block["id"] = block["id"].(string)[:66]
	}
	if block["idPrevMinorBlock"] != nil {
		block["idPrevMinorBlock"] = block["idPrevMinorBlock"].(string)[:66]
	}
	if block["miner"] != nil {
		block["miner"] = block["miner"].(string)[:42]
	}
	// rename fields
	if block["height"] != nil {
		block["number"] = block["height"]
	}
	if block["hashPrevMinorBlock"] != nil {
		block["parentHash"] = block["hashPrevMinorBlock"]
	}
	if block["nonce"] != nil {
		nonce, _ := strconv.ParseUint(block["nonce"].(string)[2:], 16, 32)
		block["nonce"] = fmt.Sprintf("0x%016x", nonce)
	}
	if block["sha3Uncles"] == nil {
		block["sha3Uncles"] = types.EmptyUncleHash
	}
	if block["hashMerkleRoot"] != nil {
		block["transactionsRoot"] = block["hashMerkleRoot"]
	}
	if block["hashEvmStateRoot"] != nil {
		block["stateRoot"] = block["hashEvmStateRoot"]
	}
	if block["receiptsRoot"] == nil {
		block["receiptsRoot"] = common.ToHex(common.Hash{}.Bytes())
	}
	if block["logsBloom"] == nil {
		block["logsBloom"] = common.ToHex(make([]byte, types.BloomByteLength))
	}
	return block
}

// MetaCallArgs represents the arguments for a call.
type MetaCallArgs struct {
	From            *account.Recipient `json:"from"`
	To              *account.Recipient `json:"to"`
	Gas             hexutil.Big        `json:"gas"`
	GasPrice        hexutil.Big        `json:"gasPrice"`
	Value           hexutil.Big        `json:"value"`
	Data            hexutil.Bytes      `json:"data"`
	GasTokenID      *hexutil.Uint64    `json:"gasTokenId"`
	TransferTokenID *hexutil.Uint64    `json:"transferTokenId"`
}
