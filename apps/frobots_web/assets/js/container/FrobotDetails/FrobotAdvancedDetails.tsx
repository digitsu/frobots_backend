import { Grid, Card, Box, Typography, Table, TableBody, TableRow, TableCell, Button } from "@mui/material"
import React from "react"

const advanceDetails = {
  ranking: '12345',
  mechTankHealth: '60',
  isRepair: true,
  speed: '20km/hr',
  hp: '120',
  wins: '132/200',
  qdosEarned: '$235790',
}

export default ()=>{
return <Grid item xs={12} sm={4}>
  <Card
    sx={{
      bgcolor: '#212B36',
      borderRadius: 4,
      paddingTop: '100%',
      position: 'relative',
      '@media (max-width: 600px)': {
        paddingTop: '50%',
      },
    }}
  >
    <Box
      sx={{
        position: 'absolute',
        top: 0,
        bottom: 0,
        left: 0,
        right: 0,
      }}
    >
      <Typography px={3} pt={4} variant="h4" component="h2" gutterBottom>
        297050 XP
      </Typography>

      <Table>
        <TableBody>
          <TableRow>
            <TableCell
              style={{ fontWeight: 'bold' }}
              variant="body"
              component="th"
              scope="row"
            >
              Ranking
            </TableCell>
            <TableCell style={{ fontWeight: 'bold' }} align="center">
              :
            </TableCell>
            <TableCell style={{ fontWeight: 'bold' }} align="right">
              {advanceDetails.ranking}
            </TableCell>
          </TableRow>
          <TableRow>
            <TableCell
              style={{ fontWeight: 'bold' }}
              component="th"
              scope="row"
            >
              Mech/Tank Health{' '}
              {advanceDetails.isRepair && (
                <Button
                  color="warning"
                  size="small"
                  style={{ fontSize: '12px', padding: '4px 8px' }}
                >
                  Repair
                </Button>
              )}
            </TableCell>
            <TableCell style={{ fontWeight: 'bold' }} align="center">
              :
            </TableCell>
            <TableCell style={{ fontWeight: 'bold' }} align="right">
              {advanceDetails.mechTankHealth}
            </TableCell>
          </TableRow>
          <TableRow>
            <TableCell
              style={{ fontWeight: 'bold' }}
              component="th"
              scope="row"
            >
              Speed
            </TableCell>
            <TableCell style={{ fontWeight: 'bold' }} align="center">
              :
            </TableCell>
            <TableCell style={{ fontWeight: 'bold' }} align="right">
              {advanceDetails.speed}
            </TableCell>
          </TableRow>
          <TableRow>
            <TableCell
              style={{ fontWeight: 'bold' }}
              component="th"
              scope="row"
            >
              HP
            </TableCell>
            <TableCell style={{ fontWeight: 'bold' }} align="center">
              :
            </TableCell>
            <TableCell style={{ fontWeight: 'bold' }} align="right">
              {advanceDetails.hp}
            </TableCell>
          </TableRow>
          <TableRow>
            <TableCell
              style={{ fontWeight: 'bold' }}
              component="th"
              scope="row"
            >
              Wins
            </TableCell>
            <TableCell style={{ fontWeight: 'bold' }} align="center">
              :
            </TableCell>
            <TableCell style={{ fontWeight: 'bold' }} align="right">
              {advanceDetails.wins}
            </TableCell>
          </TableRow>
          <TableRow>
            <TableCell
              style={{ fontWeight: 'bold' }}
              component="th"
              scope="row"
            >
              QDOS Earned
            </TableCell>
            <TableCell style={{ fontWeight: 'bold' }} align="center">
              :
            </TableCell>
            <TableCell style={{ fontWeight: 'bold' }} align="right">
              {advanceDetails.qdosEarned}
            </TableCell>
          </TableRow>
        </TableBody>
      </Table>
      <Box px={4} mt={6} mb={10}>
        <Button variant="outlined" fullWidth sx={{ py: 1, mb: 10 }}>
          View Brain Code
        </Button>
      </Box>
    </Box>
  </Card>
</Grid>
}
