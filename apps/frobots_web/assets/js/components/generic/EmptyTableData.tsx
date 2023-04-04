import React from 'react'
import { TableCell, TableRow, Typography, Box } from '@mui/material'

interface EmptyDataProps {
  defaultText?: string
}

export default (props: EmptyDataProps) => (
  <TableRow>
    <TableCell colSpan={8} sx={{ textAlign: 'center' }}>
      <Box
        display="flex"
        width={'100%'}
        minHeight={'250px'}
        maxHeight={'250px'}
        alignItems="center"
        justifyContent="center"
      >
        <Typography variant={'subtitle1'}>
          {props.defaultText || 'No records Found'}
        </Typography>
      </Box>
    </TableCell>
  </TableRow>
)
