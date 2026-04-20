package types

import (
	"github.com/giltchain/gilt-consensus/sidetxs"
)

func RegisterSideMsgServer(sideCfg sidetxs.SideTxConfigurator, srv sidetxs.SideMsgServer) {
	sidetxs.CommonRegisterSideMsgServer(sideCfg, srv, _Msg_serviceDesc)
}
