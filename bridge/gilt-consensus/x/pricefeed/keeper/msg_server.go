package keeper

import (
	"context"

	errorsmod "cosmossdk.io/errors"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	govtypes "github.com/cosmos/cosmos-sdk/x/gov/types"

	"github.com/giltchain/gilt-consensus/x/pricefeed/types"
)

var _ types.MsgServer = msgServer{}

type msgServer struct {
	Keeper
}

// NewMsgServerImpl returns a pricefeed MsgServer.
func NewMsgServerImpl(keeper Keeper) types.MsgServer {
	return &msgServer{Keeper: keeper}
}

func (srv msgServer) UpdateParams(ctx context.Context, req *types.MsgUpdateParams) (*types.MsgUpdateParamsResponse, error) {
	if srv.GetAuthority() != req.Authority {
		return nil, errorsmod.Wrapf(govtypes.ErrInvalidSigner, "invalid authority; expected %s, got %s", srv.GetAuthority(), req.Authority)
	}
	if err := req.ValidateBasic(); err != nil {
		return nil, err
	}
	currentParams, err := srv.GetParams(ctx)
	if err != nil {
		return nil, err
	}
	if err := req.Params.ValidateDirectUpdateFrom(currentParams); err != nil {
		return nil, errorsmod.Wrap(types.ErrInvalidParams, err.Error())
	}
	if err := srv.SetParams(ctx, req.Params); err != nil {
		return nil, errorsmod.Wrapf(types.ErrInvalidParams, "failed to update pricefeed params; %s", err)
	}
	return &types.MsgUpdateParamsResponse{}, nil
}

func (srv msgServer) SetPriceSnapshot(ctx context.Context, req *types.MsgSetPriceSnapshot) (*types.MsgSetPriceSnapshotResponse, error) {
	if srv.GetAuthority() != req.Authority {
		return nil, errorsmod.Wrapf(govtypes.ErrInvalidSigner, "invalid authority; expected %s, got %s", srv.GetAuthority(), req.Authority)
	}
	if err := req.ValidateBasic(); err != nil {
		return nil, err
	}
	if err := srv.Keeper.SetPriceSnapshot(ctx, req.Price); err != nil {
		return nil, errorsmod.Wrapf(types.ErrInvalidPrice, "failed to set price snapshot; %s", err)
	}
	return &types.MsgSetPriceSnapshotResponse{}, nil
}

func (srv msgServer) ScheduleAdapterUpdate(ctx context.Context, req *types.MsgScheduleAdapterUpdate) (*types.MsgScheduleAdapterUpdateResponse, error) {
	if srv.GetAuthority() != req.Authority {
		return nil, errorsmod.Wrapf(govtypes.ErrInvalidSigner, "invalid authority; expected %s, got %s", srv.GetAuthority(), req.Authority)
	}
	if err := req.ValidateBasic(); err != nil {
		return nil, err
	}
	params, err := srv.GetParams(ctx)
	if err != nil {
		return nil, err
	}
	sdkCtx := sdk.UnwrapSDKContext(ctx)
	if req.ActivationHeight <= uint64(sdkCtx.BlockHeight()) {
		return nil, errorsmod.Wrap(sdkerrors.ErrInvalidRequest, "activation_height must be in the future")
	}
	params.PendingAdapter = req.Adapter
	params.PendingAdapterRoute = req.AdapterRoute
	params.PendingActivationHeight = req.ActivationHeight
	if err := srv.SetParams(ctx, params); err != nil {
		return nil, errorsmod.Wrapf(types.ErrInvalidParams, "failed to schedule adapter update; %s", err)
	}
	return &types.MsgScheduleAdapterUpdateResponse{}, nil
}

func (srv msgServer) ActivateAdapterUpdate(ctx context.Context, req *types.MsgActivateAdapterUpdate) (*types.MsgActivateAdapterUpdateResponse, error) {
	if srv.GetAuthority() != req.Authority {
		return nil, errorsmod.Wrapf(govtypes.ErrInvalidSigner, "invalid authority; expected %s, got %s", srv.GetAuthority(), req.Authority)
	}
	if err := req.ValidateBasic(); err != nil {
		return nil, err
	}
	params, err := srv.GetParams(ctx)
	if err != nil {
		return nil, err
	}
	if params.PendingAdapter == "" {
		return nil, types.ErrNoPendingAdapter
	}
	sdkCtx := sdk.UnwrapSDKContext(ctx)
	if uint64(sdkCtx.BlockHeight()) < params.PendingActivationHeight {
		return nil, types.ErrAdapterNotActivated
	}
	params.ActiveAdapter = params.PendingAdapter
	params.AdapterRoute = params.PendingAdapterRoute
	params.PendingAdapter = ""
	params.PendingAdapterRoute = ""
	params.PendingActivationHeight = 0
	if err := srv.SetParams(ctx, params); err != nil {
		return nil, errorsmod.Wrapf(types.ErrInvalidParams, "failed to activate adapter update; %s", err)
	}
	return &types.MsgActivateAdapterUpdateResponse{}, nil
}
