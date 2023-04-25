import React from 'react'
import { Box, Grid, Typography, Button, Card } from '@mui/material'

interface EquipmentDetails {
  id: number
  equipment_class: string
  image: string
  equipment_type: string
  magazine_size: number
  rate_of_fire: number
  reload_time: number
  max_range: number
  resolution: number
  max_health: number
  accel_speed_mss: number
  max_speed_ms: number
  max_throttle: number
  movement_type: string
  sensor_hardpoints: number
  turn_speed: number
  weapon_hardpoints: number
  damage_direct: number
  damage_near: number
  damage_far: number
  speed: number
  range: number
}

interface EquipmentDetailsPrpos {
  equipment: EquipmentDetails
  isOwnedFrobot: boolean
  imageBaseUrl: string
}

export default (props: EquipmentDetailsPrpos) => {
  const { equipment, imageBaseUrl, isOwnedFrobot } = props

  return (
    <Grid container spacing={2}>
      <Grid item xs={12} sm={12} md={6} lg={6}>
        <Box position={'relative'} width={'100%'} m={'auto'}>
          <Box
            component={'img'}
            height={'100%'}
            borderRadius={'16px'}
            src={`${imageBaseUrl}${equipment.image}`}
          ></Box>
        </Box>
      </Grid>
      <Grid item xs={12} sm={12} md={6} lg={6}>
        <Box sx={{ height: '100%' }}>
          <Box px={4} py={4}>
            <Box mt={4}>
              <Box>
                <Typography sx={{ pl: 4, pt: 2, mt: 1, mb: 2 }} variant={'h5'}>
                  {equipment.equipment_class} {equipment.equipment_type}
                </Typography>
                <Box>
                  {equipment.equipment_class === 'cannon' && (
                    <Box>
                      <Grid container spacing={2} pl={4}>
                        <Grid item xs={4}>
                          <Box textAlign="left">
                            <Typography my={2} variant="subtitle2">
                              Magazine
                            </Typography>
                            <Typography my={2} variant="subtitle2">
                              Reload
                            </Typography>
                            <Typography my={2} variant="subtitle2">
                              RoF
                            </Typography>
                          </Box>
                        </Grid>
                        <Grid item>
                          <Box textAlign="center">
                            <Typography my={2} variant="subtitle2">
                              :
                            </Typography>
                            <Typography my={2} variant="subtitle2">
                              :
                            </Typography>
                            <Typography my={2} variant="subtitle2">
                              :
                            </Typography>
                          </Box>
                        </Grid>
                        <Grid pr={4} item xs={7}>
                          <Box textAlign="right">
                            <Typography my={2} variant="subtitle2">
                              {equipment?.magazine_size}
                            </Typography>
                            <Typography my={2} variant="subtitle2">
                              {equipment?.reload_time}
                            </Typography>
                            <Typography my={2} variant="subtitle2">
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
                            <Typography my={2} variant="subtitle2">
                              Max Range
                            </Typography>
                            <Typography my={2} variant="subtitle2">
                              Resolution
                            </Typography>
                          </Box>
                        </Grid>
                        <Grid item>
                          <Box textAlign="center">
                            <Typography my={2} variant="subtitle2">
                              :
                            </Typography>
                            <Typography my={2} variant="subtitle2">
                              :
                            </Typography>
                          </Box>
                        </Grid>
                        <Grid pr={4} item xs={7}>
                          <Box textAlign="right">
                            <Typography my={2} variant="subtitle2">
                              {equipment?.max_range}
                            </Typography>
                            <Typography my={2} variant="subtitle2">
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
                            <Typography my={2} variant="subtitle2">
                              Range
                            </Typography>
                            <Typography my={2} variant="subtitle2">
                              Speed
                            </Typography>
                            <Typography my={2} variant="subtitle2">
                              Direct Damage
                            </Typography>
                            <Typography my={2} variant="subtitle2">
                              Far Damage
                            </Typography>
                            <Typography my={2} variant="subtitle2">
                              Near Damage
                            </Typography>
                          </Box>
                        </Grid>
                        <Grid item>
                          <Box textAlign="center">
                            <Typography my={2} variant="subtitle2">
                              :
                            </Typography>
                            <Typography my={2} variant="subtitle2">
                              :
                            </Typography>
                            <Typography my={2} variant="subtitle2">
                              :
                            </Typography>
                            <Typography my={2} variant="subtitle2">
                              :
                            </Typography>
                            <Typography my={2} variant="subtitle2">
                              :
                            </Typography>
                          </Box>
                        </Grid>
                        <Grid item xs={7}>
                          <Box textAlign="right">
                            <Typography my={2} variant="subtitle2">
                              {equipment?.range}
                            </Typography>
                            <Typography my={2} variant="subtitle2">
                              {equipment?.speed}
                            </Typography>
                            <Typography my={2} variant="subtitle2">
                              {equipment?.damage_direct}
                            </Typography>
                            <Typography my={2} variant="subtitle2">
                              {equipment?.damage_far}
                            </Typography>
                            <Typography my={2} variant="subtitle2">
                              {equipment?.damage_near}
                            </Typography>
                          </Box>
                        </Grid>
                      </Grid>
                    </Box>
                  )}

                  {equipment.equipment_class === 'xframe' && (
                    <Box>
                      <Grid container spacing={2} pl={4}>
                        <Grid item xs={4}>
                          <Box textAlign="left">
                            <Typography my={2} variant="subtitle2">
                              Accel Speed
                            </Typography>
                            <Typography my={2} variant="subtitle2">
                              Max Speed
                            </Typography>
                            <Typography my={2} variant="subtitle2">
                              Max Throttle
                            </Typography>
                            <Typography my={2} variant="subtitle2">
                              Turn Speed
                            </Typography>
                            <Typography my={2} variant="subtitle2">
                              Max Health
                            </Typography>
                          </Box>
                        </Grid>
                        <Grid item>
                          <Box textAlign="center">
                            <Typography my={2} variant="subtitle2">
                              :
                            </Typography>
                            <Typography my={2} variant="subtitle2">
                              :
                            </Typography>
                            <Typography my={2} variant="subtitle2">
                              :
                            </Typography>
                            <Typography my={2} variant="subtitle2">
                              :
                            </Typography>
                            <Typography my={2} variant="subtitle2">
                              :
                            </Typography>
                          </Box>
                        </Grid>
                        <Grid item xs={7}>
                          <Box textAlign="right">
                            <Typography my={2} variant="subtitle2">
                              {equipment?.accel_speed_mss}
                            </Typography>
                            <Typography my={2} variant="subtitle2">
                              {equipment?.max_speed_ms}
                            </Typography>
                            <Typography my={2} variant="subtitle2">
                              {equipment?.max_throttle}
                            </Typography>
                            <Typography my={2} variant="subtitle2">
                              {equipment?.turn_speed}
                            </Typography>
                            <Typography my={2} variant="subtitle2">
                              {equipment?.max_health}
                            </Typography>
                          </Box>
                        </Grid>
                      </Grid>
                    </Box>
                  )}

                  {isOwnedFrobot && (
                    <Box
                      mt={3}
                      display={'flex'}
                      justifyContent={'space-around'}
                    >
                      <Button
                        variant="text"
                        fullWidth
                        color="warning"
                        sx={{
                          backgroundColor: '#ffab0029',
                          width: '200px',
                        }}
                      >
                        Boost
                      </Button>
                      <Button
                        variant="text"
                        fullWidth
                        sx={{
                          backgroundColor: '#00AB552F',
                          color: '#5BE584',
                          width: '200px',
                        }}
                      >
                        Attach
                      </Button>
                    </Box>
                  )}
                </Box>
              </Box>
            </Box>
          </Box>
        </Box>
      </Grid>
    </Grid>
  )
}
