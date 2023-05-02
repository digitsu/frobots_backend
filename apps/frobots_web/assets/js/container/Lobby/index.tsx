import { Grid, Box, Button } from '@mui/material'
import React, { useEffect } from 'react'
import LobbyDetails from './LobbyDetails'
import LobbySlotContainer from './LobbySlotContainer'
import LobbySlotDetails from './LobbySlotDetails'
import { arenaLobbyActions } from '../../redux/slices/arenaLobbySlice'
import { useDispatch } from 'react-redux'
import { formatCounterTime, slotMapper } from '../../utils/util'

export default (props) => {
  const {
    match,
    templates,
    frobots,
    updateSlot,
    current_user_id,
    s3_base_url,
    user_id,
    time_left,
    startMatch,
  } = props
  const dispatch = useDispatch()
  const isHost = user_id === current_user_id
  const {
    setSlots,
    setProtobots,
    setUserFrobots,
    setS3BaseUrl,
    setCountdownTimer,
  } = arenaLobbyActions
  const {
    title,
    description,
    min_player_frobot,
    max_player_frobot,
    slots,
    arena,
    status
  } = match
  const sortedSlots = slotMapper(slots, current_user_id, user_id, s3_base_url)
  useEffect(() => {
    dispatch(setSlots(sortedSlots))
    dispatch(setCountdownTimer(formatCounterTime(time_left)))
  }, [])
  useEffect(() => {
    dispatch(setProtobots(templates))
    dispatch(setUserFrobots(frobots))
    dispatch(setS3BaseUrl(s3_base_url))
  }, [templates, frobots, s3_base_url])

  window.addEventListener(`phx:updatedmatchlist`, (e) => {
    const updated_matches = slotMapper(
      e.detail.match,
      current_user_id,
      user_id,
      s3_base_url
    )
    const frobots = e.detail.frobots
    dispatch(setUserFrobots(frobots))
    dispatch(setSlots(updated_matches))
  })

  const matchActionHandler = () => {
    if(status === 'done'){
      window.location.href = `/arena/${match.id}/results`
    }
  }
    const handleStartOrJoinMatch = () => {
      let action;
      //TODO 
      if (isHost) {
        action='start'
      }
      else
      {
         action = 'join'
      }
      window.location.href = `/arena/match/simulation?match_id=${match.id}&action=${action}`
    }

  return (
    <Box width={'90%'} m={'auto'}>
      <Grid container spacing={2}>
        <Grid md={12} width={'100%'}>
          <Box
            mt={4}
            display={'flex'}
            alignItems={'center'}
            justifyContent={'flex-end'}
          >
            <Button sx={{ px: 3 }} variant="contained" onClick={matchActionHandler}>
              {status !== 'done' ?(isHost ? 'Start Match' : 'Join') : 'View Results'}
            </Button>
          </Box>
        </Grid>
        <Grid item md={12} lg={12} sm={12} xs={12}>
          <LobbyDetails
            title={title}
            description={description}
            min_player_frobot={min_player_frobot}
            max_player_frobot={max_player_frobot}
            arena={arena}
            matchTime={match?.match_time}
          />
        </Grid>
        <Grid item md={12} lg={6} sm={12}>
          <LobbySlotContainer isHost={isHost} />
        </Grid>
        <Grid item md={12} lg={6} sm={12} xs={12}>
          <LobbySlotDetails updateSlot={updateSlot} isHost={isHost} />
        </Grid>
      </Grid>
    </Box>
  )
}
