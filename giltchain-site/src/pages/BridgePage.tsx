import { GoldCard } from '../components/GoldCard'
import { PageIntro } from '../components/PageIntro'
import { Reveal } from '../components/Reveal'
import { bridgeRoutes } from '../data/siteData'

export function BridgePage() {
  return (
    <>
      <Reveal>
        <PageIntro
          eyebrow="Bridge"
          title="Bridge transfers complete only after final confirmation"
          body="A transfer is not complete when first seen in logs. It is complete only after the required confirmations."
        />
      </Reveal>

      <section className="section-grid three-col">
        {bridgeRoutes.map((route) => (
          <Reveal key={route.title}>
            <GoldCard title={route.title} subtitle={route.route}>
              <p>{route.body}</p>
              <span className="pill success">{route.status}</span>
            </GoldCard>
          </Reveal>
        ))}
      </section>

      <Reveal>
        <section className="control-panel">
          <h2>Bridge Transfer States</h2>
          <div className="status-flow">
            <span>Submitted</span>
            <span>Waiting Confirmations</span>
            <span>Finalized</span>
            <span>Minted / Released</span>
          </div>
        </section>
      </Reveal>
    </>
  )
}
