import { GoldCard } from '../components/GoldCard'
import { PageIntro } from '../components/PageIntro'
import { Reveal } from '../components/Reveal'
import { validatorRequirements } from '../data/siteData'

export function ValidatorsPage() {
  return (
    <>
      <Reveal>
        <PageIntro
          eyebrow="Validators"
          title="Validator operations with clear standards"
          body="Validators secure the chain, support bridge and migration operations, and take part in governance."
        />
      </Reveal>

      <section className="section-grid two-col">
        <Reveal>
          <GoldCard title="Requirements">
            <ul className="clean-list">
              {validatorRequirements.map((item) => (
                <li key={item}>{item}</li>
              ))}
            </ul>
          </GoldCard>
        </Reveal>
        <Reveal>
          <GoldCard title="Expected Posture">
            <ul className="clean-list">
              <li>Upgrades and migrations run with zero ambiguity</li>
              <li>Monitoring and alerts are always on</li>
              <li>Bridge incidents have tested response runbooks</li>
              <li>Operators publish clear status updates</li>
            </ul>
          </GoldCard>
        </Reveal>
      </section>
    </>
  )
}
