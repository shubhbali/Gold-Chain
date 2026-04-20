package gilt

import (
	"github.com/ethereum/go-ethereum/p2p"
)

// SendGiltCap sends the gilt capability message to the peer asynchronously.
// This is for backward compatibility with old nodes that expect a handshake.
// We send the message but don't wait for a response.
func (p *Peer) SendGiltCap() {
	// Send capability message asynchronously for backward compatibility.
	// Old nodes expect this message to complete their handshake.
	// New nodes will ignore it via handleGiltCap in handler.go.
	go func() {
		if err := p2p.Send(p.rw, GiltCapMsg, &GiltCapPacket{
			ProtocolVersion: p.version,
			Extra:           defaultExtra,
		}); err != nil {
			p.Log().Debug("Failed to send gilt capability message", "err", err)
		}
	}()
}
