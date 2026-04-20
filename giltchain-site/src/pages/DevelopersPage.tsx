import { GoldCard } from '../components/GoldCard'
import { MetricStrip } from '../components/MetricStrip'
import { PageIntro } from '../components/PageIntro'
import { Reveal } from '../components/Reveal'
import { devSurface } from '../data/siteData'

export function DevelopersPage() {
  return (
    <>
      <Reveal>
        <PageIntro
          eyebrow="Developers"
          title="Simple endpoints and clear integration rules"
          body="Use the chain endpoints and bridge data to build apps that match how Gold Chain actually works."
        />
      </Reveal>

      <Reveal>
        <MetricStrip items={devSurface} />
      </Reveal>

      <section className="section-grid two-col">
        <Reveal>
          <GoldCard title="Integration Focus">
            <ul className="clean-list">
              <li>Read chain state and submit transactions</li>
              <li>Track bridge transfers with finality-aware status</li>
              <li>Show migration state clearly in user flows</li>
              <li>Link cleanly with DEX and scanner products</li>
            </ul>
          </GoldCard>
        </Reveal>
        <Reveal>
          <GoldCard title="Delivery Standards">
            <ul className="clean-list">
              <li>Update balances only from finalized events</li>
              <li>Do not hide fallback accounting paths</li>
              <li>Avoid split UX between legacy and active GOLD</li>
              <li>Match the final chain architecture in product logic</li>
            </ul>
          </GoldCard>
        </Reveal>
      </section>
    </>
  )
}
