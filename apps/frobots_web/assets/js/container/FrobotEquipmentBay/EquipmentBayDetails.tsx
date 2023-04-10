import React from 'react'
import { Box, Grid, Typography, Button, Card } from '@mui/material'
import { useSelector } from 'react-redux'
import AttachedEquipments from './AttachedEquipments'
import { generateRandomString } from '../../utils/util'
import FrobotAdvancedDetails from '../FrobotDetails/FrobotAdvancedDetails'
import AvailableEquipments from './AvailableEquipments'
import FrobotDetails from '../FrobotDetails'

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
    <>
   
        <Card>
          <Grid container>
            <Grid item lg={6} md={6} sm={12}>
              <Box position={'relative'} width={'100%'} m={'auto'}>
                <Box
                  component={'img'}
                  width={'100%'}
                  src={equipmentDetails.avatar}
                ></Box>
              </Box>
            </Grid>
            <Grid item lg={6} md={6} sm={12}>
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
            </Grid>
          </Grid>
        </Card>
    

      {/* <Grid pr={1} item lg={4} md={6} sm={6} xs={12}>
        <Card
          sx={{
            bgcolor: '#212B36',
            borderTopLeftRadius: 4,
            borderBottomLeftRadius: 4,
            paddingTop: '100%',
            overflowY: 'scroll',
            '&::-webkit-scrollbar': { display: 'none' },
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
            <Typography sx={{ pl: 4, pt: 2, mt: 1, mb: 2 }} variant={'h6'}>
              {'currennt?.name'}
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
                <Grid pr={4} item xs={7}>
                  <Box textAlign="right">
                    <Typography my={2} variant="subtitle2">
                      {'currentEquipme'}
                    </Typography>
                    <Typography my={2} variant="subtitle2">
                      {'currentEquip'}
                    </Typography>
                    <Typography my={2} variant="subtitle2">
                      {'currentEquipe'}
                    </Typography>
                    <Typography my={2} variant="subtitle2">
                      {'currentEquipad'}
                    </Typography>
                    <Typography my={2} variant="subtitle2">
                      {'currentEqF'}
                    </Typography>
                  </Box>
                </Grid>
              </Grid>
            </Box>
          </Box>
        </Card>
      </Grid> */}
    </>
  )
}
