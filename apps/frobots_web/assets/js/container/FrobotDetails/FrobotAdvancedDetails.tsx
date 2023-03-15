import { Grid, Card, Box, Typography, Table, TableBody, TableRow, TableCell, Button } from "@mui/material"
import React from "react"
import BattlesTable from "./BattlesTable"

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
return (
  <Grid item lg={4} md={6} sm={6} xs={12}>
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
        <Typography sx={{ pl: 4, pt: 2, mt: 1, mb: 2 }} variant={'h5'}>
          2780451 XP
        </Typography>
        <Box>
          <Grid pl={4} container spacing={2}>
            <Grid item >
              <Box  textAlign="left">
                <Typography my={2.2} variant="subtitle2">
                  Ranking
                </Typography>
                <Typography my={2.2} variant="subtitle2">
                  Mech/Tank Health
                </Typography>
                <Typography my={2.2} variant="subtitle2">
                  Speed
                </Typography>
                <Typography my={2.2} variant="subtitle2">
                  HP
                </Typography>
                <Typography my={2.2} variant="subtitle2">
                  Wins
                </Typography>
                <Typography my={2.2} variant="subtitle2">
                  QDOS Earned
                </Typography>
              </Box>
            </Grid>
            <Grid item>
              <Box textAlign="center">
                <Typography my={2.2} variant="subtitle2">
                  :
                </Typography>
                <Typography my={2.2} variant="subtitle2">
                  :
                </Typography>
                <Typography my={2.2} variant="subtitle2">
                  :
                </Typography>
                <Typography my={2.2} variant="subtitle2">
                  :
                </Typography>
                <Typography my={2.2} variant="subtitle2">
                  :
                </Typography>
                <Typography my={2.2} variant="subtitle2">
                  :
                </Typography>
              </Box>
            </Grid>
            <Grid pr={3} item xs={7}>
              <Box textAlign="right">
                <Typography my={2.2} variant="subtitle2">
                  {advanceDetails.ranking}
                </Typography>
                <Typography my={2.2} variant="subtitle2">
                  {advanceDetails.mechTankHealth}
                </Typography>
                <Typography my={2.2} variant="subtitle2">
                  {advanceDetails.speed}
                </Typography>
                <Typography my={2.2} variant="subtitle2">
                  {advanceDetails.hp}
                </Typography>
                <Typography my={2.2} variant="subtitle2">
                  {advanceDetails.wins}
                </Typography>
                <Typography my={2.2} variant="subtitle2">
                  {advanceDetails.qdosEarned}
                </Typography>
              </Box>
            </Grid>
          </Grid>
          <Box pb={2} >
            {' '}
            <Box px={4} mt={2} mb={4}>
              <Button variant="outlined" fullWidth sx={{mb: 10 }}>
                View Brain Code
              </Button>
            </Box>
          </Box>
        </Box>
      </Box>
    </Card>
    
  </Grid>
  
)
}
