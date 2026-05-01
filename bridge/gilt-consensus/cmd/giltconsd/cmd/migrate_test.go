package giltconsd

import (
	"encoding/json"
	"testing"

	"cosmossdk.io/log"
	cmttypes "github.com/cometbft/cometbft/types"
	dbm "github.com/cosmos/cosmos-db"
	"github.com/cosmos/cosmos-sdk/client/flags"
	simtestutil "github.com/cosmos/cosmos-sdk/testutil/sims"
	"github.com/stretchr/testify/require"

	giltconsensusApp "github.com/giltchain/gilt-consensus/app"
)

func TestValidateGenesisAfterMigrationRejectsUnsafeValidatorSet(t *testing.T) {
	db := dbm.NewMemDB()

	appOptions := make(simtestutil.AppOptionsMap)
	appOptions[flags.FlagHome] = giltconsensusApp.DefaultNodeHome

	logger := log.NewTestLogger(t)
	app := giltconsensusApp.NewGiltConsensusApp(logger, db, nil, true, appOptions)

	genDoc, err := cmttypes.GenesisDocFromFile("./testdata/migrated_dump-genesis.json")
	require.NoError(t, err)

	var genesisState giltconsensusApp.GenesisState
	err = json.Unmarshal(genDoc.AppState, &genesisState)
	require.NoError(t, err)

	appCodec := app.AppCodec()
	err = app.BasicManager.ValidateGenesis(appCodec, nil, genesisState)
	require.ErrorContains(t, err, "active validator count 1 is below minimum 4")
}
