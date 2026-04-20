type PageIntroProps = {
  eyebrow: string
  title: string
  body: string
}

export function PageIntro({ eyebrow, title, body }: PageIntroProps) {
  return (
    <section className="page-intro">
      <p className="eyebrow">{eyebrow}</p>
      <h1>{title}</h1>
      <p className="page-intro-copy">{body}</p>
    </section>
  )
}
