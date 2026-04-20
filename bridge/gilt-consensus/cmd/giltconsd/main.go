package main

import (
	"fmt"
	"os"

	svrcmd "github.com/cosmos/cosmos-sdk/server/cmd"

	"github.com/giltchain/gilt-consensus/app"
	giltconsd "github.com/giltchain/gilt-consensus/cmd/giltconsd/cmd"
)

func main() {
	rootCmd := giltconsd.NewRootCmd()
	if err := svrcmd.Execute(rootCmd, "HD", app.DefaultNodeHome); err != nil {
		_, _ = fmt.Fprintln(rootCmd.OutOrStderr(), err)
		os.Exit(1)
	}
}
