import { Link } from 'react-router-dom'
import { GoldCard } from '../components/GoldCard'
import { MetricStrip } from '../components/MetricStrip'
import { Reveal } from '../components/Reveal'
import { coreStats, tokenModel } from '../data/siteData'

export function HomePage() {
  return (
    <>
      <Reveal>
        <section className="hero-luxe">
          <div className="hero-copy">
            <p className="eyebrow">Gold Chain</p>
            <h1 className="hero-title">
              Build on a <span>gold-grade chain</span> with real asset discipline.
            </h1>
            <p className="hero-blurb">
              Two core tokens run the system: GILT secures and governs the network, GOLD is the main user-facing
              asset. PAXG and XAUT bridge into one GOLD model.
            </p>
            <div className="cta-row">
              <Link className="btn-gold" to="/bridge">
                Launch Bridge
              </Link>
              <Link className="btn-ghost" to="/tokens">
                Token Model
              </Link>
              <Link className="btn-ghost" to="/status">
                Live Status
              </Link>
            </div>
          </div>

          <aside className="hero-rail">
            <p className="rail-title">Network Snapshot</p>
            <ul className="hero-stat-list">
              <li>
                <span>Core Tokens</span>
                <strong>GILT + GOLD</strong>
              </li>
              <li>
                <span>Bridge Inputs</span>
                <strong>PAXG + XAUT</strong>
              </li>
              <li>
                <span>Chain ID</span>
                <strong>714</strong>
              </li>
              <li>
                <span>Production Focus</span>
                <strong>Finalized-Only State</strong>
              </li>
            </ul>
          </aside>
        </section>
      </Reveal>

      <Reveal>
        <section className="signal-strip">
          <span>Finalized Bridge Events Only</span>
          <span>Single GOLD Model</span>
          <span>Validator-Grade Operations</span>
          <span>Migration + Redemption Aligned</span>
        </section>
      </Reveal>

      <Reveal>
        <MetricStrip items={coreStats} />
      </Reveal>

      <Reveal>
        <section className="section-head">
          <p className="eyebrow">Token Model</p>
          <h2>Two core assets. Two clear jobs.</h2>
        </section>
      </Reveal>

      <section className="section-grid two-col">
        {tokenModel.map((token) => (
          <Reveal key={token.symbol}>
            <GoldCard title={`${token.symbol}: ${token.title}`}>
              <p>{token.body}</p>
            </GoldCard>
          </Reveal>
        ))}
      </section>

      <Reveal>
        <section className="section-head">
          <p className="eyebrow">Core System</p>
          <h2>Every layer points to one production architecture.</h2>
        </section>
      </Reveal>

      <section className="section-grid three-col">
        <Reveal>
          <GoldCard title="Chain">
            <p>
              Validator economics, staking, and governance are anchored to GILT at the chain level.
            </p>
          </GoldCard>
        </Reveal>
        <Reveal>
          <GoldCard title="Bridge">
            <p>
              PAXG and XAUT deposits from Ethereum enter one GOLD model with clear, finality-aware status.
            </p>
          </GoldCard>
        </Reveal>
        <Reveal>
          <GoldCard title="Operations">
            <p>
              Operators run migration, monitoring, and incident response with production runbooks.
            </p>
          </GoldCard>
        </Reveal>
      </section>

      <Reveal>
        <section className="cta-panel">
          <h2>One production flow from deposit to redemption</h2>
          <p>Chain, bridge, migration, validators, and developer endpoints are aligned to one final architecture.</p>
          <div className="cta-row">
            <Link className="btn-gold" to="/bridge">
              Open Bridge
            </Link>
            <Link className="btn-ghost" to="/developers">
              Open Developer Hub
            </Link>
          </div>
        </section>
      </Reveal>
    </>
  )
}
