import React, { useState } from 'react'
import { Box, Grid, Typography, Button, Card } from '@mui/material'
import ChevronLeftIcon from '@mui/icons-material/ChevronLeft'
import ChevronRightIcon from '@mui/icons-material/ChevronRight'

interface Equipments {
  id: number
  avatar: string
  name: string
  props: {
    maxRange: string
    magazine: number
    damage: string
    reload: number
    roF: number
  }
}

interface AvailableEquipmentPrpos {
  availableEquipments: Equipments[]
}


export default ( props:AvailableEquipmentPrpos ) => {
    const { availableEquipments} = props

  const totalSections = Math.ceil(availableEquipments?.length / 6)
  const [currentSection, setCurrentSection] = useState(1);
  const [rowOneAvailableEquipmentList, setRowOneAvailableEquipmentList] =
    useState(availableEquipments.slice(0, 6))



  const clickPrevious=()=>{
    if(currentSection>1)
    {
      setCurrentSection(currentSection-1)
      setRowOneAvailableEquipmentList(availableEquipments.slice(0, 6))
    }
  }

    const clickNext= () => {
      if (currentSection < totalSections) {
        setCurrentSection(currentSection + 1)
         setRowOneAvailableEquipmentList(availableEquipments.slice(6, 9))
      }
    }
    return (
      <Grid item xs={12} sm={12} md={12} lg={4}>
        <Card sx={{height:'100%'}}>
          <Typography variant={'subtitle1'} pt={2} pb={2} textAlign={'center'}>
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
                sx={{
                  color: currentSection === 1 ? '#FFFFFF7E' : '#FFFFFF',
                }}
              />
            </Box>
            <Grid container spacing={2}>
              {rowOneAvailableEquipmentList.map((equipment, index) => (
                <Grid item xs={4} sm={4} md={4} lg={4}>
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
                      src={equipment.avatar}
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
                sx={{
                  color:
                    totalSections === currentSection ? '#FFFFFF7E' : '#FFFFFF',
                }}
              />
            </Box>
          </Box>
        </Card>
      </Grid>
    )
  
}
