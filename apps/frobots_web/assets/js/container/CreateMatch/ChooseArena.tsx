import { Box, Card, Grid, TextField, Typography } from '@mui/material'
import { createMatchActions } from '../../redux/slices/createMatch'
import React from 'react'
import { useSelector, useDispatch } from 'react-redux'
const maps = [
  {
    id: 1,
    label: 'Ember bowl',
    filter: 'none',
    subtitle: '10x10 Kms Large Map (6 Frobots)',
    src: '/images/arena_bg.png',
  },
  {
    id: 2,
    label: 'Silver bowl',
    filter: 'grayscale(1)',
    subtitle: '2x2 Kms Small Map (2 Frobots)',
    src: '/images/arena_bg.png',
  },
  {
    id: 3,
    label: 'Bronze bowl',
    filter: 'hue-rotate(45deg)',
    subtitle: '2x2 Kms Small Map (2 Frobots)',
    src: '/images/arena_bg.png',
  },
  {
    id: 4,
    label: 'Platinum bowl',
    filter: 'hue-rotate(300deg)',
    subtitle: '2x2 Kms Small Map (2 Frobots)',
    src: '/images/arena_bg.png',
  },
  {
    id: 5,
    label: 'Diamond bowl',
    filter: 'hue-rotate(175deg)',
    subtitle: '2x2 Kms Small Map (2 Frobots)',
    src: '/images/arena_bg.png',
  },
]

export default () => {
  const { mapSelected, minFrobots, maxFrobots } = useSelector(
    (store) => store.createMatch
  )
  const dispatch = useDispatch()
  const { setMap, setMinFrobots, setMaxFrobots } = createMatchActions
  const currentMap = mapSelected?.id
  return (
    <Box width={'60%'} m={'auto'} mt={10}>
      <Card>
        <Grid container>
          <Grid item lg={6}>
            <Box p={3} maxHeight={426} sx={{ overflowY: 'scroll' }}>
              {maps.map((map) => (
                <Box
                  sx={{
                    ':hover': {
                      boxShadow: '0 0 0 2pt #00AB55',
                      backgroundColor: `#1C3F3B`,
                    },
                    boxShadow:
                      currentMap === map.id ? '0 0 0 2pt #00AB55' : 'none',
                    backgroundColor:
                      currentMap === map.id ? `#1C3F3B` : 'transparent',
                  }}
                  onClick={() => dispatch(setMap(map))}
                >
                  <Box
                    key={map.id}
                    display={'flex'}
                    alignItems={'center'}
                    justifyContent={'flex-start'}
                    gap={3}
                    p={2}
                    sx={{ cursor: 'pointer' }}
                  >
                    <Box
                      component={'img'}
                      src={map.src}
                      width={64}
                      height={64}
                      sx={{ filter: map.filter }}
                    />
                    <Box>
                      <Typography variant="body2">{map.label}</Typography>
                      <Typography variant="caption">{map.subtitle}</Typography>
                    </Box>
                  </Box>
                </Box>
              ))}
            </Box>
          </Grid>
          <Grid item lg={6}>
            {currentMap ? (
              <Box
                component={'img'}
                src={mapSelected.src}
                sx={{ filter: mapSelected.filter }}
              />
            ) : (
              <Box
                display={'flex'}
                alignItems={'center'}
                justifyContent={'center'}
                height={'100%'}
              >
                <Typography variant="h5">No Map Selected</Typography>
              </Box>
            )}
          </Grid>
        </Grid>
      </Card>
      <Box
        display={'flex'}
        alignItems={'center'}
        justifyContent={'center'}
        py={3}
        width={'80%'}
        m={'auto'}
      >
        <Grid container spacing={2}>
          <Grid item sm={12} md={6} lg={6} xl={6}>
            <Box>
              <Typography variant="caption">Min Frobots Per Player</Typography>
              <TextField
                fullWidth
                type={'number'}
                value={minFrobots}
                onChange={(evt) => dispatch(setMinFrobots(evt.target.value))}
              />
            </Box>
          </Grid>
          <Grid item sm={12} md={6} lg={6} xl={6}>
            <Box>
              <Typography variant="caption">Max Frobots Per Player</Typography>
              <TextField
                fullWidth
                type={'number'}
                value={maxFrobots}
                onChange={(evt) => dispatch(setMaxFrobots(evt.target.value))}
              />
            </Box>
          </Grid>
        </Grid>
      </Box>
    </Box>
  )
}
