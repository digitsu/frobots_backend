import React, { useState } from 'react'
import { Box, Grid, Typography, Button, Card } from '@mui/material'
import ChevronLeftIcon from '@mui/icons-material/ChevronLeft'
import ChevronRightIcon from '@mui/icons-material/ChevronRight'
import EquipmentDetails from './EquipmentDetails'
import { useDispatch, useSelector } from 'react-redux'
import { frobotEquipmentActions } from '../../redux/slices/frobotEquipment'

interface AvailableEquipmentPrpos {
  availableEquipments: any[]
  isOwnedFrobot: boolean
  frobotId: string
  imageBaseUrl: string
}

const itemsPerPage = 6

export default (props: AvailableEquipmentPrpos) => {
  const dispatch = useDispatch()
  const { setCurrentEquipment, setActiveEquipmentKey } = frobotEquipmentActions
  const { activeEquipmentKey } = useSelector(
    (store: any) => store.frobotEquipment
  )

  const { availableEquipments, imageBaseUrl, isOwnedFrobot } = props
  const equipmentLength = availableEquipments.length
  const [leftOffset, setOffsetLeft] = useState(0)
  const [rightOffset, setOffsetRight] = useState(
    equipmentLength > itemsPerPage ? itemsPerPage : equipmentLength
  )
  const [currentSection, setCurrentSection] = useState(1)
  const totalSections = Math.ceil(availableEquipments?.length / itemsPerPage)

  const switchEquipment = (equipment: any) => {
    dispatch(setCurrentEquipment(equipment))
    dispatch(setActiveEquipmentKey(equipment?.equiment_key))
  }

  const handleClickPrevious = () => {
    if (leftOffset <= 0) {
      return
    }

    setCurrentSection(currentSection - 1)
    const newLeftOffset =
      leftOffset - itemsPerPage < 0 ? 0 : leftOffset - itemsPerPage
    setOffsetLeft(newLeftOffset)
    setOffsetRight(
      rightOffset - itemsPerPage < itemsPerPage
        ? itemsPerPage
        : rightOffset - itemsPerPage
    )

    const equipment = availableEquipments[newLeftOffset]
    dispatch(setCurrentEquipment(equipment))
    dispatch(setActiveEquipmentKey(equipment?.equiment_key))
  }

  const handleClickNext = () => {
    if (rightOffset >= equipmentLength) {
      return
    }

    setCurrentSection(currentSection + 1)
    const newLeftOffset =
      leftOffset + itemsPerPage > equipmentLength
        ? leftOffset
        : leftOffset + itemsPerPage
    setOffsetLeft(newLeftOffset)
    setOffsetRight(
      rightOffset + itemsPerPage > equipmentLength
        ? equipmentLength
        : rightOffset + itemsPerPage
    )

    const equipment = availableEquipments[rightOffset]
    dispatch(setCurrentEquipment(equipment))
    dispatch(setActiveEquipmentKey(equipment?.equiment_key))
  }

  return (
    <>
      <Grid container spacing={2}>
        <Grid item xs={12} lg={8} sm={12} md={12}>
          <Card sx={{ height: '100%' }}>
            <EquipmentDetails
              imageBaseUrl={imageBaseUrl}
              isOwnedFrobot={isOwnedFrobot}
            />
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
                    <Grid item xs={6} sm={4} md={4} lg={4} key={index}>
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
                          {equipment.equipment_class} {equipment.equipment_type}
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
                            equipment.equiment_key === activeEquipmentKey
                              ? '4px solid #00AB55'
                              : 'none',
                        }}
                        onClick={() => switchEquipment(equipment)}
                      />
                      {equipment.frobot_id ? (
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
                            Redeploy
                          </Button>
                        </Box>
                      ) : (
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
    </>
  )
}
