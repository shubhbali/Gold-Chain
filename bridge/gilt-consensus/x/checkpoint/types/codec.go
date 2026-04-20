package types

import (
	"github.com/cosmos/cosmos-sdk/codec"
	"github.com/cosmos/cosmos-sdk/codec/legacy"
	"github.com/cosmos/cosmos-sdk/codec/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/msgservice"
)

// RegisterLegacyAminoCodec registers the necessary x/checkpoint interfaces and concrete types
// on the provided LegacyAmino codec. These types are used for Amino JSON serialization.
func RegisterLegacyAminoCodec(cdc *codec.LegacyAmino) {
	legacy.RegisterAminoMsg(cdc, &MsgCheckpoint{}, "giltconsensusv2/checkpoint/MsgCheckpoint")
	legacy.RegisterAminoMsg(cdc, &MsgCpAck{}, "giltconsensusv2/checkpoint/MsgCpAck")
	legacy.RegisterAminoMsg(cdc, &MsgCpNoAck{}, "giltconsensusv2/checkpoint/MsgCpNoAck")
	legacy.RegisterAminoMsg(cdc, &MsgUpdateParams{}, "giltconsensusv2/checkpoint/MsgUpdateParams")
}

// RegisterInterfaces registers the x/checkpoint interfaces types with the interface registry
func RegisterInterfaces(registry types.InterfaceRegistry) {
	registry.RegisterImplementations((*sdk.Msg)(nil),
		&MsgCheckpoint{},
		&MsgCpAck{},
		&MsgCpNoAck{},
		&MsgUpdateParams{},
	)
	msgservice.RegisterMsgServiceDesc(registry, &_Msg_serviceDesc)
}
