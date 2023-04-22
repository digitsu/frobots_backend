import React, { useState } from 'react'
import { Box, Grid, Typography, Button, Card } from '@mui/material'
import ChevronLeftIcon from '@mui/icons-material/ChevronLeft'
import ChevronRightIcon from '@mui/icons-material/ChevronRight'
import EquipmentDetails from './EquipmentDetails'
interface Equipments {
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
interface AvailableEquipmentPrpos {
  availableEquipments: Equipments[]
  isOwnedFrobot: boolean
  frobotId: string
  imageBaseUrl: string
}

const equipmentDetails = {
  id: 1,
  avatar: '/images/equipment_canon_mk_2_large.png',
  name: 'Cannon MK II',
  props: {
    maxRange: '700m',
    magazine: 2,
    damage: '[40,3], [20,5], [5,10]',
    reload: 16,
    roF: 16,
  },
}

const columnsPerPage = 6

export default (props: AvailableEquipmentPrpos) => {
  const { availableEquipments, imageBaseUrl, isOwnedFrobot } = props
  const equipmentLength = availableEquipments.length
  const [currentEquipment, setCurrentEquipment] = useState(
    availableEquipments[0]
  )
  const [currentIndex, setCurrentIndex] = useState(0)
  const [leftOffset, setOffsetLeft] = useState(0)
  const [rightOffset, setOffsetRight] = useState(
    equipmentLength > columnsPerPage ? columnsPerPage : equipmentLength
  )
  const [currentSection, setCurrentSection] = useState(1)
  const totalSections = Math.ceil(availableEquipments?.length / columnsPerPage)

  const switchEquipment = (index: number) => {
    setCurrentEquipment(availableEquipments[index])
    setCurrentIndex(index)
  }

  const handleClickPrevious = () => {
    if (leftOffset <= 0) {
      return
    }

    setCurrentSection(currentSection - 1)
    const newLeftOffset =
      leftOffset - columnsPerPage < 0 ? 0 : leftOffset - columnsPerPage
    setOffsetLeft(newLeftOffset)
    setOffsetRight(
      rightOffset - columnsPerPage < columnsPerPage
        ? columnsPerPage
        : rightOffset - columnsPerPage
    )
    setCurrentIndex(0)
    setCurrentEquipment(availableEquipments[newLeftOffset])
  }

  const handleClickNext = () => {
    if (rightOffset >= equipmentLength) {
      return
    }

    setCurrentSection(currentSection + 1)
    const newLeftOffset =
      leftOffset + columnsPerPage > equipmentLength
        ? leftOffset
        : leftOffset + columnsPerPage
    setOffsetLeft(newLeftOffset)
    setOffsetRight(
      rightOffset + columnsPerPage > equipmentLength
        ? equipmentLength
        : rightOffset + columnsPerPage
    )
    setCurrentIndex(0)

    setCurrentEquipment(availableEquipments[newLeftOffset])
  }

  return (
    <>
      {equipmentLength ? (
        <Grid container spacing={2}>
          <Grid item xs={12} lg={8} sm={12} md={12}>
            <Card sx={{ height: '100%' }}>
              {currentEquipment && (
                <EquipmentDetails
                  equipment={currentEquipment}
                  imageBaseUrl={imageBaseUrl}
                  isOwnedFrobot={isOwnedFrobot}
                />
              )}
            </Card>
          </Grid>

          <Grid item xs={12} sm={12} md={12} lg={4}>
            <Card sx={{ height: '100%' }}>
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
                  onClick={handleClickPrevious}
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
                  {availableEquipments
                    .slice(leftOffset, rightOffset)
                    .map((equipment, index) => (
                      <Grid
                        item
                        xs={6}
                        sm={4}
                        md={4}
                        lg={4}
                        key={index}
                        onClick={() => switchEquipment(index)}
                      >
                        <Box textAlign={'center'}>
                          <Typography
                            sx={{
                              fontSize: '0.8rem',
                              overflow: 'visible',
                            }}
                            gutterBottom
                            color={'#919EAB'}
                            fontWeight={'bold'}
                            variant={'subtitle1'}
                            textTransform={'capitalize'}
                            textOverflow={'ellipsis'}
                            whiteSpace={'nowrap'}
                          >
                            {equipment.equipment_class}{' '}
                            {equipment.equipment_type}
                          </Typography>
                        </Box>

                        <Box
                          component={'img'}
                          src={`${imageBaseUrl}${equipment.image}`}
                          sx={{
                            cursor: 'pointer',
                            p: 1,
                            borderRadius: '6px',
                            border:
                              index === currentIndex
                                ? '4px solid #00AB55'
                                : 'none',
                          }}
                        />
                        {isOwnedFrobot && (
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
                        )}
                      </Grid>
                    ))}
                </Grid>
                <Box
                  onClick={handleClickNext}
                  sx={{
                    m: '10px',
                    backgroundColor: '#1C4250',
                    borderRadius: '4px',
                  }}
                >
                  <ChevronRightIcon
                    sx={{
                      color:
                        totalSections === currentSection
                          ? '#FFFFFF7E'
                          : '#FFFFFF',
                    }}
                  />
                </Box>
              </Box>
            </Card>
          </Grid>
        </Grid>
      ) : (
        <Grid container spacing={2}>
          <Grid item xs={12} lg={8} sm={12} md={12}>
            <Card sx={{ height: '100%' }}>
              <Box
                display="flex"
                width={'100%'}
                minHeight={'250px'}
                maxHeight={'250px'}
                alignItems="center"
                justifyContent="center"
              >
                <Typography variant={'subtitle1'}>
                  {"Equipment's not available for this bot !"}
                </Typography>
              </Box>
            </Card>
          </Grid>
          <Grid item xs={12} sm={8} md={12} lg={4}>
            <Card sx={{ height: '100%' }}>
              <Box
                display="flex"
                width={'100%'}
                minHeight={'250px'}
                maxHeight={'250px'}
                alignItems="center"
                justifyContent="center"
              >
                <Typography variant={'subtitle1'}>
                  {"Equipment's not available for this bot !"}
                </Typography>
              </Box>
            </Card>
          </Grid>
        </Grid>
      )}
    </>
  )
}
