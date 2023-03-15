import { Card, Typography, Box, Grid, Button } from '@mui/material'
import ChevronRightIcon from '@mui/icons-material/ChevronRight'
import ChevronLeftIcon from '@mui/icons-material/ChevronLeft'
import React from 'react'
const attachedEquipments = [
  {
    id: 0,
    src: '/images/frobot_eq_cannon_mk2.png',
    name: 'Cannon MK II',
    props: {
      maxRange: '700m',
      magazine: 2,
      damage: '[40,3], [20,5], [5,10]',
      reload: 16,
      roF: 16,
    },
  },
  {
    id: 1,
    src: '/images/frobot_eq_cannon_mk3.png',
    name: 'Cannon MK III',
    props: {
      maxRange: '700m',
      magazine: 2,
      damage: '[40,3], [20,5], [5,10]',
      reload: 16,
      roF: 16,
    },
  },
  {
    id: 2,
    src: '/images/frobot_eq_scanner_mk1.png',
    name: 'Scanner MK I',
    props: {
      maxRange: '700m',
      magazine: 2,
      damage: '[40,3], [20,5], [5,10]',
      reload: 16,
      roF: 16,
    },
  },
  {
    id: 3,
    src: '/images/frobot_eq_scanner_mk2.png',
    name: 'Scanner MK II',
    props: {
      maxRange: '700m',
      magazine: 2,
      damage: '[40,3], [20,5], [5,10]',
      reload: 16,
      roF: 16,
    },
  },
]

const selectedEquipment = attachedEquipments[0]

export default () => {
  return (
    <Grid item xs={12} sm={12}>
      <Card>
        <Box display={'flex'}>
          <Box>
            

            <Grid container spacing={2}>
              <Grid item xs={12} md={8}>
                <Box
                  sx={{
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'space-between',
                    pl: 4,
                    pt: 2,
                    mt: 1,
                    mb: 2,
                  }}
                >
                  <Box
                    sx={{
                      backgroundColor: '#1C4250',
                      borderRadius: '4px',
                    }}
                  >
                    <ChevronLeftIcon
                      sx={{
                        color: '#FFFFFF7E',
                      }}
                    />
                  </Box>
                  <Typography variant={'subtitle1'}>
                    Attached Equipments (1/2)
                  </Typography>
                  <Box
                    sx={{
                      backgroundColor: '#1C4250',
                      borderRadius: '4px',
                    }}
                  >
                    <ChevronRightIcon
                      sx={{
                        color: '#FFFFFF',
                      }}
                    />
                  </Box>
                </Box>

                <Box display={'flex'}>
                 
                  {attachedEquipments.map((equipment, index) => (
                    <Grid item lg={3} md={4} sm={6} xs={12}>
                      <Box sx={{ px: 4, pb: 2 }}>
                        <Box pl={2} component={'img'} src={equipment.src} />
                        <Box textAlign={'center'} mt={3}>
                          <Typography fontWeight={'bold'} variant="subtitle1">
                            {equipment.name}
                          </Typography>
                        </Box>
                      </Box>
                    </Grid>
                  ))}
                </Box>
              </Grid>
              <Grid item xs={12} sm={12} md={4} lg={4}>
                <Box
                  sx={{
                    backgroundColor: '#00AB5529',
                    pt:0.2
                  }}
                >
                  <Typography
                    sx={{ pl: 4, pt: 2, mt: 1, mb: 2 }}
                    variant={'h6'}
                  >
                    {selectedEquipment.name}
                  </Typography>
                  <Box>
                    <Grid pl={4} container spacing={2}>
                      <Grid item xs={4}>
                        <Box textAlign="left">
                          <Typography my={1.2} variant="subtitle2">
                            Max Range
                          </Typography>
                          <Typography my={1.2} variant="subtitle2">
                            Magazine
                          </Typography>
                          <Typography my={1.2} variant="subtitle2">
                            Damage
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
                            {selectedEquipment.props.maxRange}
                          </Typography>
                          <Typography my={1.2} variant="subtitle2">
                            {selectedEquipment.props.magazine}
                          </Typography>
                          <Typography my={1.2} variant="subtitle2">
                            {selectedEquipment.props.damage}
                          </Typography>
                          <Typography my={1.2} variant="subtitle2">
                            {selectedEquipment.props.reload}
                          </Typography>
                          <Typography my={1.2} variant="subtitle2">
                            {selectedEquipment.props.roF}
                          </Typography>
                        </Box>
                      </Grid>
                    </Grid>
                    <Box pb={2} pl={4} pr={5}>
                      {' '}
                      <Button
                        variant="text"
                        fullWidth
                        sx={{ backgroundColor: '#00AB552F', color: '#5BE584' }}
                      >
                        View Equipment Bay
                      </Button>
                    </Box>
                  </Box>
                </Box>
              </Grid>
            </Grid>
          </Box>
        </Box>
      </Card>
    </Grid>
  )
}
