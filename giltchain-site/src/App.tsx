import { Navigate, Route, Routes } from 'react-router-dom'
import { SiteLayout } from './layout/SiteLayout'
import { BridgePage } from './pages/BridgePage'
import { DevelopersPage } from './pages/DevelopersPage'
import { HomePage } from './pages/HomePage'
import { MigrationPage } from './pages/MigrationPage'
import { NetworkPage } from './pages/NetworkPage'
import { SecurityPage } from './pages/SecurityPage'
import { StatusPage } from './pages/StatusPage'
import { TokensPage } from './pages/TokensPage'
import { ValidatorsPage } from './pages/ValidatorsPage'

export default function App() {
  return (
    <Routes>
      <Route element={<SiteLayout />}>
        <Route path="/" element={<HomePage />} />
        <Route path="/tokens" element={<TokensPage />} />
        <Route path="/network" element={<NetworkPage />} />
        <Route path="/bridge" element={<BridgePage />} />
        <Route path="/migration" element={<MigrationPage />} />
        <Route path="/validators" element={<ValidatorsPage />} />
        <Route path="/developers" element={<DevelopersPage />} />
        <Route path="/security" element={<SecurityPage />} />
        <Route path="/status" element={<StatusPage />} />
        <Route path="*" element={<Navigate to="/" replace />} />
      </Route>
    </Routes>
  )
}
