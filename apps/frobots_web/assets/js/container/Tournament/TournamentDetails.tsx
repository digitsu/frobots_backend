import { Box, Container, Tab, Tabs, Typography } from '@mui/material'
import React, { useCallback, useEffect } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { tournamentDetailsActions } from '../../redux/slices/tournamentDetails'
import TournamentBanner from './TournamentBanner'
import TournamentBrackets from './TournamentBrackets'
import TournamentGroupMatches from './TournamentGroupMatches'
import TournamentMatches from './TournamentMatches'
import TournamentPlayers from './TournamentPlayers'

export default ({
  s3_base_url,
  tournament_details,
  user_frobots,
  joinTournament,
  unJoinTournament,
  all_user_frobots,
  tournament_pools,
  tournament_knockouts,
}) => {
  const dispatch = useDispatch()
  const { tournamentPlayers } = useSelector((store) => store.tournamentDetails)
  const tabs = ['Matches', 'Group Stage', 'Finals', 'Players']
  const [tabIndex, setTabIndex] = React.useState(0)
  const handleChange = (event: React.SyntheticEvent, newValue: number) => {
    setTabIndex(newValue)
  }

  function a11yProps(index: number) {
    return {
      id: `simple-tab-${index}`,
      'aria-controls': `simple-tabpanel-${index}`,
    }
  }

  const fetchUpdatedTournamentPlayers = useCallback((e) => {
    dispatch(
      tournamentDetailsActions.setTournamentPlayers(e.detail.tournament_players)
    )
  }, [])
  useEffect(() => {
    window.addEventListener(
      `phx:tournamentplayers`,
      fetchUpdatedTournamentPlayers
    )
    return () => {
      window.removeEventListener(
        `phx:tournamentplayers`,
        fetchUpdatedTournamentPlayers
      )
    }
  }, [])

  useEffect(() => {
    dispatch(
      tournamentDetailsActions.setTournamentPlayers(
        tournament_details.tournament_players
      )
    )
  }, [])

  return (
    <Box width={'90%'} m={'auto'}>
      <Container sx={{ maxWidth: 1440, p: '0 !important', m: 'auto' }}>
        <TournamentBanner
          tournament_details={tournament_details}
          s3_base_url={s3_base_url}
          user_frobots={user_frobots}
          joinTournament={joinTournament}
        />
        <Box mt={2}>
          <Tabs
            value={tabIndex}
            onChange={handleChange}
            textColor={'inherit'}
            TabIndicatorProps={{
              sx: {
                backgroundColor: 'rgb(15 141 77)',
              },
            }}
          >
            {tabs.map((tab, index) => (
              <Tab
                key={tab}
                sx={{ color: '#fff' }}
                label={tab}
                {...a11yProps(index)}
              />
            ))}
          </Tabs>
          <Box my={4}>
            {tabIndex === 3 && (
              <TournamentPlayers
                tournament_id={tournament_details.id}
                tournament_players={tournamentPlayers}
                s3_base_url={s3_base_url}
                user_frobots={all_user_frobots}
                unJoinTournament={unJoinTournament}
              />
            )}
          </Box>
          <Box my={4}>
            {tabIndex === 2 && (
              <TournamentBrackets tournament_knockouts={tournament_knockouts} />
            )}
          </Box>
          <Box my={4}>
            {tabIndex === 1 && (
              <TournamentGroupMatches
                tournament_details={tournament_details}
                tournament_pools={tournament_pools}
                s3_base_url={s3_base_url}
              />
            )}
          </Box>
          <Box my={4}>
            {tabIndex === 0 && (
              <TournamentMatches
                tournament_details={tournament_details}
                s3_base_url={s3_base_url}
              />
            )}
          </Box>
        </Box>
      </Container>
    </Box>
  )
}
