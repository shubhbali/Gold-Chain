package eth

import (
	"fmt"

	"github.com/ethereum/go-ethereum/core"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/eth/protocols/gilt"
	"github.com/ethereum/go-ethereum/p2p/enode"
)

// giltHandler implements the gilt.Backend interface to handle the various network
// packets that are sent as broadcasts.
type giltHandler handler

func (h *giltHandler) Chain() *core.BlockChain { return h.chain }

// RunPeer is invoked when a peer joins on the `gilt` protocol.
func (h *giltHandler) RunPeer(peer *gilt.Peer, hand gilt.Handler) error {
	// Send capability message asynchronously for backward compatibility.
	// Old nodes expect this message to complete their handshake.
	// We don't wait for response - just send and continue.
	peer.SendGiltCap()

	return (*handler)(h).runGiltExtension(peer, hand)
}

// PeerInfo retrieves all known `gilt` information about a peer.
func (h *giltHandler) PeerInfo(id enode.ID) interface{} {
	if p := h.peers.peer(id.String()); p != nil && p.giltExt != nil {
		return p.giltExt.info()
	}
	return nil
}

// Handle is invoked from a peer's message handler when it receives a new remote
// message that the handler couldn't consume and serve itself.
func (h *giltHandler) Handle(peer *gilt.Peer, packet gilt.Packet) error {
	// DeliverSnapPacket is invoked from a peer's message handler when it transmits a
	// data packet for the local node to consume.
	switch packet := packet.(type) {
	case *gilt.VotesPacket:
		return h.handleVotesBroadcast(peer, packet.Votes)

	default:
		return fmt.Errorf("unexpected gilt packet type: %T", packet)
	}
}

// handleVotesBroadcast is invoked from a peer's message handler when it transmits a
// votes broadcast for the local node to process.
func (h *giltHandler) handleVotesBroadcast(peer *gilt.Peer, votes []*types.VoteEnvelope) error {
	if peer.IsOverLimitAfterReceiving() {
		return nil
	}
	// Here we only put the first vote, to avoid ddos attack by sending a large batch of votes.
	// This won't abandon any valid vote, because one vote is sent every time referring to func voteBroadcastLoop
	if len(votes) > 0 {
		h.votepool.PutVote(votes[0])
	}

	return nil
}
