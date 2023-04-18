import React, { type FC } from 'react'
import PropTypes from 'prop-types'
import { Drawer, Stack } from '@mui/material'
import type { Section } from '../config'
import { Scrollbar } from '../../../components/scrollbar'
import { SideNavSection } from './side-nav-section'

const TOP_NAV_HEIGHT: number = 80
const SIDE_NAV_WIDTH: number = 280

interface SideNavProps {
  sections?: Section[]
  pathname: string
}

export const SideNav: FC<SideNavProps> = (props) => {
  const { sections = [], pathname } = props

  return (
    <Drawer
      anchor="left"
      open
      PaperProps={{
        sx: {
          height: `calc(100% - ${TOP_NAV_HEIGHT}px)`,
          top: `${TOP_NAV_HEIGHT}px`,
          width: `${SIDE_NAV_WIDTH}px`,
          zIndex: 100,
          backgroundColor: '#161c24',
        },
      }}
      variant="permanent"
    >
      <Scrollbar
        sx={{
          height: '100%',
          '& .simplebar-content': {
            height: '100%',
          },
        }}
      >
        <Stack component="nav" spacing={3} sx={{ p: 2 }}>
          {sections.map((section, index) => (
            <SideNavSection
              items={section.items}
              key={index}
              pathname={pathname}
              subheader={section.subheader}
            />
          ))}
        </Stack>
      </Scrollbar>
    </Drawer>
  )
}

SideNav.propTypes = {
  sections: PropTypes.array,
}
