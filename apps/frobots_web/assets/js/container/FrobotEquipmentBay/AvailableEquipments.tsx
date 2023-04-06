import React, { useState } from 'react'
import { Box, Grid, Typography, Button, Card } from '@mui/material'
import { useSelector } from 'react-redux'
import AttachedEquipments from './AttachedEquipments'
import { generateRandomString } from '../../utils/util'
import FrobotAdvancedDetails from '../FrobotDetails/FrobotAdvancedDetails'
import ChevronLeftIcon from '@mui/icons-material/ChevronLeft'
import ChevronRightIcon from '@mui/icons-material/ChevronRight'

const data = [
  {
    id: 1,
    image: '/images/equipment_canon_mk_2.png',
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
    id: 2,
    image: '/images/equipment_canon_mk_3.png',
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
    id: 3,
    image: '/images/equipment_scanner_mk_1.png',
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
    id: 4,
    image: '/images/equipment_scanner_mk_2.png',
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
    id: 5,
    image: '/images/equipment_scanner_mk_1.png',
    name: 'Cannon MK I',
    props: {
      maxRange: '700m',
      magazine: 2,
      damage: '[40,3], [20,5], [5,10]',
      reload: 16,
      roF: 16,
    },
  },
  {
    id: 6,
    image: '/images/equipment_scanner_mk_2.png',
    name: 'Scanner MK IV',
    props: {
      maxRange: '700m',
      magazine: 2,
      damage: '[40,3], [20,5], [5,10]',
      reload: 16,
      roF: 16,
    },
  },
  {
    id: 7,
    image: '/images/frobot_bg.png',
    name: 'Scanner MK V',
    props: {
      maxRange: '700m',
      magazine: 2,
      damage: '[40,3], [20,5], [5,10]',
      reload: 16,
      roF: 16,
    },
  },
  {
    id: 7,
    image: '/images/frobot_bg.png',
    name: 'Scanner MK V',
    props: {
      maxRange: '700m',
      magazine: 2,
      damage: '[40,3], [20,5], [5,10]',
      reload: 16,
      roF: 16,
    },
  },
  {
    id: 7,
    image: '/images/frobot_bg.png',
    name: 'Scanner MK V',
    props: {
      maxRange: '700m',
      magazine: 2,
      damage: '[40,3], [20,5], [5,10]',
      reload: 16,
      roF: 16,
    },
  },
  {
    id: 7,
    image: '/images/frobot_bg.png',
    name: 'Scanner MK V',
    props: {
      maxRange: '700m',
      magazine: 2,
      damage: '[40,3], [20,5], [5,10]',
      reload: 16,
      roF: 16,
    },
  },
  {
    id: 7,
    image: '/images/frobot_bg.png',
    name: 'Scanner MK V',
    props: {
      maxRange: '700m',
      magazine: 2,
      damage: '[40,3], [20,5], [5,10]',
      reload: 16,
      roF: 16,
    },
  },
  {
    id: 7,
    image: '/images/frobot_bg.png',
    name: 'Scanner MK V',
    props: {
      maxRange: '700m',
      magazine: 2,
      damage: '[40,3], [20,5], [5,10]',
      reload: 16,
      roF: 16,
    },
  },
  {
    id: 7,
    image: '/images/frobot_bg.png',
    name: 'Scanner MK V',
    props: {
      maxRange: '700m',
      magazine: 2,
      damage: '[40,3], [20,5], [5,10]',
      reload: 16,
      roF: 16,
    },
  },

  {
    id: 7,
    image: '/images/frobot_bg.png',
    name: 'Scanner MK V',
    props: {
      maxRange: '700m',
      magazine: 2,
      damage: '[40,3], [20,5], [5,10]',
      reload: 16,
      roF: 16,
    },
  },
  {
    id: 7,
    image: '/images/frobot_bg.png',
    name: 'Scanner MK V',
    props: {
      maxRange: '700m',
      magazine: 2,
      damage: '[40,3], [20,5], [5,10]',
      reload: 16,
      roF: 16,
    },
  },
]

export default ({ props }) => {
  const totalSections = Math.ceil(data?.length/6)
  const [currentSection, setCurrentSection] = useState(1);
  const [rowOneAvailableEquipmentList, setRowOneAvailableEquipmentList] =useState(data.slice(0,6));
    // const [rowTwoAvailableEquipmentList, setTwoOneAvailableEquipmentList] =
    //   useState(data.slice(3, 6))


  const clickPrevious=()=>{
    if(currentSection>1)
    {
      setCurrentSection(currentSection-1)
      setRowOneAvailableEquipmentList(data.slice(0, 6))
    }
  }

    const clickNext= () => {
      if (currentSection < totalSections) {
        setCurrentSection(currentSection + 1)
         setRowOneAvailableEquipmentList(data.slice(6, 9))
      }
    }
    return (
      <>
        <Grid lg={4} container>
          <Card>
            <Typography
              variant={'subtitle1'}
              pt={2}
              pb={2}
              textAlign={'center'}
            >
              Available Equipments ({currentSection}/{totalSections})
            </Typography>
            <Box
              minHeight={'4vh'}
              sx={{
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'space-between',
                pl: 2,
                pr: 2,
              }}
            >
              <Box
                onClick={clickPrevious}
                sx={{
                  m: '10px',
                  backgroundColor: '#1C4250',
                  borderRadius: '4px',
                }}
              >
                <ChevronLeftIcon
                  sx={
                    {
                      // color: firstIndex === 0 ? '#FFFFFF7E' : '#FFFFFF',
                    }
                  }
                />
              </Box>
              <Grid container spacing={2}>
                {rowOneAvailableEquipmentList.map((equipment, index) => (
                  <Grid item xs={6} sm={3} md={3} lg={4}>
                    <Box textAlign={'center'}>
                      <Typography
                        sx={{
                          fontSize: '0.8rem',
                          overflow: 'visible',
                        }}
                        gutterBottom
                        color={'#919EAB'}
                        fontWeight={'bold'}
                        variant="subtitle1"
                      >
                        {equipment.name}
                      </Typography>
                    </Box>
                    <Box
                      position={'relative'}
                      width={'100%'}
                      height={'100%'}
                      m={'auto'}
                      sx={{ cursor: 'pointer', p: 1 }}
                    >
                      <Box
                        component={'img'}
                        width={'100%'}
                        src={equipment.image}
                        sx={{
                          borderRadius: '6px',
                        }}
                      ></Box>
                      <Box
                        paddingBottom={2}
                        display="flex"
                        alignItems={'center'}
                        justifyContent={'center'}
                      >
                        <Button
                          variant="text"
                          size="small"
                          color="warning"
                          sx={{
                            mt: 2,
                            backgroundColor: '#ffab0029',
                            width: '100',
                          }}
                        >
                          Attach
                        </Button>
                      </Box>
                    </Box>
                  </Grid>
                ))}
              </Grid>
              <Box
                onClick={clickNext}
                sx={{
                  m: '10px',
                  backgroundColor: '#1C4250',
                  borderRadius: '4px',
                }}
              >
                <ChevronRightIcon
                // sx={{
                //   color:
                //     equipments.length < lastIndex + 1
                //       ? '#FFFFFF7E'
                //       : '#FFFFFF',
                // }}
                />
              </Box>
            </Box>
          </Card>
        </Grid>
      </>
    )
  
}
