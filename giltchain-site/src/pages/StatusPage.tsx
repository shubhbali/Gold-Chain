import { PageIntro } from '../components/PageIntro'
import { Reveal } from '../components/Reveal'
import { statusRows } from '../data/siteData'

export function StatusPage() {
  return (
    <>
      <Reveal>
        <PageIntro
          eyebrow="Status"
          title="Current service status"
          body="Live snapshot for chain, bridge, migration, and developer endpoint health."
        />
      </Reveal>

      <Reveal>
        <section className="status-table-wrap">
          <table className="status-table">
            <thead>
              <tr>
                <th>Service</th>
                <th>State</th>
                <th>Latency</th>
              </tr>
            </thead>
            <tbody>
              {statusRows.map((row) => (
                <tr key={row.service}>
                  <td>{row.service}</td>
                  <td>
                    <span className="pill success">{row.state}</span>
                  </td>
                  <td>{row.latency}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </section>
      </Reveal>
    </>
  )
}
