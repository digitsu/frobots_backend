import React, { type FC, type ReactNode } from 'react'
import { styled } from '@mui/material/styles'
import { sections } from '../config'
import { SideNav } from './side-nav'

const SIDE_NAV_WIDTH: number = 280

interface LayoutProps {
  children: ReactNode
  pathname: string
}

const LayoutRoot = styled('div')({
  display: 'flex',
  flex: '1 1 auto',
  maxWidth: '100%',
  paddingLeft: SIDE_NAV_WIDTH,
})

const LayoutContainer = styled('div')({
  display: 'flex',
  flex: '1 1 auto',
  flexDirection: 'column',
  width: '100%',
})

export const Layout: FC<LayoutProps> = (props) => {
  const { children, pathname } = props

  return (
    <>
      <SideNav sections={sections} pathname={pathname} />
      <LayoutRoot>
        <LayoutContainer>{children}</LayoutContainer>
      </LayoutRoot>
    </>
  )
}
