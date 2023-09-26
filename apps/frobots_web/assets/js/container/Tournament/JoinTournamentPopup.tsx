import React from 'react'
import {
  Modal,
  Card,
  CardHeader,
  CardContent,
  Box,
  Button,
  Typography,
  Fade,
  styled,
} from '@mui/material'
import TournamentFrobots from './TournamentFrobots'
import { useSelector } from 'react-redux'

const AnimatedModal = styled(Modal)`
  @keyframes fade-in-bottom {
    from {
      opacity: 0;
      transform: translateY(50px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }

  /* Other modal styles */
  opacity: 0;
  transform: translateY(50px);
  animation-name: fade-in-bottom;
  animation-duration: 0.3s;
  animation-fill-mode: forwards;
`

export default ({
  open,
  cancelAction,
  tournament_details,
  joinTournament,
  user_frobots,
  s3_base_url,
}) => {
  const { currentFrobot } = useSelector((store: any) => store.tournamentDetails)

  const joinTournamentSuccessHandler = () => {
    const frobot_id = currentFrobot.id
    const tournament_id = tournament_details.id
    joinTournament({ frobot_id, tournament_id })
    cancelAction()
  }

  return (
    <AnimatedModal open={open} onClose={cancelAction}>
      <Fade in={open}>
        <Card
          sx={{
            width: '50%',
            position: 'absolute',
            top: '50%',
            right: '50%',
            transform: `translate(50%,-50%)`,
            p: 3,
          }}
        >
          <CardHeader
            title={<Typography variant="h5">Choose Frobot</Typography>}
          />
          <CardContent>
            <TournamentFrobots
              user_frobots={user_frobots}
              s3_base_url={s3_base_url}
            />
          </CardContent>

          <Box
            mt={3}
            display={'flex'}
            justifyContent={'flex-end'}
            alignItems={'center'}
            gap={1}
          >
            <Button
              sx={{ minWidth: 100 }}
              onClick={cancelAction}
              variant="outlined"
              type="submit"
            >
              Cancel
            </Button>
            <Button
              onClick={joinTournamentSuccessHandler}
              sx={{ minWidth: 100 }}
              variant="contained"
              type="submit"
            >
              Confirm
            </Button>
          </Box>
        </Card>
      </Fade>
    </AnimatedModal>
  )
}
