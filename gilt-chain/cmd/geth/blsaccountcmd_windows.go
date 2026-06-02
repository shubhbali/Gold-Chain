//go:build windows
// +build windows

package main

import (
	"fmt"

	"github.com/urfave/cli/v2"
)

var blsCommand = &cli.Command{
	Name:     "bls",
	Usage:    "Manage BLS wallet and accounts",
	Category: "BLS ACCOUNT COMMANDS",
	Action: func(ctx *cli.Context) error {
		return fmt.Errorf("geth bls account management is not available on Windows; use Linux for BLS wallet creation/import")
	},
}
