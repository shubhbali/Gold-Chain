import type { PropsWithChildren } from 'react'

type GoldCardProps = PropsWithChildren<{
  title: string
  subtitle?: string
}>

export function GoldCard({ title, subtitle, children }: GoldCardProps) {
  return (
    <article className="gold-card">
      {subtitle ? <p className="card-subtitle">{subtitle}</p> : null}
      <h3>{title}</h3>
      {children}
    </article>
  )
}
