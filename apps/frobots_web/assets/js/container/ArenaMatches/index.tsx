import React from 'react'
import LiveMatches from './LiveMatches'
import PastMatches from './PastMatches'
import UpcomingMatches from './UpcomingMatches'
import { Box, Typography } from '@mui/material'

export default (props: any) => {
  const { match_status, s3_base_url, arenas } = props

  const imageList = arenas.reduce((result, arena) => {
    result[arena.id] = `${s3_base_url}/${arena.image_url}`

    return result
  }, {})

  const totalMatches = [
    ...props.host_matches,
    ...props.joined_matches,
    ...props.watch_matches,
  ].length

  return (
    <>
      {totalMatches === 0 && (
        <Box
          display="flex"
          width={'100%'}
          minHeight={'250px'}
          maxHeight={'250px'}
          alignItems="center"
          justifyContent="center"
        >
          <Typography variant={'subtitle1'}>{'No Matches Found'}</Typography>
        </Box>
      )}
      {match_status === 'done' && (
        <PastMatches imageList={imageList} {...props} />
      )}
      {match_status === 'pending' && (
        <UpcomingMatches imageList={imageList} {...props} />
      )}
      {match_status === 'running' && (
        <LiveMatches imageList={imageList} {...props} />
      )}
    </>
  )
}
