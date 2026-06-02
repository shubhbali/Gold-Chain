package blscompat

import (
	"github.com/prysmaticlabs/prysm/v5/crypto/bls/blst"
	"github.com/prysmaticlabs/prysm/v5/crypto/bls/common"
)

type PublicKey = common.PublicKey
type SecretKey = common.SecretKey
type Signature = common.Signature

func PublicKeyFromBytes(pubKey []byte) (PublicKey, error) {
	return blst.PublicKeyFromBytes(pubKey)
}

func SignatureFromBytes(sig []byte) (Signature, error) {
	return blst.SignatureFromBytes(sig)
}

func MultipleSignaturesFromBytes(sigs [][]byte) ([]Signature, error) {
	return blst.MultipleSignaturesFromBytes(sigs)
}

func AggregateSignatures(sigs []Signature) Signature {
	return blst.AggregateSignatures(sigs)
}

func RandKey() (SecretKey, error) {
	return blst.RandKey()
}

func SecretKeyFromBytes(privKey []byte) (SecretKey, error) {
	return blst.SecretKeyFromBytes(privKey)
}
