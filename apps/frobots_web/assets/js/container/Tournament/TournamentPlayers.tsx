import { Grid, Box, Card, Typography, Button } from '@mui/material'
import React, { useState } from 'react'
import Popup from '../../components/Popup'
export default ({
  tournament_players,
  s3_base_url,
  user_frobots,
  tournament_id,
  unJoinTournament,
}) => {
  const currentUserFrobots = user_frobots.map(({ id }) => id)
  const [showUnjoinModal, setShowUnjoinModal] = useState(false)
  const [current_frobot_id, setCurrentFrobotId] = useState(null)
  const showUnjoinModalHandler = () => setShowUnjoinModal(true)
  return (
    <>
      <Grid container spacing={2}>
        {tournament_players?.map((tournament_player) => (
          <Grid item xs={12} md={6} key={tournament_player.frobot.id}>
            <Card sx={{ p: 2 }}>
              <Box
                display={'flex'}
                alignItems={'center'}
                gap={2}
                justifyContent={'space-between'}
              >
                <Box
                  display={'inline-flex'}
                  alignItems={'center'}
                  gap={2}
                  flex={3}
                >
                  <Box
                    component={'img'}
                    src={`${s3_base_url}${tournament_player.frobot.avatar}`}
                    width={50}
                    height={50}
                  />
                  <Typography variant="subtitle1">
                    {tournament_player.frobot.name}
                  </Typography>
                </Box>
                <Box flex={4}>
                  <Box
                    display={'flex'}
                    alignItems={'center'}
                    gap={1}
                    justifyContent={'flex-start'}
                  >
                    {' '}
                    <Typography variant="caption" sx={{ flex: 1 }}>
                      POINTS
                    </Typography>
                    <Typography variant="caption" sx={{ flex: 5 }}>
                      {tournament_player.stats.points}
                    </Typography>
                  </Box>
                  <Box
                    display={'flex'}
                    alignItems={'center'}
                    gap={1}
                    justifyContent={'flex-start'}
                  >
                    {' '}
                    <Typography variant="caption" sx={{ flex: 1 }}>
                      WINS
                    </Typography>
                    <Typography
                      variant="caption"
                      sx={{ flex: 5 }}
                      color={'#00AB55'}
                    >
                      {tournament_player.stats.wins}
                    </Typography>
                  </Box>
                  <Box
                    display={'flex'}
                    alignItems={'center'}
                    gap={1}
                    justifyContent={'flex-start'}
                  >
                    {' '}
                    <Typography variant="caption" sx={{ flex: 1 }}>
                      LOSS
                    </Typography>
                    <Typography
                      variant="caption"
                      sx={{ flex: 5 }}
                      color={'#FF4842'}
                    >
                      {tournament_player.stats.loss}
                    </Typography>
                  </Box>
                </Box>
                {currentUserFrobots.includes(tournament_player.frobot.id) && (
                  <Box flex={1}>
                    <Button
                      variant="outlined"
                      onClick={() => {
                        showUnjoinModalHandler()
                        setCurrentFrobotId(tournament_player.frobot.id)
                      }}
                    >
                      Remove
                    </Button>
                  </Box>
                )}
              </Box>
            </Card>
          </Grid>
        ))}
      </Grid>
      <Popup
        open={showUnjoinModal}
        successLabel={'Confirm'}
        cancelLabel={'Cancel'}
        description={
          'Are you sure you want to remove this frobot from the tournament?'
        }
        label={'Warning'}
        successAction={() =>
          unJoinTournament({
            tournament_id,
            frobot_id: current_frobot_id,
          })
        }
        cancelAction={() => setShowUnjoinModal(false)}
      />
    </>
  )
}
