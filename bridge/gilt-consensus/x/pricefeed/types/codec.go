package types

import (
	"github.com/cosmos/cosmos-sdk/codec"
	"github.com/cosmos/cosmos-sdk/codec/legacy"
	codectypes "github.com/cosmos/cosmos-sdk/codec/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/msgservice"
)

// RegisterLegacyAminoCodec registers pricefeed messages on the LegacyAmino codec.
func RegisterLegacyAminoCodec(cdc *codec.LegacyAmino) {
	legacy.RegisterAminoMsg(cdc, &MsgUpdateParams{}, "gilt/pricefeed/MsgUpdateParams")
	legacy.RegisterAminoMsg(cdc, &MsgSetPriceSnapshot{}, "gilt/pricefeed/MsgSetPrice")
	legacy.RegisterAminoMsg(cdc, &MsgScheduleAdapterUpdate{}, "gilt/pricefeed/MsgScheduleAdapter")
	legacy.RegisterAminoMsg(cdc, &MsgActivateAdapterUpdate{}, "gilt/pricefeed/MsgActivateAdapter")
}

// RegisterInterfaces registers pricefeed messages.
func RegisterInterfaces(registry codectypes.InterfaceRegistry) {
	registry.RegisterImplementations((*sdk.Msg)(nil),
		&MsgUpdateParams{},
		&MsgSetPriceSnapshot{},
		&MsgScheduleAdapterUpdate{},
		&MsgActivateAdapterUpdate{},
	)
	msgservice.RegisterMsgServiceDesc(registry, &_Msg_serviceDesc)
}
