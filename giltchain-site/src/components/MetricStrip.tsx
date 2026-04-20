type Metric = {
  label: string
  value: string
}

type MetricStripProps = {
  items: Metric[]
}

export function MetricStrip({ items }: MetricStripProps) {
  return (
    <div className="metric-strip">
      {items.map((item) => (
        <article className="metric-card" key={`${item.label}-${item.value}`}>
          <p>{item.label}</p>
          <h3>{item.value}</h3>
        </article>
      ))}
    </div>
  )
}
