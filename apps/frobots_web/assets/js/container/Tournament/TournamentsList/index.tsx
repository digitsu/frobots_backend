import { Box, Container, Grid, Button, Stack } from '@mui/material'
import React from 'react'
import TournamentsSection from '../../Dashboard/TournamentsSection'

export default ({ tournaments, s3_base_url, arenas, isAdmin }) => {
  return (
    <Box width={'90%'} m={'auto'}>
      <Container sx={{ maxWidth: 1440, p: '0 !important', m: 'auto' }}>
        <Stack
          direction={'row'}
          alignItems={'center'}
          justifyContent={'flex-end'}
          mb={2}
        >
          {isAdmin && (
            <a href={'/tournaments/create'}>
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
                Create Tournament
              </Button>
            </a>
          )}
        </Stack>
        <Grid container spacing={2}>
          {tournaments.length > 0 && (
            <Grid item lg={12} md={12} sm={12} xs={12}>
              <TournamentsSection
                tournaments={tournaments}
                imageBaseUrl={s3_base_url}
                arenas={arenas}
              />
            </Grid>
          )}
        </Grid>
      </Container>
    </Box>
  )
}
