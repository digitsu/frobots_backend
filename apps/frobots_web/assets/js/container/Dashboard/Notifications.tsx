import React from 'react'
import { Divider, Typography, Box, Card } from '@mui/material'
import ViewMore from '../../components/generic/Button/ViewMore'

const notifications = [
  {
    name: 'Upcoming Match for XTron on 03rd March 2023',
    details: ' 11:45:00 28th February 2023 ',
  },
  {
    name: 'Gained 5000 XP for Match #7AE7B2 for XTron',
    details: ' 11:45:00 28th February 2023 ',
  },
  {
    name: 'Upcoming Match for XTron on 03rd March 2023',
    details: ' 11:45:00 28th February 2023 ',
  },
  {
    name: 'Frobot Health Crtical New Horizon',
    details: ' 11:45:00 28th February 2023 ',
  },
  {
    name: 'Gained 2000 Kudos for Match #7AE7B2 for XTron',
    details: ' 11:45:00 28th February 2023 ',
  },
]
export default () => {
  return (
    <Card sx={{ p: 3, pb: 0 }}>
      <Typography sx={{ pl: 0, mt: 1, mb: 2 }} variant={'body1'}>
        Notifications
      </Typography>
      <Divider sx={{ backgroundColor: '#333D49', my: 2 }} />
      <Box
        flexDirection={'column'}
        display={'flex'}
        maxHeight={400}
        overflow={'scroll'}
      >
        {notifications.map((playerDetails) => (
          <Box>
            <Typography variant="subtitle2" sx={{ pt: 0 }}>
              {playerDetails.name}
            </Typography>
            <Typography variant="caption" sx={{ color: 'lightgray' }}>
              {playerDetails.details}
            </Typography>
            <Divider sx={{ backgroundColor: '#333D49', my: 2 }} />
          </Box>
        ))}
      </Box>
      <Box px={2} py={1}>
        <ViewMore label={'View More'} />
      </Box>
    </Card>
  )
}
