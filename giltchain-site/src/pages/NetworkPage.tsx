import { GoldCard } from '../components/GoldCard'
import { PageIntro } from '../components/PageIntro'
import { Reveal } from '../components/Reveal'

export function NetworkPage() {
  return (
    <>
      <Reveal>
        <PageIntro
          eyebrow="Network"
          title="One network model across GILT and GOLD"
          body="Gold Chain is built so GILT and GOLD work together with one consistent rule set for staking, bridge, migration, and redemption."
        />
      </Reveal>

      <section className="section-grid three-col">
        <Reveal>
          <GoldCard title="Validators">
            <p>Validators secure the chain, produce blocks, and take part in governance and upgrades.</p>
          </GoldCard>
        </Reveal>
        <Reveal>
          <GoldCard title="Staking">
            <p>Staking and rewards follow chain rules so incentives and balances stay predictable.</p>
          </GoldCard>
        </Reveal>
        <Reveal>
          <GoldCard title="Migration & Redemption">
            <p>Legacy and active GOLD transitions are explicit so users do not get trapped in old paths.</p>
          </GoldCard>
        </Reveal>
      </section>
    </>
  )
}
