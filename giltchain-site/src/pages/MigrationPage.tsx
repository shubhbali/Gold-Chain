import { GoldCard } from '../components/GoldCard'
import { PageIntro } from '../components/PageIntro'
import { Reveal } from '../components/Reveal'
import { migrationPhases } from '../data/siteData'

export function MigrationPage() {
  return (
    <>
      <Reveal>
        <PageIntro
          eyebrow="Migration"
          title="Move from legacy GOLD to active GOLD safely"
          body="When the GOLD model changes, users keep value and continue normal actions without broken balances."
        />
      </Reveal>

      <section className="section-grid three-col">
        {migrationPhases.map((phase) => (
          <Reveal key={phase.phase}>
            <GoldCard title={phase.title} subtitle={`Phase ${phase.phase}`}>
              <p>{phase.body}</p>
            </GoldCard>
          </Reveal>
        ))}
      </section>

      <Reveal>
        <section className="control-panel">
          <h2>Operator Checklist</h2>
          <ul className="clean-list">
            <li>New GOLD mode is confirmed on-chain</li>
            <li>Reserve is funded before user conversion begins</li>
            <li>Legacy claims still work after cutover</li>
            <li>Public migration status is kept up to date</li>
          </ul>
        </section>
      </Reveal>
    </>
  )
}
