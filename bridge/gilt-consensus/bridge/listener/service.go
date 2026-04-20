package listener

import (
	"os"

	logger "github.com/cometbft/cometbft/libs/log"
	common "github.com/cometbft/cometbft/libs/service"
	rpchttp "github.com/cometbft/cometbft/rpc/client/http"
	"github.com/cosmos/cosmos-sdk/codec"

	"github.com/giltchain/gilt-consensus/bridge/queue"
	"github.com/giltchain/gilt-consensus/helper"
)

const (
	listenerServiceStr = "listener"

	rootChainListenerStr = "rootchain"
	giltconsensusListenerStr  = "giltconsensus"
	giltChainListenerStr  = "giltchain"
)

// Service starts and stops all chain event listeners
type Service struct {
	// Base service
	common.BaseService
	listeners []Listener
}

// NewListenerService returns the new service object for listening to events
func NewListenerService(cdc codec.Codec, queueConnector *queue.Connector, httpClient *rpchttp.HTTP) *Service {
	// creating the listener object
	listenerService := &Service{}

	listenerService.BaseService = *common.NewBaseService(logger.NewTMLogger(logger.NewSyncWriter(os.Stdout)).With("service", "listener"), listenerServiceStr, listenerService)

	rootChainListener := NewRootChainListener()
	rootChainListener.BaseListener = *NewBaseListener(cdc, queueConnector, httpClient, helper.GetMainClient(), rootChainListenerStr, rootChainListener)
	listenerService.listeners = append(listenerService.listeners, rootChainListener)

	giltChainListener := &GiltChainListener{}
	giltChainListener.BaseListener = *NewBaseListener(cdc, queueConnector, httpClient, helper.GetGiltClient(), giltChainListenerStr, giltChainListener)
	listenerService.listeners = append(listenerService.listeners, giltChainListener)

	giltconsensusListener := &GiltConsensusListener{}
	giltconsensusListener.BaseListener = *NewBaseListener(cdc, queueConnector, httpClient, nil, giltconsensusListenerStr, giltconsensusListener)
	listenerService.listeners = append(listenerService.listeners, giltconsensusListener)

	return listenerService
}

// OnStart starts the new block subscription
func (listenerService *Service) OnStart() error {
	if err := listenerService.BaseService.OnStart(); err != nil {
		listenerService.Logger.Error("ListenerService: OnStart | OnStart", "Error", err)
	} // Always call the overridden method.

	// start chain listeners
	for _, listener := range listenerService.listeners {
		if err := listener.Start(); err != nil {
			listenerService.Logger.Error("ListenerService: OnStart | Start", "Error", err)
		}
	}

	listenerService.Logger.Info("ListenerService: all listeners started")

	return nil
}

// OnStop stops all necessary go routines
func (listenerService *Service) OnStop() {
	listenerService.BaseService.OnStop() // Always call the overridden method.

	// start chain listeners
	for _, listener := range listenerService.listeners {
		listener.Stop()
	}

	listenerService.Logger.Info("ListenerService: all listeners stopped")
}
