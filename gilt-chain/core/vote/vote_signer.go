package vote

import (
	"encoding/json"
	"os"
	"path/filepath"
	"strings"

	"github.com/pkg/errors"
	keystorev4 "github.com/wealdtech/go-eth2-wallet-encryptor-keystorev4"

	"github.com/ethereum/go-ethereum/core/types"
	bls "github.com/ethereum/go-ethereum/crypto/blscompat"
	"github.com/ethereum/go-ethereum/log"
	"github.com/ethereum/go-ethereum/metrics"
)

var votesSigningErrorCounter = metrics.NewRegisteredCounter("votesSigner/error", nil)

type VoteSigner struct {
	secretKey bls.SecretKey
	PubKey    [48]byte
}

type accountsKeystoreRepresentation struct {
	Crypto map[string]interface{} `json:"crypto"`
	ID     string                 `json:"uuid"`
	Name   string                 `json:"name"`
}

type accountStore struct {
	PrivateKeys [][]byte `json:"private_keys"`
	PublicKeys  [][]byte `json:"public_keys"`
}

func NewVoteSigner(blsPasswordPath, blsWalletPath string) (*VoteSigner, error) {
	if info, err := os.Stat(blsWalletPath); err != nil || !info.IsDir() {
		log.Error("BLS wallet does not exist", "path", blsWalletPath, "err", err)
		return nil, errors.New("BLS wallet does not exist")
	}

	walletPassword, err := os.ReadFile(blsPasswordPath)
	if err != nil {
		log.Error("Read BLS wallet password", "err", err)
		return nil, err
	}
	log.Info("Read BLS wallet password successfully")

	accountsPath := filepath.Join(blsWalletPath, "accounts", "all-accounts.keystore.json")
	encoded, err := os.ReadFile(accountsPath)
	if err != nil {
		log.Error("Read BLS accounts keystore failed", "path", accountsPath, "err", err)
		return nil, err
	}

	keystore := &accountsKeystoreRepresentation{}
	if err := json.Unmarshal(encoded, keystore); err != nil {
		return nil, errors.Wrap(err, "could not decode BLS accounts keystore")
	}
	store, err := decryptAccountStore(keystore.Crypto, string(walletPassword))
	if err != nil && strings.TrimSpace(string(walletPassword)) != string(walletPassword) {
		store, err = decryptAccountStore(keystore.Crypto, strings.TrimSpace(string(walletPassword)))
	}
	if err != nil {
		return nil, errors.Wrap(err, "could not decrypt BLS accounts keystore")
	}
	if len(store.PrivateKeys) == 0 {
		return nil, errors.New("BLS accounts keystore has no private keys")
	}
	if len(store.PrivateKeys) != len(store.PublicKeys) {
		return nil, errors.New("BLS accounts keystore has mismatched public/private keys")
	}
	secretKey, err := bls.SecretKeyFromBytes(store.PrivateKeys[0])
	if err != nil {
		return nil, errors.Wrap(err, "could not load BLS secret key")
	}
	pubKeyBytes := store.PublicKeys[0]
	if len(pubKeyBytes) == 0 {
		pubKeyBytes = secretKey.PublicKey().Marshal()
	}
	if len(pubKeyBytes) != len([48]byte{}) {
		return nil, errors.New("BLS public key must be 48 bytes")
	}
	var pubKey [48]byte
	copy(pubKey[:], pubKeyBytes)

	return &VoteSigner{
		secretKey: secretKey,
		PubKey:    pubKey,
	}, nil
}

func decryptAccountStore(crypto map[string]interface{}, password string) (*accountStore, error) {
	decryptor := keystorev4.New()
	decrypted, err := decryptor.Decrypt(crypto, password)
	if err != nil {
		return nil, err
	}
	store := &accountStore{}
	if err := json.Unmarshal(decrypted, store); err != nil {
		return nil, err
	}
	return store, nil
}

func (signer *VoteSigner) SignVote(vote *types.VoteEnvelope) error {
	// Sign the vote, fetch the first pubKey as validator's bls public key.
	pubKey := signer.PubKey
	blsPubKey, err := bls.PublicKeyFromBytes(pubKey[:])
	if err != nil {
		return errors.Wrap(err, "convert public key from bytes to bls failed")
	}

	voteDataHash := vote.Data.Hash()

	signature := signer.secretKey.Sign(voteDataHash[:])

	copy(vote.VoteAddress[:], blsPubKey.Marshal()[:])
	copy(vote.Signature[:], signature.Marshal()[:])
	return nil
}
