import React, { useEffect, useState } from 'react'
import { Box, Grid, Typography, Button, Card } from '@mui/material'
import ChevronLeftIcon from '@mui/icons-material/ChevronLeft'
import ChevronRightIcon from '@mui/icons-material/ChevronRight'
import EquipmentDetails from './EquipmentDetails'
import { useDispatch, useSelector } from 'react-redux'
import { frobotEquipmentActions } from '../../redux/slices/frobotEquipment'

interface AvailableEquipmentPrpos {
  availableEquipments: any[]
  equipmentsCount: number
  isOwnedFrobot: boolean
  frobotId: string
  imageBaseUrl: string
  attachEquipment: any
  detachEquipment: any
  redeployEquipment: any
}

const itemsPerPage = 6

export default (props: AvailableEquipmentPrpos) => {
  const dispatch = useDispatch()
  const { setCurrentEquipment, setActiveEquipmentKey } = frobotEquipmentActions
  const { activeEquipmentKey } = useSelector(
    (store: any) => store.frobotEquipment
  )

  const {
    availableEquipments,
    equipmentsCount,
    imageBaseUrl,
    isOwnedFrobot,
    attachEquipment,
    frobotId,
    detachEquipment,
    redeployEquipment,
  } = props

  const [leftOffset, setOffsetLeft] = useState(0)
  const [rightOffset, setOffsetRight] = useState(
    equipmentsCount > itemsPerPage ? itemsPerPage : equipmentsCount
  )
  const [currentSection, setCurrentSection] = useState(1)
  const totalSections = Math.ceil(equipmentsCount / itemsPerPage)

  const switchEquipment = (equipment: any) => {
    dispatch(setCurrentEquipment(equipment))
    dispatch(setActiveEquipmentKey(equipment?.equipment_key))
  }

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

  const handleClickPrevious = () => {
    if (leftOffset <= 0) {
      return
    }

    const newLeftOffset =
      leftOffset - itemsPerPage < 0 ? 0 : leftOffset - itemsPerPage
    const equipment = availableEquipments[newLeftOffset]

    setCurrentSection(currentSection - 1)
    setOffsetRight(leftOffset)
    setOffsetLeft(newLeftOffset)
    dispatch(setCurrentEquipment(equipment))
    dispatch(setActiveEquipmentKey(equipment?.equipment_key))
  }

  const handleClickNext = () => {
    if (rightOffset >= equipmentsCount) {
      return
    }

    const newRightOffset =
      rightOffset + itemsPerPage > equipmentsCount
        ? equipmentsCount
        : rightOffset + itemsPerPage
    const equipment = availableEquipments[rightOffset]

    setCurrentSection(currentSection + 1)
    setOffsetLeft(rightOffset)
    setOffsetRight(newRightOffset)
    dispatch(setCurrentEquipment(equipment))
    dispatch(setActiveEquipmentKey(equipment?.equipment_key))
  }

  const handleOnClickAttach = (equipment: any) => {
    attachEquipment({
      id: equipment.id,
      equipment_class: equipment.equipment_class,
      frobot_id: frobotId,
      current_equipment_key: activeEquipmentKey,
    })
  }

  const handleOnClickRedeploy = (equipment: any) => {
    redeployEquipment({
      ...equipment,
      current_frobot_id: frobotId,
      current_equipment_key: activeEquipmentKey,
    })
  }

  return (
    <>
      <Grid container spacing={2}>
        <Grid item xs={12} lg={8} sm={12} md={12}>
          <Card sx={{ height: '100%' }}>
            <EquipmentDetails
              imageBaseUrl={imageBaseUrl}
              isOwnedFrobot={isOwnedFrobot}
              attachEquipment={attachEquipment}
              currentFrobotId={frobotId}
              detachEquipment={detachEquipment}
              redeployEquipment={redeployEquipment}
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
              Available Equipments
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
                        position={'relative'}
                        width={'100%'}
                        height={'60%'}
                        sx={{
                          cursor: 'pointer',
                          borderRadius: '6px',
                          border:
                            equipment.equipment_key === activeEquipmentKey
                              ? '4px solid #00AB55'
                              : '4px solid transparent',
                        }}
                      >
                        {equipment.frobot_name && (
                          <Box
                            sx={{
                              position: 'absolute',
                              borderRadius: '0px 0px 6px 6px',
                              bottom: 0,
                              background: '#7d7d7dab',
                              color: '#FFC107',
                              width: '100%',
                              height: '15%',
                              opacity: 1,
                              textAlign: 'center',
                              textOverflow: 'ellipsis',
                              overflow: 'hidden',
                              whiteSpace: 'nowrap',
                              fontWeight: 'bold',
                              fontSize: '0.8rem',
                            }}
                          >
                            {equipment.frobot_name}
                          </Box>
                        )}

                        <Box
                          borderRadius={'6px'}
                          component={'img'}
                          width={'100%'}
                          height={'100%'}
                          src={`${imageBaseUrl}${equipment.image}`}
                          onClick={() => switchEquipment(equipment)}
                        />
                      </Box>
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
                            onClick={() => handleOnClickRedeploy(equipment)}
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
                            onClick={() => handleOnClickAttach(equipment)}
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
          </Card>
        </Grid>
      </Grid>
    </>
  )
}
