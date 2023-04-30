import { Box, Card, Grid, Typography } from '@mui/material'
import React from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { arenaLobbyActions } from '../../redux/slices/arenaLobbySlice'

export default ({ isHost }) => {
  const { slots, currentActiveSlot } = useSelector((store) => store.arenaLobby)
  const { setCurrentActiveSlot } = arenaLobbyActions
  const dispatch = useDispatch()
  const slotId = currentActiveSlot?.id
  return (
    <Box sx={{ height: '100%' }}>
      <Card sx={{ height: '100%', pb: 4 }}>
        <Box pt={9} px={2} pb={0}>
          <Grid container spacing={1}>
            {slots.map((slot) => (
              <Grid item xl={4} lg={4} md={3} sm={4} xs={6}>
                <Box
                  display={'flex'}
                  alignItems={'center'}
                  flexDirection={'column'}
                >
                  <Box my={1}>
                    <Typography variant="subtitle2">{slot.name}</Typography>
                  </Box>
                  <Box
                    sx={{
                      borderRadius: 4,
                      px: 5,
                      py: 8,
                      ':hover': {
                        boxShadow: '0 0 0 2pt #00AB55',
                        backgroundColor: `#1C3F3B`,
                      },
                      cursor: 'pointer',
                      boxShadow:
                        slotId === slot.id ? '0 0 0 2pt #00AB55' : 'none',
                      backgroundColor:
                        slotId === slot.id ? `#1C3F3B` : '#333D49',
                    }}
                    onClick={() => dispatch(setCurrentActiveSlot(slot))}
                  >
                    <Box
                      component={'img'}
                      src={slot.url}
                      m={'auto'}
                      width={76}
                      height={82}
                      sx={{
                        filter: isHost
                          ? 'none'
                          : slot.frobot_user_id === slot.current_user_id ||
                            slot.type === 'open'
                          ? 'none'
                          : `opacity(0.5)`,
                      }}
                    />
                  </Box>
                </Box>
              </Grid>
            ))}
          </Grid>
        </Box>
      </Card>
    </Box>
  )
}
