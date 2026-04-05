import { styled } from 'styled-components'
import { Suspense, lazy } from 'react'

import { useWebNotifications } from 'hooks/useWebNotifications'
import { useCakepadBaseExperience } from 'views/Cakepad/hooks/useCakepadBaseExperience'

import GlobalSettings from './GlobalSettings'
import UserMenu from './UserMenu'

const Notifications = lazy(() => import('views/Notifications'))

const SharedComponentWithOutMenuWrapper = styled.div`
  display: none;
`

export const SharedComponentWithOutMenu: React.FC<React.PropsWithChildren> = ({ children }) => {
  const { enabled } = useWebNotifications()
  const isCakepadBaseRoute = useCakepadBaseExperience()

  return (
    <>
      <SharedComponentWithOutMenuWrapper>
        {!isCakepadBaseRoute && (
          <>
            <GlobalSettings />
            {enabled && (
              <Suspense fallback={null}>
                <Notifications />
              </Suspense>
            )}
          </>
        )}
        <UserMenu />
      </SharedComponentWithOutMenuWrapper>
      {children}
    </>
  )
}
