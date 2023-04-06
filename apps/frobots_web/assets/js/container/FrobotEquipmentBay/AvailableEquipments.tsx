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
  const [rowOneAvailableEquipmentList, setRowOneAvailableEquipmentList] =useState(data.slice(0,3));
    const [rowTwoAvailableEquipmentList, setTwoOneAvailableEquipmentList] =
      useState(data.slice(3, 6))


  const clickPrevious=()=>{
    if(currentSection>1)
    {
      setCurrentSection(currentSection-1)
      setRowOneAvailableEquipmentList(data.slice(0, 3))
    }
  }

    const clickNext= () => {
      if (currentSection < totalSections) {
        setCurrentSection(currentSection + 1)
         setRowOneAvailableEquipmentList(data.slice(3, 6))
      }
    }
    return (
      <Grid sx={{ height: '100' }} item lg={4} md={6} sm={6} xs={12}>
        <Card
          sx={{
            bgcolor: '#212B36',
            borderRadius: 4,
            paddingTop: '100%',
            // overflowX: 'scroll',
            // '&::-webkit-scrollbar': { display: 'none' },
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
              px: 4,
            }}
          >
            <Typography pt={2} variant={'subtitle1'} textAlign={'center'}>
              Available Equipments ({currentSection}/{totalSections})
            </Typography>
            <Box display={'flex'} justifyContent={'center'} height={'100%'}>
              <Box
                justifyContent={'center'}
                alignItems={'center'}
                flexDirection={'column'}
              >
                <Box
                  onClick={clickPrevious}
                  alignItems={'center'}
                  alignSelf={'center'}
                  sx={{
                    backgroundColor: '#1C4250',
                    borderRadius: '4px',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    height: '25px',
                    alignSelf: 'center',
                    alignContent: 'center',
                  }}
                >
                  <ChevronLeftIcon
                    sx={{
                      color: '#FFFFFF',
                    }}
                  />
                </Box>
              </Box>

              <Box>
                <Box display={'flex'} pt={4}>
                  {rowOneAvailableEquipmentList.map((item) => (
                    <Box
                      textAlign={'center'}
                      sx={{ maxWidth: '200px', maxHeight: '200px' }}
                    >
                      <Typography
                        variant="subtitle2"
                        sx={{
                          fontWeight: 'bold',
                        }}
                      >
                        {item.name}
                      </Typography>
                      <Box
                        px={1}
                        pt={1}
                        pb={1}
                        component={'img'}
                        sx={{ maxWidth: '100%', maxHeight: '100%' }}
                        src={item.image}
                      />
                      <Button
                        variant="text"
                        size="small"
                        color="warning"
                        sx={{
                          backgroundColor: '#ffab0029',
                          width: '100',
                        }}
                      >
                        Attach
                      </Button>
                    </Box>
                    // <Box textAlign={'center'}>
                    //   <Typography
                    //     variant="subtitle2"
                    //     sx={{
                    //       fontWeight: 'bold',
                    //     }}
                    //   >
                    //     {item.name}
                    //   </Typography>
                    //   <Box
                    //     px={1}
                    //     pt={1}
                    //     pb={1}
                    //     // height="110px"
                    //     // width={'110px'}
                    //     component={'img'}
                    //     src={item.image}
                    //   />
                    //   <Button
                    //     variant="text"
                    //     size="small"
                    //     color="warning"
                    //     sx={{
                    //       backgroundColor: '#ffab0029',
                    //       width: '100',
                    //     }}
                    //   >
                    //     Attach
                    //   </Button>
                    // </Box>
                  ))}
                </Box>
                <Box display={'flex'} pt={2}>
                  {rowTwoAvailableEquipmentList.map((item) => (
                    <Box textAlign={'center'}>
                      <Typography
                        variant="subtitle2"
                        sx={{
                          fontWeight: 'bold',
                        }}
                      >
                        {item.name}
                      </Typography>
                      <Box
                        px={1}
                        pt={1}
                        pb={1}
                        // height="110px"
                        // width={'110px'}
                        component={'img'}
                        src={item.image}
                      />
                      <Button
                        variant="text"
                        size="small"
                        color="warning"
                        sx={{
                          backgroundColor: '#ffab0029',
                          width: '100',
                        }}
                      >
                        Attach
                      </Button>
                    </Box>
                  ))}
                </Box>
              </Box>
              <Box
                onClick={clickNext}
                sx={{
                  backgroundColor: '#1C4250',
                  borderRadius: '4px',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  height: '25px',
                }}
              >
                <ChevronRightIcon
                  sx={{
                    color: '#FFFFFF',
                  }}
                />
              </Box>
            </Box>
          </Box>
        </Card>
      </Grid>
    )
  
}
