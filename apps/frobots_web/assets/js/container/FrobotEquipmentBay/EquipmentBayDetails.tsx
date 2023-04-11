import React from 'react'
import { Box, Grid, Typography, Button, Card } from '@mui/material'

interface EquipmentDetails {
  id: number
  avatar: string
  name: string
  props: EquipmentDetailsProps
}

interface EquipmentDetailsProps {
  maxRange: string
  magazine: number
  damage: string
  reload: number
  roF: number
}
interface EquipmentDetailsPrpos {
  equipmentDetails: EquipmentDetails
}

export default (props: EquipmentDetailsPrpos) => {
  const { equipmentDetails } = props

  return (
    <Grid item xs={12} lg={8} sm={12} md={12}>
      <Card sx={{ height: '100%' }}>
        <Grid container spacing={2}>
          <Grid item xs={12} sm={12} md={6} lg={6}>
            <Box position={'relative'} width={'100%'} m={'auto'}>
              <Box
                component={'img'}
                height={'100%'}
                src={equipmentDetails.avatar}
              ></Box>
            </Box>
          </Grid>
          <Grid item xs={12} sm={12} md={6} lg={6}>
            <Box sx={{ height: '100%' }}>
              <Box px={4} py={4}>
                <Box mt={4}>
                  <Box>
                    <Typography
                      sx={{ pl: 4, pt: 2, mt: 1, mb: 2 }}
                      variant={'h5'}
                    >
                      {equipmentDetails?.name}
                    </Typography>
                    <Box>
                      <Grid pl={4} container spacing={2}>
                        <Grid item xs={4}>
                          <Box textAlign="left">
                            <Typography my={2} variant="subtitle2">
                              Max Range
                            </Typography>
                            <Typography my={2} variant="subtitle2">
                              Magazine
                            </Typography>
                            <Typography my={2} variant="subtitle2">
                              Damage
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
                              {equipmentDetails?.props?.maxRange}
                            </Typography>
                            <Typography my={2} variant="subtitle2">
                              {equipmentDetails?.props?.magazine}
                            </Typography>
                            <Typography my={2} variant="subtitle2">
                              {equipmentDetails?.props?.damage}
                            </Typography>
                            <Typography my={2} variant="subtitle2">
                              {equipmentDetails?.props?.reload}
                            </Typography>
                            <Typography my={2} variant="subtitle2">
                              {equipmentDetails?.props?.roF}
                            </Typography>
                          </Box>
                        </Grid>
                      </Grid>
                      <Box
                        mt={3}
                        pl={4}
                        display={'flex'}
                        justifyContent={'space-between'}
                      >
                        <Box pl={2}>
                          <Button
                            variant="text"
                            fullWidth
                            color="warning"
                            sx={{
                              backgroundColor: '#ffab0029',
                              width: '120px',
                            }}
                          >
                            Boost
                          </Button>
                        </Box>
                        <Box pr={2}>
                          <Button
                            variant="text"
                            fullWidth
                            sx={{
                              backgroundColor: '#00AB552F',
                              color: '#5BE584',
                              width: '120px',
                            }}
                          >
                            Attach
                          </Button>
                        </Box>
                      </Box>
                    </Box>
                  </Box>
                </Box>
              </Box>
            </Box>
          </Grid>
        </Grid>
      </Card>
    </Grid>
  )
}
