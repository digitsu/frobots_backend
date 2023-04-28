import React from 'react'
import LiveMatches from './LiveMatches'
import PastMatches from './PastMatches'
import UpcomingMatches from './UpcomingMatches'

export default (props: any) => {
  const { match_status, s3_base_url, arenas } = props

  const imageList = arenas.reduce((result, arena) => {
    result[arena.id] = `${s3_base_url}/${arena.image_url}`

    return result
  }, {})

  return (
    <>
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
