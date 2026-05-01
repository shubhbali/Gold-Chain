package keeper

import (
	"context"

	"github.com/giltchain/gilt-consensus/x/pricefeed/types"
)

var _ types.QueryServer = queryServer{}

type queryServer struct {
	k Keeper
}

// NewQueryServer returns the pricefeed query server.
func NewQueryServer(k Keeper) types.QueryServer {
	return queryServer{k: k}
}

func (q queryServer) Params(ctx context.Context, _ *types.QueryParamsRequest) (*types.QueryParamsResponse, error) {
	params, err := q.k.GetParams(ctx)
	if err != nil {
		return nil, err
	}
	return &types.QueryParamsResponse{Params: params}, nil
}

func (q queryServer) LatestPrice(ctx context.Context, _ *types.QueryLatestPriceRequest) (*types.QueryLatestPriceResponse, error) {
	price, err := q.k.GetLatestPriceSnapshot(ctx)
	if err != nil {
		return nil, err
	}
	return &types.QueryLatestPriceResponse{Price: price}, nil
}

func (q queryServer) PriceByEpoch(ctx context.Context, req *types.QueryPriceByEpochRequest) (*types.QueryPriceByEpochResponse, error) {
	price, err := q.k.GetPriceSnapshot(ctx, req.Epoch)
	if err != nil {
		return nil, err
	}
	return &types.QueryPriceByEpochResponse{Price: price}, nil
}
