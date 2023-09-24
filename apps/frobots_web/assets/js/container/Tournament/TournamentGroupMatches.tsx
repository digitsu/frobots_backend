import { Box, Grid } from '@mui/material'
import React from 'react'
import { tournamentPool1, tournamentPool2 } from '../../mock/tournament'
import TournamentTable from './TournamentTable'
export default ({ tournament_details }) => {
  return (
    <Grid container spacing={2}>
      <Grid item md={6}>
        <TournamentTable
          tableData={tournamentPool1}
          tableHeads={['Name', 'Player', 'XP', 'Wins', 'Loses']}
          tableTitle="Pool A"
        />
      </Grid>
      <Grid item md={6}>
        <TournamentTable
          tableData={tournamentPool2}
          tableHeads={['Name', 'Player', 'XP', 'Wins', 'Loses']}
          tableTitle="Pool B"
        />
      </Grid>
      <Grid item md={6}>
        <TournamentTable
          tableData={tournamentPool1}
          tableHeads={['Name', 'Player', 'XP', 'Wins', 'Loses']}
          tableTitle="Pool C"
        />
      </Grid>
      <Grid item md={6}>
        <TournamentTable
          tableData={tournamentPool2}
          tableHeads={['Name', 'Player', 'XP', 'Wins', 'Loses']}
          tableTitle="Pool D"
        />
      </Grid>
    </Grid>
  )
}
