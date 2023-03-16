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
  {
    id: 4,
    src: '/images/frobot_eq_scanner_mk2.png',
    name: 'Scanner MK III',
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
        <Grid container spacing={2}>
          <Grid item xs={12} lg={8} md={12} sm={12}>
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
                  mr: 4,
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

            <Box
              sx={{
                overflowX: 'scroll',
                '&::-webkit-scrollbar': { display: 'none' },
              }}
            >
              <Box display={'flex'}>
                {attachedEquipments.slice(0, 4).map((equipment, index) => (
                  <Grid item lg={4} md={8} sm={6} xs={12} key={equipment.id}>
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
            </Box>
          </Grid>
          <Grid
            item
            xs={12}
            lg={4}
            md={12}
            sm={12}
            sx={{
              backgroundColor: '#00AB5529',
            }}
          >
            <Box>
              <Typography sx={{ pl: 4, pt: 2, mt: 1, mb: 2 }} variant={'h6'}>
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
              </Box>
            </Box>
            <Box
              sx={{
                m: 4,
              }}
            >
              <Button
                variant="text"
                fullWidth
                sx={{
                  backgroundColor: '#00AB552F',
                  color: '#5BE584',
                }}
              >
                View Equipment Bay
              </Button>
            </Box>
          </Grid>
        </Grid>
      </Card>
    </Grid>
  )
}
