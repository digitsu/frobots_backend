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
} from '@mui/material'

type TableProps = {
  tableData: {
    id: number
    name: string
    player: string
    xp: string
    wins: number
    rank: number
    avatar?: string
  }[]
  tableTitle: string
  tableHeads: string[]
}

export default (props: TableProps) => {
  const { tableData, tableTitle, tableHeads } = props

  return (
    <>
      <Typography variant="body2" sx={{ p: 2, color: '#fff' }}>
        {tableTitle}
      </Typography>
      <TableContainer
        component={Paper}
        sx={{ backgroundColor: '#212B36', boxShadow: 'none' }}
        style={{ maxHeight: '350px' }}
      >
        <Table aria-label="simple table" stickyHeader>
          <TableHead sx={{ color: '#fff' }}>
            <TableRow>
              {tableHeads.map((label) => (
                <TableCell
                  align="left"
                  sx={{
                    color: '#818E9A !important',
                    borderColor: '#333D49',
                    backgroundColor: '#333D49',
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
                  {row.avatar && <Box component={'img'} src={row.avatar} />}
                  {row.name}
                </TableCell>
                <TableCell
                  sx={{ color: '#fff', borderColor: '#333D49' }}
                  align="left"
                >
                  {row.player}
                </TableCell>
                <TableCell
                  sx={{ color: '#fff', borderColor: '#333D49' }}
                  align="left"
                >
                  {row.xp}
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
                  {row.rank}
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>
    </>
  )
}
