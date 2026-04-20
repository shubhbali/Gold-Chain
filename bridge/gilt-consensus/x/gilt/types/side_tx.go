package types

import (
	"github.com/giltchain/gilt-consensus/sidetxs"
)

// RegisterSideMsgServer registers server methods for the x/gilt module handlers, based on the sideCfg.
func RegisterSideMsgServer(sideCfg sidetxs.SideTxConfigurator, srv sidetxs.SideMsgServer) {
	sidetxs.CommonRegisterSideMsgServer(sideCfg, srv, _Msg_serviceDesc)
}
