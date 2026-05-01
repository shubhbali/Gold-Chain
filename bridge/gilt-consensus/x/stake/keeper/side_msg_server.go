package keeper

import "github.com/giltchain/gilt-consensus/sidetxs"

type sideMsgServer struct {
	k *Keeper
}

// NewSideMsgServerImpl keeps the side-tx service registered without using it
// for validator lifecycle. Validator join/update/exit are native Gold Chain
// transactions now, not Ethereum bridge-event side transactions.
func NewSideMsgServerImpl(keeper *Keeper) sidetxs.SideMsgServer {
	return &sideMsgServer{k: keeper}
}

func (s *sideMsgServer) SideTxHandler(methodName string) sidetxs.SideTxHandler {
	return nil
}

func (s *sideMsgServer) PostTxHandler(methodName string) sidetxs.PostTxHandler {
	return nil
}
