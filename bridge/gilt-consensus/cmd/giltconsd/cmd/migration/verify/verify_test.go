package verify

import (
	"path/filepath"
	"testing"

	"github.com/stretchr/testify/require"

	"github.com/giltchain/gilt-consensus/helper"
)

func TestRunMigrationVerification(t *testing.T) {
	logger := helper.Logger.With("module", "cmd/giltconsd/cmd/migration/verify")

	genesisFilePath, err := filepath.Abs("../../testdata/dump-genesis.json")
	require.NoError(t, err, "Failed to resolve path for dump-genesis.json")

	migratedGenesisFilePath, err := filepath.Abs("../../testdata/migrated_dump-genesis.json")
	require.NoError(t, err, "Failed to resolve path for migrated_dump-genesis.json")

	err = RunMigrationVerification(genesisFilePath, migratedGenesisFilePath, logger)
	require.NoError(t, err)
}
