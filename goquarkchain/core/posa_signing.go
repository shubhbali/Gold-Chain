package core

import (
	"encoding/binary"
	"errors"
	"strings"

	"github.com/QuarkChain/goquarkchain/account"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/crypto"
)

const (
	posaVoteDomainPrefix        = "QKC_POSA_VOTE_V1"
	shardActivationDomainPrefix = "QKC_SHARD_ACTIVATE_V1"
	bftProposalDomainPrefix     = "QKC_BFT_PROPOSAL_V1"
	bftVoteDomainPrefix         = "QKC_BFT_VOTE_V1"
)

func posaVoteSigningHash(networkID uint32, targetHash common.Hash, targetNum uint64) common.Hash {
	msg := make([]byte, 0, len(posaVoteDomainPrefix)+4+32+8)
	msg = append(msg, []byte(posaVoteDomainPrefix)...)
	msg = appendUint32BE(msg, networkID)
	msg = append(msg, targetHash.Bytes()...)
	msg = appendUint64BE(msg, targetNum)
	return crypto.Keccak256Hash(msg)
}

func shardActivationSigningHash(networkID uint32, target uint32) common.Hash {
	msg := make([]byte, 0, len(shardActivationDomainPrefix)+4+4)
	msg = append(msg, []byte(shardActivationDomainPrefix)...)
	msg = appendUint32BE(msg, networkID)
	msg = appendUint32BE(msg, target)
	return crypto.Keccak256Hash(msg)
}

func bftVoteSigningHash(networkID uint32, epoch uint64, round uint64, voteType string, targetHash common.Hash) common.Hash {
	msg := make([]byte, 0, len(bftVoteDomainPrefix)+4+8+8+len(voteType)+32)
	msg = append(msg, []byte(bftVoteDomainPrefix)...)
	msg = appendUint32BE(msg, networkID)
	msg = appendUint64BE(msg, epoch)
	msg = appendUint64BE(msg, round)
	msg = append(msg, []byte(strings.ToUpper(voteType))...)
	msg = append(msg, targetHash.Bytes()...)
	return crypto.Keccak256Hash(msg)
}

func bftProposalSigningHash(networkID uint32, epoch uint64, round uint64, targetHash common.Hash) common.Hash {
	msg := make([]byte, 0, len(bftProposalDomainPrefix)+4+8+8+32)
	msg = append(msg, []byte(bftProposalDomainPrefix)...)
	msg = appendUint32BE(msg, networkID)
	msg = appendUint64BE(msg, epoch)
	msg = appendUint64BE(msg, round)
	msg = append(msg, targetHash.Bytes()...)
	return crypto.Keccak256Hash(msg)
}

func appendUint32BE(dst []byte, value uint32) []byte {
	var buf [4]byte
	binary.BigEndian.PutUint32(buf[:], value)
	return append(dst, buf[:]...)
}

func appendUint64BE(dst []byte, value uint64) []byte {
	var buf [8]byte
	binary.BigEndian.PutUint64(buf[:], value)
	return append(dst, buf[:]...)
}

func validatorIDByRecipient(rawValidators []string, recipient account.Recipient) (string, error) {
	want := strings.ToLower(recipient.Hex())
	for _, raw := range rawValidators {
		addrBytes := common.FromHex(raw)
		addr, err := account.CreatAddressFromBytes(addrBytes)
		if err != nil {
			continue
		}
		if strings.ToLower(addr.Recipient.Hex()) == want {
			return strings.ToLower(raw), nil
		}
	}
	return "", errors.New("signature does not match configured validator set")
}
