import { Box, Grid } from '@mui/material'
import React from 'react'
import TournamentTable from './TournamentTable'
export default ({ tournament_details, tournament_pools, s3_base_url }) => {
  return (
    <Grid container spacing={2}>
      {tournament_pools?.map((pool_details) => (
        <Grid item md={6}>
          <TournamentTable
            s3_base_url={s3_base_url}
            tableData={pool_details?.players || []}
            tableHeads={['Name', 'Player', 'Points', 'Wins', 'Loses']}
            tableTitle={`Pool ${pool_details.pool_name}`}
          />
        </Grid>
      ))}
    </Grid>
  )
}
