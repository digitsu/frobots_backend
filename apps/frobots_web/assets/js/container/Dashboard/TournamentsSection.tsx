import { Box, Card, Grid, Typography } from '@mui/material'
import React from 'react'
import { SeverityPill } from '../../components/generic/SeverityPill'
export default ({ tournaments, imageBaseUrl, arenas }) => {
  const getArenaImage = (arena_id) => {
    return `${imageBaseUrl}${
      arenas.find(({ id }) => id === arena_id).image_url
    }`
  }
  const statuses = {
    progress: 'warning',
    open: 'secondary',
    completed: 'primary',
    cancelled: 'error',
  }
  return (
    <Box>
      <Card sx={{ p: 2 }}>
        {' '}
        <Typography variant="body1" sx={{ mb: 1 }}>
          Shatterdrom
        </Typography>{' '}
        <Grid container spacing={1}>
          {tournaments.map((tournament) => (
            <Grid
              item
              md={3}
              sx={{
                '&:hover': {
                  cursor: 'pointer',
                },
              }}
            >
              <a href={`/tournaments/${tournament.id}`}>
                <Box position={'relative'}>
                  <Box
                    component={'img'}
                    src={getArenaImage(tournament.arena_id)}
                  />
                  <Typography
                    variant="subtitle1"
                    textAlign={'center'}
                    sx={{ mt: 1 }}
                  >
                    {tournament.name}
                  </Typography>
                  <Box sx={{ textAlign: 'center' }}>
                    <SeverityPill
                      color={statuses[tournament.status] || 'success'}
                    >
                      {tournament.status}
                    </SeverityPill>
                  </Box>
                </Box>
              </a>
            </Grid>
          ))}
        </Grid>
      </Card>
    </Box>
  )
}
