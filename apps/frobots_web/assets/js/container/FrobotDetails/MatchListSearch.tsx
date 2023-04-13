import React, { ChangeEvent, FC, useCallback, useState } from 'react'
import PropTypes from 'prop-types'
import { Box, Tab, Tabs } from '@mui/material'

type TabValue = 'all' | 'pending' | 'running' | 'done'

interface TabOption {
  label: string
  value: TabValue
}

const tabs: TabOption[] = [
  {
    label: 'All',
    value: 'all',
  },
  {
    label: 'Upcoming',
    value: 'pending',
  },
  {
    label: 'Live',
    value: 'running',
  },
  {
    label: 'Completed',
    value: 'done',
  },
]

interface MatchListSearchProps {
  onTabChange?: (value?: string) => void
}

export const MatchListSearch: FC<MatchListSearchProps> = (props) => {
  const { onTabChange } = props
  const [currentTab, setCurrentTab] = useState<TabValue>('all')

  const handleTabsChange = useCallback(
    (event: ChangeEvent<{}>, value: TabValue): void => {
      setCurrentTab(value)
      onTabChange?.(value === 'all' ? undefined : value)
    },
    []
  )

  return (
    <>
      <Box
        display="flex"
        justifyContent={'space-between'}
        alignItems={'left'}
        width="100%"
      >
        <Tabs
          indicatorColor="primary"
          onChange={handleTabsChange}
          scrollButtons="auto"
          sx={{ px: 3 }}
          textColor="primary"
          value={currentTab}
          variant="scrollable"
          color="#FFFF"
        >
          {tabs.map((tab) => (
            <Tab key={tab.value} label={tab.label} value={tab.value} />
          ))}
        </Tabs>
      </Box>
    </>
  )
}

MatchListSearch.propTypes = {
  onTabChange: PropTypes.func,
}
