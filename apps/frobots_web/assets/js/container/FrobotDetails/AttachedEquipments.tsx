import React, { useState } from 'react'
import { Card, Typography, Box, Grid, Button } from '@mui/material'
import ChevronLeftIcon from '@mui/icons-material/ChevronLeft'
import ChevronRightIcon from '@mui/icons-material/ChevronRight'
import EquipmentDetails from './EquipmentDetails'

interface AttachedEquipmentsProps {
  equipments: any[]
  isOwnedFrobot: boolean
  frobotId: number
  imageBaseUrl: string
}

const columnsPerPage = 4

export default (props: AttachedEquipmentsProps) => {
  const { equipments, isOwnedFrobot, frobotId, imageBaseUrl } = props
  const equipmentLength = equipments.length
  const [currentEquipment, setCurrentEquipment] = useState(equipments[0])
  const [currentIndex, setCurrentIndex] = useState(0)
  const [leftOffset, setOffsetLeft] = useState(0)
  const [rightOffset, setOffsetRight] = useState(
    equipmentLength > columnsPerPage ? columnsPerPage : equipmentLength
  )

  const switchEquipment = (index: number) => {
    setCurrentEquipment(equipments[leftOffset + index])
    setCurrentIndex(index)
  }

  const handleLeftClick = () => {
    if (leftOffset <= 0) {
      return
    }

    const newLeftOffset =
      leftOffset - columnsPerPage < 0 ? 0 : leftOffset - columnsPerPage
    setOffsetLeft(newLeftOffset)
    setOffsetRight(
      rightOffset - columnsPerPage < columnsPerPage
        ? columnsPerPage
        : rightOffset - columnsPerPage
    )
    setCurrentIndex(0)
    setCurrentEquipment(equipments[newLeftOffset])
  }

  const handleRightClick = () => {
    if (rightOffset >= equipmentLength) {
      return
    }

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

    setCurrentEquipment(equipments[newLeftOffset])
  }

  const handleViewEquipmentBay = () => {
    window.location.href = `/garage/frobot/equipment_bay?id=${frobotId}`
  }

  return (
    <Grid item xs={12} sm={12}>
      <Card>
        <Grid container spacing={2}>
          <Grid item xs={12} lg={8} md={12} sm={12}>
            <Typography
              variant={'subtitle1'}
              pt={2}
              pb={2}
              textAlign={'center'}
            >
              Attached Equipments
            </Typography>
            <Box
              sx={{
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'space-between',
                pl: 2,
                pr: 2,
                mb: 2,
              }}
            >
              <Box
                onClick={handleLeftClick}
                sx={{
                  m: '10px',
                  backgroundColor: '#1C4250',
                  borderRadius: '4px',
                  cursor: 'pointer',
                }}
              >
                <ChevronLeftIcon
                  sx={{
                    color: leftOffset !== 0 ? '#FFFFFF' : '#FFFFFF7E',
                  }}
                />
              </Box>
              <Grid container spacing={2}>
                {equipments
                  .slice(leftOffset, rightOffset)
                  .map((equipment, index) => (
                    <Grid item xs={6} sm={4} md={3} lg={3} key={index}>
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
                          height={'80%'}
                          src={`${imageBaseUrl}${equipment.image}`}
                          sx={{
                            cursor: 'pointer',
                            borderRadius: '6px',
                            border:
                              index === currentIndex
                                ? '4px solid #00AB55'
                                : '4px solid transparent',
                          }}
                          onClick={() => switchEquipment(index)}
                        />

                        <Box textAlign={'center'} mt={3} mb={2}>
                          <Typography
                            sx={{
                              fontSize: '0.8rem',
                              overflow: 'visible',
                              textTransform: 'capitalize',
                            }}
                            fontWeight={'bold'}
                            variant="subtitle1"
                          >
                            {equipment.equipment_class}{' '}
                            {equipment.equipment_type}
                          </Typography>
                        </Box>
                      </Box>
                    </Grid>
                  ))}
              </Grid>
              <Box
                onClick={handleRightClick}
                sx={{
                  m: '10px',
                  backgroundColor: '#1C4250',
                  borderRadius: '4px',
                  cursor: 'pointer',
                }}
              >
                <ChevronRightIcon
                  sx={{
                    color:
                      rightOffset !== equipmentLength ? '#FFFFFF' : '#FFFFFF7E',
                  }}
                />
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
            <Box position={'relative'} height={'100%'}>
              <Box height={'100%'}>
                {equipmentLength !== 0 && (
                  <EquipmentDetails equipment={currentEquipment} />
                )}
              </Box>
              <Box
                sx={{
                  position: 'absolute',
                  left: '50%',
                  px: 4,
                  transform: 'translate(-50%, -50%)',
                  width: '100%',
                  bottom: 10,
                }}
              >
                {isOwnedFrobot && (
                  <Button
                    variant="text"
                    fullWidth
                    onClick={handleViewEquipmentBay}
                    sx={{
                      width: '100%',
                      backgroundColor: '#00AB552F',
                      color: '#5BE584',
                    }}
                  >
                    View Equipment Bay
                  </Button>
                )}
              </Box>
            </Box>
          </Grid>
        </Grid>
      </Card>
    </Grid>
  )
}
