import { useState } from 'react'
import { AnimatePresence, motion } from 'framer-motion'
import { Link, NavLink, Outlet, useLocation } from 'react-router-dom'
import { navItems } from '../data/siteData'

export function SiteLayout() {
  const [open, setOpen] = useState(false)
  const location = useLocation()

  return (
    <div className="site-shell">
      <div className="bg-orb orb-one" />
      <div className="bg-orb orb-two" />
      <div className="noise-layer" />

      <header className="topbar">
        <NavLink className="brand" to="/">
          <span className="brand-badge">GC</span>
          <span className="brand-word">GiltChain</span>
        </NavLink>

        <button
          className="menu-toggle"
          onClick={() => setOpen((v) => !v)}
          aria-label="Toggle menu"
          aria-expanded={open}
        >
          Menu
        </button>

        <nav className={`nav-links ${open ? 'open' : ''}`}>
          {navItems.map((item) => (
            <NavLink
              key={item.href}
              to={item.href}
              className={({ isActive }) => (isActive ? 'active' : undefined)}
              onClick={() => setOpen(false)}
            >
              {item.label}
            </NavLink>
          ))}
          <Link className="launch-cta" to="/bridge" onClick={() => setOpen(false)}>
            Launch Bridge
          </Link>
        </nav>
      </header>

      <main className="main-wrap">
        <AnimatePresence mode="wait">
          <motion.div
            key={location.pathname}
            className="route-stage"
            initial={{ opacity: 0, y: 16 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -16 }}
            transition={{ duration: 0.34, ease: [0.2, 0.8, 0.2, 1] }}
          >
            <Outlet />
          </motion.div>
        </AnimatePresence>
      </main>

      <footer className="footer">
        <div>
          <p className="footer-brand">GiltChain</p>
          <p className="footer-copy">Production blockchain for GILT, GOLD, and bridge-backed gold assets.</p>
        </div>
        <div className="footer-links">
          <Link to="/tokens">Tokens</Link>
          <Link to="/network">Network</Link>
          <Link to="/bridge">Bridge</Link>
          <Link to="/validators">Validators</Link>
          <Link to="/developers">Developers</Link>
        </div>
      </footer>
    </div>
  )
}
