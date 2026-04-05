import Head from 'next/head'
import Link from 'next/link'
import { useRouter } from 'next/router'
import { type CSSProperties, useEffect } from 'react'

const wrapStyle: CSSProperties = {
  minHeight: '100vh',
  display: 'grid',
  placeItems: 'center',
  padding: '32px 20px',
  background: '#f5f1e8',
  color: '#18110a',
  fontFamily: 'ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif',
}

const cardStyle: CSSProperties = {
  maxWidth: 720,
  width: '100%',
  background: '#fffaf0',
  border: '1px solid #d9c9ac',
  borderRadius: 20,
  padding: 32,
  boxShadow: '0 12px 32px rgba(56, 34, 8, 0.08)',
  display: 'grid',
  gap: 16,
}

const actionStyle: CSSProperties = {
  display: 'inline-flex',
  alignItems: 'center',
  justifyContent: 'center',
  padding: '14px 18px',
  borderRadius: 16,
  background: '#b8860b',
  color: '#fff8e8',
  textDecoration: 'none',
  fontWeight: 700,
}

export default function IndexPage() {
  const router = useRouter()

  useEffect(() => {
    router.replace('/swap').catch(() => {})
  }, [router])

  return (
    <>
      <Head>
        <title>Gold Chain DEX</title>
      </Head>
      <main style={wrapStyle}>
        <section style={cardStyle}>
          <div style={{ fontSize: 13, letterSpacing: 1.2, textTransform: 'uppercase', color: '#8a6d3b' }}>
            Gold Chain DEX
          </div>
          <h1 style={{ fontSize: 40, lineHeight: 1.05, margin: 0 }}>Swap GILT, GOLD, and DEX</h1>
          <p style={{ fontSize: 16, lineHeight: 1.6, margin: 0 }}>
            Redirecting to the live Gold Chain swap. If it does not move automatically, open the swap page directly.
          </p>
          <div>
            <Link href="/swap" style={actionStyle}>
              Open Swap
            </Link>
          </div>
        </section>
      </main>
    </>
  )
}
