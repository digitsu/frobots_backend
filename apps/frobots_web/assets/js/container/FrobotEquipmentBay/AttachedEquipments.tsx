import React, { useEffect, useState } from 'react'
import { Card, Typography, Box, Grid, Button } from '@mui/material'
import ChevronLeftIcon from '@mui/icons-material/ChevronLeft'
import ChevronRightIcon from '@mui/icons-material/ChevronRight'
import { useDispatch, useSelector } from 'react-redux'
import { frobotEquipmentActions } from '../../redux/slices/frobotEquipment'

interface AttachedEquipmentsProps {
  equipments: any[]
  equipmentsCount: number
  isOwnedFrobot: boolean
  frobotId: string
  imageBaseUrl: string
  detachEquipment: any
}

const itemsPerPage = 8

export default (props: AttachedEquipmentsProps) => {
  const dispatch = useDispatch()
  const { setCurrentEquipment, setActiveEquipmentKey } = frobotEquipmentActions
  const { activeEquipmentKey } = useSelector(
    (store: any) => store.frobotEquipment
  )
  const {
    detachEquipment,
    equipments,
    equipmentsCount,
    imageBaseUrl,
    isOwnedFrobot,
  } = props
  const [leftOffset, setOffsetLeft] = useState(0)
  const [rightOffset, setOffsetRight] = useState(
    equipmentsCount > itemsPerPage ? itemsPerPage : equipmentsCount
  )
  const [currentSection, setCurrentSection] = useState(1)
  const totalSections = Math.ceil(equipmentsCount / itemsPerPage)

  useEffect(() => {
    let newCurrentSection = currentSection
    let newLeftOffset = leftOffset
    let newRightOffset = rightOffset

    if (currentSection > totalSections) {
      newCurrentSection = currentSection - 1
      newLeftOffset =
        leftOffset - itemsPerPage < 0 ? 0 : leftOffset - itemsPerPage

      newRightOffset = leftOffset
    } else if (currentSection === totalSections) {
      newRightOffset =
        rightOffset + itemsPerPage > equipmentsCount
          ? equipmentsCount
          : rightOffset + itemsPerPage
    }

    if (currentSection === 0) {
      newCurrentSection = 1
      newLeftOffset = 0
      newRightOffset =
        equipmentsCount > itemsPerPage ? itemsPerPage : equipmentsCount
    }

    setCurrentSection(newCurrentSection)
    setOffsetLeft(newLeftOffset)
    setOffsetRight(newRightOffset)
  }, [equipmentsCount])

  const switchEquipment = (equipment: any) => {
    dispatch(setCurrentEquipment(equipment))
    dispatch(setActiveEquipmentKey(equipment?.equipment_key))
  }

  const handlePreviousButton = () => {
    if (leftOffset <= 0) {
      return
    }

    const newLeftOffset =
      leftOffset - itemsPerPage < 0 ? 0 : leftOffset - itemsPerPage
    const equipment = equipments[newLeftOffset]

    setCurrentSection(currentSection - 1)
    setOffsetRight(leftOffset)
    setOffsetLeft(newLeftOffset)
    dispatch(setCurrentEquipment(equipment))
    dispatch(setActiveEquipmentKey(equipment?.equipment_key))
  }

  const handleNextButton = () => {
    if (rightOffset >= equipmentsCount) {
      return
    }

    const newRightOffset =
      rightOffset + itemsPerPage > equipmentsCount
        ? equipmentsCount
        : rightOffset + itemsPerPage
    const equipment = equipments[rightOffset]

    setCurrentSection(currentSection + 1)
    setOffsetLeft(rightOffset)
    setOffsetRight(newRightOffset)
    dispatch(setCurrentEquipment(equipment))
    dispatch(setActiveEquipmentKey(equipment?.equipment_key))
  }

  const handleOnClickDetach = (equipment: any) => {
    detachEquipment(equipment)
  }

  return (
    <>
      <Grid paddingTop={2}>
        <Card>
          <Typography variant={'subtitle1'} pt={2} pb={2} textAlign={'center'}>
            Attached Equipments
          </Typography>
          {equipments.length ? (
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
                onClick={handlePreviousButton}
                sx={{
                  m: '10px',
                  backgroundColor: '#1C4250',
                  borderRadius: '4px',
                  cursor: 'pointer',
                }}
              >
                <ChevronLeftIcon
                  sx={{
                    color: currentSection === 1 ? '#FFFFFF7E' : '#FFFFFF',
                  }}
                />
              </Box>
              <Grid container spacing={2}>
                {equipments
                  .slice(leftOffset, rightOffset)
                  .map((equipment, index) => (
                    <Grid item xs={6} sm={4} md={3} lg={12 / 8} key={index}>
                      <Box pb={1} textAlign={'center'} mt={3}>
                        <Typography
                          sx={{
                            fontSize: '0.8rem',
                            overflow: 'visible',
                            textTransform: 'capitalize',
                          }}
                          gutterBottom
                          color={'#919EAB'}
                          fontWeight={'bold'}
                          variant="subtitle1"
                        >
                          {equipment.equipment_class} {equipment.equipment_type}
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
                          src={`${imageBaseUrl}${equipment.image}`}
                          sx={{
                            cursor: 'pointer',
                            borderRadius: '6px',
                            border:
                              equipment.equipment_key === activeEquipmentKey
                                ? '4px solid #00AB55'
                                : 'none',
                          }}
                          onClick={() => switchEquipment(equipment)}
                        />
                        {isOwnedFrobot && (
                          <Box
                            display="flex"
                            alignItems={'center'}
                            justifyContent={'center'}
                          >
                            <Button
                              variant="text"
                              size="small"
                              sx={{
                                mt: 2,
                                color: '#FFAC82',
                                backgroundColor: '#ff563029',
                                width: '100px',
                              }}
                              onClick={() => handleOnClickDetach(equipment)}
                            >
                              Detach
                            </Button>
                          </Box>
                        )}
                      </Box>
                    </Grid>
                  ))}
              </Grid>
              <Box
                onClick={handleNextButton}
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
                      totalSections === currentSection
                        ? '#FFFFFF7E'
                        : '#FFFFFF',
                  }}
                />
              </Box>
            </Box>
          ) : (
            <Box
              display="flex"
              width={'100%'}
              minHeight={'250px'}
              maxHeight={'250px'}
              alignItems="center"
              justifyContent="center"
            >
              <Typography variant={'subtitle1'}>
                {"Bot doesn't have any attached equipment !"}
              </Typography>
            </Box>
          )}
        </Card>
      </Grid>
    </>
  )
}
