import React from 'react'
import { Typography, Box, Grid } from '@mui/material'

interface Equipment {
  id: number
  cannon_id: number
  equipment_class: string
  equipment_type: string
  image: string
  magazine_size: number
  rate_of_fire: number
  reload_time: number
  damage_direct: number[]
  damage_far: number[]
  damage_near: number
  missile_id: number
  range: number
  speed: number
  max_range: number
  resolution: number
  scanner_id: number
}

interface EquipmentDetailProps {
  equipment: Equipment
}

export default ({ equipment }: EquipmentDetailProps) => {
  return (
    <>
      <Box>
        <Typography
          sx={{ pl: 4, pt: 2, mt: 1, mb: 2 }}
          variant={'h6'}
          textTransform={'capitalize'}
        >
          {equipment.equipment_class} {equipment.equipment_type}
        </Typography>
        {equipment.equipment_class === 'cannon' && (
          <Box>
            <Grid container spacing={2} pl={4}>
              <Grid item xs={4}>
                <Box textAlign="left">
                  <Typography my={1.2} variant="subtitle2">
                    Magazine
                  </Typography>
                  <Typography my={1.2} variant="subtitle2">
                    Reload
                  </Typography>
                  <Typography my={1.2} variant="subtitle2">
                    RoF
                  </Typography>
                </Box>
              </Grid>
              <Grid item>
                <Box textAlign="center">
                  <Typography my={1.2} variant="subtitle2">
                    :
                  </Typography>
                  <Typography my={1.2} variant="subtitle2">
                    :
                  </Typography>
                  <Typography my={1.2} variant="subtitle2">
                    :
                  </Typography>
                </Box>
              </Grid>
              <Grid pr={4} item xs={7}>
                <Box textAlign="right">
                  <Typography my={1.2} variant="subtitle2">
                    {equipment?.magazine_size}
                  </Typography>
                  <Typography my={1.2} variant="subtitle2">
                    {equipment?.reload_time}
                  </Typography>
                  <Typography my={1.2} variant="subtitle2">
                    {equipment?.rate_of_fire}
                  </Typography>
                </Box>
              </Grid>
            </Grid>
          </Box>
        )}
        {equipment.equipment_class === 'scanner' && (
          <Box>
            <Grid container spacing={2} pl={4}>
              <Grid item xs={4}>
                <Box textAlign="left">
                  <Typography my={1.2} variant="subtitle2">
                    Max Range
                  </Typography>
                  <Typography my={1.2} variant="subtitle2">
                    Resolution
                  </Typography>
                </Box>
              </Grid>
              <Grid item>
                <Box textAlign="center">
                  <Typography my={1.2} variant="subtitle2">
                    :
                  </Typography>
                  <Typography my={1.2} variant="subtitle2">
                    :
                  </Typography>
                </Box>
              </Grid>
              <Grid pr={4} item xs={7}>
                <Box textAlign="right">
                  <Typography my={1.2} variant="subtitle2">
                    {equipment?.max_range}
                  </Typography>
                  <Typography my={1.2} variant="subtitle2">
                    {equipment?.resolution}
                  </Typography>
                </Box>
              </Grid>
            </Grid>
          </Box>
        )}
        {equipment.equipment_class === 'missile' && (
          <Box>
            <Grid container spacing={2} pl={4}>
              <Grid item xs={4}>
                <Box textAlign="left">
                  <Typography my={1.2} variant="subtitle2">
                    Range
                  </Typography>
                  <Typography my={1.2} variant="subtitle2">
                    Speed
                  </Typography>
                  <Typography my={1.2} variant="subtitle2">
                    Direct Damage
                  </Typography>
                  <Typography my={1.2} variant="subtitle2">
                    Far Damage
                  </Typography>
                  <Typography my={1.2} variant="subtitle2">
                    Near Damage
                  </Typography>
                </Box>
              </Grid>
              <Grid item>
                <Box textAlign="center">
                  <Typography my={1.2} variant="subtitle2">
                    :
                  </Typography>
                  <Typography my={1.2} variant="subtitle2">
                    :
                  </Typography>
                  <Typography my={1.2} variant="subtitle2">
                    :
                  </Typography>
                  <Typography my={1.2} variant="subtitle2">
                    :
                  </Typography>
                  <Typography my={1.2} variant="subtitle2">
                    :
                  </Typography>
                </Box>
              </Grid>
              <Grid pr={4} item xs={7}>
                <Box textAlign="right">
                  <Typography my={1.2} variant="subtitle2">
                    {equipment?.range}
                  </Typography>
                  <Typography my={1.2} variant="subtitle2">
                    {equipment?.speed}
                  </Typography>
                  <Typography my={1.2} variant="subtitle2">
                    {equipment?.damage_direct}
                  </Typography>
                  <Typography my={1.2} variant="subtitle2">
                    {equipment?.damage_far}
                  </Typography>
                  <Typography my={1.2} variant="subtitle2">
                    {equipment?.damage_near}
                  </Typography>
                </Box>
              </Grid>
            </Grid>
          </Box>
        )}
      </Box>
    </>
  )
}
