import React, { ChangeEvent, FC, useCallback, useRef, useState } from 'react'
import PropTypes from 'prop-types'
import { Search } from '@mui/icons-material'
import {
  Box,
  Button,
  InputAdornment,
  OutlinedInput,
  SvgIcon,
  Tab,
  Tabs,
} from '@mui/material'

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
  onQueryChange?: (value?: string) => void
}

export const MatchListSearch: FC<MatchListSearchProps> = (props) => {
  const { onTabChange, onQueryChange } = props
  const queryRef = useRef<HTMLInputElement | null>(null)
  const [currentTab, setCurrentTab] = useState<TabValue>('all')

  const handleTabsChange = useCallback(
    (event: ChangeEvent<{}>, value: TabValue): void => {
      setCurrentTab(value)
      onTabChange?.(value === 'all' ? undefined : value)
    },
    []
  )

  const handleQueryChange = useCallback((): void => {
    onQueryChange?.(queryRef.current?.value)
  }, [])

  return (
    <>
      <Box
        display="flex"
        justifyContent={'space-between'}
        alignItems={'center'}
        width="100%"
      >
        <Box>
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
        <Box>
          <a href={'/arena/create'}>
            <Button
              sx={{
                textTransform: 'capitalize',
                backgroundColor: 'transparent',
                color: '#00AB55',
                borderColor: '#00AB55',
                '&:hover': {
                  borderColor: '#13D273',
                },
              }}
              variant="outlined"
            >
              Create Match
            </Button>
          </a>
        </Box>
      </Box>

      <Box mt={3} component="form" alignItems={'center'} sx={{ flexGrow: 1 }}>
        <OutlinedInput
          defaultValue=""
          fullWidth
          rows={1}
          onChange={handleQueryChange}
          inputProps={{ ref: queryRef }}
          sx={{
            borderRadius: 2,
            color: '#fff',
            border: '1px solid #637381',
            '&:hover': {
              borderColor: '#637381',
            },
            '&:active': {
              borderColor: '#637381',
            },
          }}
          placeholder="Search.."
          startAdornment={
            <InputAdornment position="start">
              <SvgIcon>
                <Search
                  sx={{
                    color: '#637381',
                  }}
                />
              </SvgIcon>
            </InputAdornment>
          }
        />
      </Box>
    </>
  )
}

MatchListSearch.propTypes = {
  onTabChange: PropTypes.func,
  onQueryChange: PropTypes.func,
}
