import { Card, Typography, Box, Grid } from '@mui/material'
import moment from 'moment'
import React from 'react'
import { useSelector } from 'react-redux'
export default ({
  title,
  description,
  arena,
  matchTime,
}) => {
  const { s3Url } = useSelector((store) => store.arenaLobby)
  return (
    <Card sx={{ p: 2, px: 4, width: '100%', boxShadow: 'none' }}>
      <Grid container justifyContent={'space-between'} alignItems={'center'}>
        <Grid item xs={12} sm={8} md={9} lg={10}>
          <Box>
            <Box mb={4}>
              <Typography variant="h6">{title}</Typography>
            </Box>
            <Box mb={4}>
              <Typography variant="body1">About</Typography>
              <Typography variant="caption">{description || '-'}</Typography>
            </Box>
            {/* <Box display={'flex'} gap={4} mb={2}>
              <Box display={'inline-flex'} gap={1}>
                <Typography variant="body2">Min Frobots Per Player:</Typography>
                <Typography>{min_player_frobot}</Typography>
              </Box>
              <Box display={'inline-flex'} gap={1}>
                <Typography variant="body2">Max Frobots Per Player:</Typography>
                <Typography>{max_player_frobot}</Typography>
              </Box>
            </Box> */}
            <Box>
              <Box display={'inline-flex'} gap={1} mb={2}>
                <Typography variant="body2">Match Time:</Typography>
                <Typography>
                  {moment(matchTime).format('DD-MMM-YYYY HH:mm')}
                </Typography>
              </Box>
            </Box>
          </Box>
        </Grid>
        <Grid item xs={12} sm={4} md={3} lg={2}>
          <Box src={`${s3Url}${arena?.image_url}`} component={'img'} />
        </Grid>
      </Grid>
    </Card>
  )
}
