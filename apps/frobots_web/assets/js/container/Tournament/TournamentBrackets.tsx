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
/* export default ({ tournament_knockouts }) => {
  const matches = tournament_knockouts.map(
    ({ pool_name, players, matches }) => ({
      title: pool_name,
      seeds: matches.map((match, index) => ({
        id: index,
        date: new Date(match.match_time).toDateString(),
        teams: match.frobots.map((frobot) => ({
          name: players.find(({ id }) => id === frobot)?.frobot_name,
        })),
      })),
    })
  )
  return (
    <>
      <Bracket rounds={matches} renderSeedComponent={CustomSeed} />
    </>
  )
} */

export default ({ tournament_knockouts }) => {
  const matches = tournament_knockouts.map(({ pool_name, players, matches }) => ({
    title: pool_name,
    seeds: matches.map((match, index) => ({
      id: index,
      date: new Date(match.match_time).toDateString(),
      teams: match.frobots.map((frobot) => {
        const player = players.find(({ id }) => id === frobot);
        const isWinner = match.battlelog.winners.includes(frobot);
        const playerName = isWinner ? `${player?.frobot_name} - Winner` : player?.frobot_name;

        return {
          name: playerName,
        };
      }),
    })),
  }));

  return (
    <>
      <Bracket rounds={matches} renderSeedComponent={CustomSeed} />
    </>
  );
};

