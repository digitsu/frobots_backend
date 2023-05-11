import React from 'react'
import { Box, Grid, Typography, Button } from '@mui/material'
import { useSelector } from 'react-redux'

interface EquipmentDetailsPrpos {
  isOwnedFrobot: boolean
  imageBaseUrl: string
  attachEquipment: any
  detachEquipment: any
  redeployEquipment: any
  currentFrobotId: string
}

export default (props: EquipmentDetailsPrpos) => {
  const {
    imageBaseUrl,
    attachEquipment,
    currentFrobotId,
    detachEquipment,
    redeployEquipment,
  } = props
  const { activeEquipment } = useSelector((store: any) => store.frobotEquipment)

  const handleOnClickAttach = () =>
    attachEquipment({
      id: activeEquipment.id,
      equipment_class: activeEquipment.equipment_class,
      frobot_id: currentFrobotId,
    })

  const handleOnClickDetach = () => detachEquipment(activeEquipment)

  const handleOnClickRedeploy = () => {
    redeployEquipment({
      ...activeEquipment,
      current_frobot_id: currentFrobotId,
    })
  }

  return (
    <>
      {activeEquipment ? (
        <Grid container spacing={2}>
          <Grid item xs={12} sm={12} md={6} lg={6}>
            <Box position={'relative'} width={'100%'} m={'auto'}>
              <Box
                component={'img'}
                height={'100%'}
                borderRadius={'16px'}
                src={`${imageBaseUrl}${activeEquipment.image}`}
              ></Box>
            </Box>
          </Grid>
          <Grid item xs={12} sm={12} md={6} lg={6}>
            <Box position={'relative'} height={'100%'}>
              <Box position={'relative'} height={'100%'}>
                <Typography
                  variant="h5"
                  display={'flex'}
                  justifyContent={'center'}
                  width={'100%'}
                  position={'absolute'}
                  top={'10%'}
                >
                  {activeEquipment.equipment_class}{' '}
                  {activeEquipment.equipment_type}
                </Typography>

                <Box
                  sx={{
                    position: 'absolute',
                    left: '50%',
                    top: '50%',
                    px: 4,
                    transform: 'translate(-50%, -50%)',
                    width: '100%',
                  }}
                >
                  {activeEquipment.equipment_class === 'xframe' && (
                    <>
                      <Box
                        sx={{
                          display: 'flex',
                          justifyContent: 'space-between',
                        }}
                      >
                        <Typography my={2} variant="subtitle2">
                          Accel Speed
                        </Typography>
                        <Typography my={2} variant="subtitle2">
                          :
                        </Typography>
                        <Typography my={2} variant="subtitle2">
                          {activeEquipment?.accel_speed_mss} m/s^2
                        </Typography>
                      </Box>
                      <Box
                        sx={{
                          display: 'flex',
                          justifyContent: 'space-between',
                        }}
                      >
                        <Typography my={2} variant="subtitle2">
                          Max Speed
                        </Typography>
                        <Typography my={2} variant="subtitle2">
                          :
                        </Typography>
                        <Typography my={2} variant="subtitle2">
                          {activeEquipment?.max_speed_ms} m/s
                        </Typography>
                      </Box>
                      <Box
                        sx={{
                          display: 'flex',
                          justifyContent: 'space-between',
                        }}
                      >
                        <Typography my={2} variant="subtitle2">
                          Max Throttle
                        </Typography>
                        <Typography my={2} variant="subtitle2">
                          :
                        </Typography>
                        <Typography my={2} variant="subtitle2">
                          {activeEquipment?.max_throttle}
                        </Typography>
                      </Box>
                      <Box
                        sx={{
                          display: 'flex',
                          justifyContent: 'space-between',
                        }}
                      >
                        <Typography my={2} variant="subtitle2">
                          Turn Speed
                        </Typography>
                        <Typography my={2} variant="subtitle2">
                          :
                        </Typography>
                        <Typography my={2} variant="subtitle2">
                          {activeEquipment?.turn_speed}%
                        </Typography>
                      </Box>
                      <Box
                        sx={{
                          display: 'flex',
                          justifyContent: 'space-between',
                        }}
                      >
                        <Typography my={2} variant="subtitle2">
                          Max Health
                        </Typography>
                        <Typography my={2} variant="subtitle2">
                          :
                        </Typography>
                        <Typography my={2} variant="subtitle2">
                          {activeEquipment?.max_health} ap
                        </Typography>
                      </Box>
                    </>
                  )}

                  {activeEquipment.equipment_class === 'cannon' && (
                    <>
                      <Box
                        sx={{
                          display: 'flex',
                          justifyContent: 'space-between',
                        }}
                      >
                        <Typography my={2} variant="subtitle2">
                          Magazine
                        </Typography>
                        <Typography my={2} variant="subtitle2">
                          :
                        </Typography>
                        <Typography my={2} variant="subtitle2">
                          {activeEquipment?.magazine_size}
                        </Typography>
                      </Box>
                      <Box
                        sx={{
                          display: 'flex',
                          justifyContent: 'space-between',
                        }}
                      >
                        <Typography my={2} variant="subtitle2">
                          Reload
                        </Typography>
                        <Typography my={2} variant="subtitle2">
                          :
                        </Typography>
                        <Typography my={2} variant="subtitle2">
                          {activeEquipment?.reload_time} s
                        </Typography>
                      </Box>
                      <Box
                        sx={{
                          display: 'flex',
                          justifyContent: 'space-between',
                        }}
                      >
                        <Typography my={2} variant="subtitle2">
                          Rate of Fire
                        </Typography>
                        <Typography my={2} variant="subtitle2">
                          :
                        </Typography>
                        <Typography my={2} variant="subtitle2">
                          {activeEquipment?.rate_of_fire} s
                        </Typography>
                      </Box>
                    </>
                  )}

                  {activeEquipment.equipment_class === 'scanner' && (
                    <>
                      <Box
                        sx={{
                          display: 'flex',
                          justifyContent: 'space-between',
                        }}
                      >
                        <Typography my={2} variant="subtitle2">
                          Max Range
                        </Typography>
                        <Typography my={2} variant="subtitle2">
                          :
                        </Typography>
                        <Typography my={2} variant="subtitle2">
                          {activeEquipment?.max_range} m
                        </Typography>
                      </Box>
                      <Box
                        sx={{
                          display: 'flex',
                          justifyContent: 'space-between',
                        }}
                      >
                        <Typography my={2} variant="subtitle2">
                          Resolution
                        </Typography>
                        <Typography my={2} variant="subtitle2">
                          :
                        </Typography>
                        <Typography my={2} variant="subtitle2">
                          +/- {activeEquipment?.resolution} deg
                        </Typography>
                      </Box>
                    </>
                  )}

                  {activeEquipment.equipment_class === 'missile' && (
                    <>
                      <Box
                        sx={{
                          display: 'flex',
                          justifyContent: 'space-between',
                        }}
                      >
                        <Typography my={2} variant="subtitle2">
                          Range
                        </Typography>
                        <Typography my={2} variant="subtitle2">
                          :
                        </Typography>
                        <Typography my={2} variant="subtitle2">
                          {activeEquipment?.range} m
                        </Typography>
                      </Box>
                      <Box
                        sx={{
                          display: 'flex',
                          justifyContent: 'space-between',
                        }}
                      >
                        <Typography my={2} variant="subtitle2">
                          Speed
                        </Typography>
                        <Typography my={2} variant="subtitle2">
                          :
                        </Typography>
                        <Typography my={2} variant="subtitle2">
                          {activeEquipment?.speed} m
                        </Typography>
                      </Box>
                      <Box
                        sx={{
                          display: 'flex',
                          justifyContent: 'space-between',
                        }}
                      >
                        <Typography my={2} variant="subtitle2">
                          Direct Damage
                        </Typography>
                        <Typography my={2} variant="subtitle2">
                          :
                        </Typography>
                        <Typography my={2} variant="subtitle2">
                          {activeEquipment?.damage_direct} [range, damage]
                        </Typography>
                      </Box>
                      <Box
                        sx={{
                          display: 'flex',
                          justifyContent: 'space-between',
                        }}
                      >
                        <Typography my={2} variant="subtitle2">
                          Far Damage
                        </Typography>
                        <Typography my={2} variant="subtitle2">
                          :
                        </Typography>
                        <Typography my={2} variant="subtitle2">
                          {activeEquipment?.damage_far}
                        </Typography>
                      </Box>
                      <Box
                        sx={{
                          display: 'flex',
                          justifyContent: 'space-between',
                        }}
                      >
                        <Typography my={2} variant="subtitle2">
                          Near Damage
                        </Typography>
                        <Typography my={2} variant="subtitle2">
                          :
                        </Typography>
                        <Typography my={2} variant="subtitle2">
                          {activeEquipment?.damage_near}
                        </Typography>
                      </Box>
                    </>
                  )}
                </Box>
              </Box>
              <Box
                sx={{
                  position: 'absolute',
                  left: '50%',
                  px: 4,
                  transform: 'translate(-50%, -50%)',
                  width: '100%',
                  bottom: 0,
                }}
              >
                {activeEquipment.frobot_id &&
                  activeEquipment.frobot_id !== currentFrobotId && (
                    <Button
                      variant={'text'}
                      fullWidth
                      sx={{
                        backgroundColor: '#00AB552F',
                        color: '#5BE584',
                        width: '100%',
                      }}
                      onClick={handleOnClickRedeploy}
                    >
                      Redeploy
                    </Button>
                  )}

                {!activeEquipment.frobot_id && (
                  <Button
                    variant={'text'}
                    fullWidth
                    sx={{
                      backgroundColor: '#00AB552F',
                      color: '#5BE584',
                      width: '100%',
                    }}
                    onClick={handleOnClickAttach}
                  >
                    Attach
                  </Button>
                )}

                {activeEquipment.frobot_id === currentFrobotId && (
                  <Button
                    variant={'text'}
                    fullWidth
                    sx={{
                      backgroundColor: '#00AB552F',
                      color: '#5BE584',
                      width: '100%',
                    }}
                    onClick={handleOnClickDetach}
                  >
                    Detach
                  </Button>
                )}
              </Box>
            </Box>
          </Grid>
        </Grid>
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
            {'Please choose an equipment to see the details !'}
          </Typography>
        </Box>
      )}
    </>
  )
}
