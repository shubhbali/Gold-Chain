import { GoldCard } from '../components/GoldCard'
import { PageIntro } from '../components/PageIntro'
import { Reveal } from '../components/Reveal'
import { tokenModel } from '../data/siteData'

export function TokensPage() {
  return (
    <>
      <Reveal>
        <PageIntro
          eyebrow="Tokens"
          title="Two core tokens power Gold Chain"
          body="Gold Chain runs on GILT and GOLD. GILT secures and governs the network. GOLD is the main user-facing gold asset."
        />
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
        <section className="control-panel">
          <h2>How Bridged Gold Fits In</h2>
          <ul className="clean-list">
            <li>PAXG and XAUT bridge from Ethereum into the GOLD model on Gold Chain.</li>
            <li>The bridge updates balances only after final confirmations.</li>
            <li>This keeps one clean gold asset model for users on Gold Chain.</li>
          </ul>
        </section>
      </Reveal>
    </>
  )
}
