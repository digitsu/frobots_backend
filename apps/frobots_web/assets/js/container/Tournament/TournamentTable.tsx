import React from 'react'
import {
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Paper,
  Typography,
  Box,
  Card,
} from '@mui/material'

export default ({ tableTitle, tableData, tableHeads, s3_base_url }) => {
  return (
    <Card sx={{ width: '100%', background: 'transparent' }}>
      <Typography variant="h6" sx={{ p: 2, color: '#fff' }}>
        {tableTitle}
      </Typography>
      <TableContainer sx={{ boxShadow: 'none' }} style={{ maxHeight: '350px' }}>
        <Table aria-label="simple table" stickyHeader>
          <TableHead sx={{ color: '#fff' }}>
            <TableRow>
              {tableHeads.map((label) => (
                <TableCell
                  align="left"
                  sx={{
                    color: '#fff !important',
                    borderColor: '#333D49',
                    backgroundColor: '#0f8d4d',
                    py: 1,
                  }}
                >
                  {label}
                </TableCell>
              ))}
            </TableRow>
          </TableHead>

          <TableBody>
            {tableData.map((row, index) => (
              <TableRow key={index}>
                <TableCell
                  sx={{
                    color: '#fff',
                    borderColor: '#333D49',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'flex-start',
                    gap: 1,
                  }}
                >
                  {row.avatar && (
                    <Box
                      component={'img'}
                      src={`${s3_base_url}${row.avatar}`}
                      width={15}
                      height={15}
                    />
                  )}
                  {row.frobot_name}
                </TableCell>
                <TableCell
                  sx={{ color: '#fff', borderColor: '#333D49' }}
                  align="left"
                >
                  {row.name || row?.email?.split('@')[0] || ''}
                </TableCell>
                <TableCell
                  sx={{ color: '#fff', borderColor: '#333D49' }}
                  align="left"
                >
                  {row.points}
                </TableCell>
                <TableCell
                  sx={{ color: '#fff', borderColor: '#333D49' }}
                  align="left"
                >
                  {row.wins}
                </TableCell>
                <TableCell
                  sx={{ color: '#fff', borderColor: '#333D49' }}
                  align="left"
                >
                  {row.loss}
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>
    </Card>
  )
}
