import { GoldCard } from '../components/GoldCard'
import { PageIntro } from '../components/PageIntro'
import { Reveal } from '../components/Reveal'

export function SecurityPage() {
  return (
    <>
      <Reveal>
        <PageIntro
          eyebrow="Security"
          title="Security rules for high-value flows"
          body="Bridge, migration, and validator operations are treated as critical systems, not optional features."
        />
      </Reveal>

      <section className="section-grid three-col">
        <Reveal>
          <GoldCard title="Finality First">
            <p>Only finalized events can trigger minting, unlocking, accounting changes, and completed status.</p>
          </GoldCard>
        </Reveal>
        <Reveal>
          <GoldCard title="Migration Safety">
            <p>Legacy-to-active GOLD migration must preserve user balances, redemption continuity, and reserve correctness.</p>
          </GoldCard>
        </Reveal>
        <Reveal>
          <GoldCard title="Operational Discipline">
            <p>Operators need transparent status reporting, tested incident paths, and clear operational controls.</p>
          </GoldCard>
        </Reveal>
      </section>
    </>
  )
}
