import React from 'react'
import { Box, Typography } from '@mui/material'
import {
  Bracket,
  Seed,
  SeedItem,
  SeedTeam,
  IRenderSeedProps,
} from 'react-brackets'
import { matches } from '../../mock/tournament'
const CustomSeed = ({
  seed,
  breakpoint,
  roundIndex,
  seedIndex,
}: IRenderSeedProps) => {
  // breakpoint passed to Bracket component
  // to check if mobile view is triggered or not

  // mobileBreakpoint is required to be passed down to a seed
  return (
    <Seed mobileBreakpoint={breakpoint} style={{ fontSize: 14 }}>
      <SeedItem style={{ outline: '1px solid #00AB55' }}>
        <div>
          <SeedTeam style={{ color: '#fff' }}>
            <Typography variant="caption">
              {seed.teams[0]?.name || 'NO TEAM '}
            </Typography>
          </SeedTeam>
          <SeedTeam style={{ color: '#fff' }}>
            <Typography variant="caption">
              {seed.teams[1]?.name || 'NO TEAM '}
            </Typography>
          </SeedTeam>
        </div>
      </SeedItem>
    </Seed>
  )
}
export default ({ tournament_details }) => {
  return (
    <>
      <Bracket rounds={matches} renderSeedComponent={CustomSeed} />
    </>
  )
}
