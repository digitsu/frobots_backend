import React from 'react'
import { Box } from '@mui/material'
import Button from '../../components/generic/Button/Button'
import { FrobotListContainer } from './FrobotListContainer'

export default (props: any) => {
  const { frobotList, ...others } = props

  console.log("From container ",props)

  return (
    <Box>
      <Box
        display={'flex'}
        alignItems={'center'}
        justifyContent={'flex-end'}
        mt={4}
      >
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
          Buy Sparks
        </Button>
      </Box>
      <Box mt={4}>
        {' '}
        <FrobotListContainer frobotList={frobotList} />
      </Box>
    </Box>
  )
}
