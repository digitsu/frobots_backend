import { Box, Card, Grid, TextField, Typography } from '@mui/material'
import React from 'react'
import { useSelector, useDispatch } from 'react-redux'

export default ({ arenas, s3_base_url, setMap, mapSelected }) => {
  const { minFrobots, maxFrobots } = useSelector((store) => store.createMatch)
  const dispatch = useDispatch()
  const currentMap = mapSelected?.id
  return (
    <Box width={'60%'} m={'auto'} mt={10}>
      <Card>
        <Grid container>
          <Grid item sm={12} md={12} lg={6}>
            <Box p={3} maxHeight={426} sx={{ overflowY: 'scroll' }}>
              {arenas.map((map) => (
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
                      src={`${s3_base_url}${map.image_url}`}
                      width={64}
                      height={64}
                    />
                    <Box>
                      <Typography variant="subtitle1">
                        {map?.arena_name}
                      </Typography>
                      <Typography variant="caption">
                        {map?.arena_description}
                      </Typography>
                    </Box>
                  </Box>
                </Box>
              ))}
            </Box>
          </Grid>
          <Grid item sm={12} md={12} lg={6}>
            {currentMap ? (
              <Box
                component={'img'}
                src={`${s3_base_url}${mapSelected.image_url}`}
                sx={{ height: '100%' }}
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
      {/* <Box
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
      </Box> */}
    </Box>
  )
}
