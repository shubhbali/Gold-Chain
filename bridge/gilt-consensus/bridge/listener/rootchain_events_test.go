package listener

import (
	"strings"
	"testing"

	"github.com/ethereum/go-ethereum/accounts/abi"
	"github.com/stretchr/testify/require"

	"github.com/giltchain/gilt-consensus/helper"
)

func TestSupportedRootChainEvents(t *testing.T) {
	t.Parallel()

	require.True(t, isSupportedRootChainEvent(helper.NewHeaderBlockEvent))
	require.True(t, isSupportedRootChainEvent(helper.StateSyncedEvent))
	require.True(t, isSupportedRootChainEvent(helper.TopUpFeeEvent))
	require.True(t, isSupportedRootChainEvent(helper.SlashedEvent))
	require.True(t, isSupportedRootChainEvent(helper.UnJailedEvent))
	require.False(t, isSupportedRootChainEvent("UnsupportedValidatorLifecycleEvent"))
}

func TestRootChainListenerSupportedRootEventByTopic(t *testing.T) {
	t.Parallel()

	testABI, err := abi.JSON(strings.NewReader(`[
		{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"user","type":"address"},{"indexed":true,"internalType":"uint256","name":"fee","type":"uint256"}],"name":"TopUpFee","type":"event"},
		{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"validatorId","type":"uint256"}],"name":"UnsupportedValidatorLifecycleEvent","type":"event"}
	]`))
	require.NoError(t, err)

	listener := &RootChainListener{abis: []*abi.ABI{&testABI}}

	selectedEvent := listener.supportedRootEventByTopic(testABI.Events[helper.TopUpFeeEvent].ID.Bytes())
	require.NotNil(t, selectedEvent)
	require.Equal(t, helper.TopUpFeeEvent, selectedEvent.Name)

	selectedEvent = listener.supportedRootEventByTopic(testABI.Events["UnsupportedValidatorLifecycleEvent"].ID.Bytes())
	require.Nil(t, selectedEvent)
}

func TestRootChainListenerSupportedRootEventTopics(t *testing.T) {
	t.Parallel()

	testABI, err := abi.JSON(strings.NewReader(`[
		{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"user","type":"address"},{"indexed":true,"internalType":"uint256","name":"fee","type":"uint256"}],"name":"TopUpFee","type":"event"},
		{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"validatorId","type":"uint256"}],"name":"UnsupportedValidatorLifecycleEvent","type":"event"}
	]`))
	require.NoError(t, err)

	listener := &RootChainListener{abis: []*abi.ABI{&testABI}}

	topics := listener.supportedRootEventTopics()
	require.Len(t, topics, 1)
	require.Equal(t, testABI.Events[helper.TopUpFeeEvent].ID, topics[0])
}
