import { Box, Card, Typography } from '@mui/material'
import React from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { tournamentDetailsActions } from '../../redux/slices/tournamentDetails'
export default ({ user_frobots, s3_base_url }) => {
  const dispatch = useDispatch()
  const { setCurrentFrobot } = tournamentDetailsActions
  const { currentFrobot } = useSelector((store: any) => store.tournamentDetails)
  return (
    <Box sx={{ maxHeight: 500, overflowY: 'scroll' }}>
      {user_frobots?.map((user_frobot) => (
        <Card
          sx={{
            p: 2,
            m: 1,
            ':hover': {
              boxShadow: '0 0 0 2pt #00AB55',
              backgroundColor: `#1C3F3B`,
              cursor: 'pointer',
            },
            boxShadow:
              user_frobot.id === currentFrobot?.id
                ? '0 0 0 2pt #00AB55'
                : 'none',
            backgroundColor:
              user_frobot.id === currentFrobot?.id ? `#1C3F3B` : 'transparent',
          }}
          onClick={() => dispatch(setCurrentFrobot(user_frobot))}
        >
          <Box display={'flex'} alignItems={'center'} gap={1}>
            <Box
              component={'img'}
              width={100}
              height={100}
              src={`${s3_base_url}${user_frobot.avatar}`}
            />
            <Box>
              <Typography variant="h6">{user_frobot.name}</Typography>
              <Typography
                variant="caption"
                sx={{ maxHeight: 75, overflowY: 'hidden', display: 'block' }}
              >
                {user_frobot.bio}
              </Typography>
            </Box>
          </Box>
        </Card>
      ))}
    </Box>
  )
}
