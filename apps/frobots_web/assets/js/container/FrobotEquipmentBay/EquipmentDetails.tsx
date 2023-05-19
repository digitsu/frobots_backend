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
  const { activeEquipment, activeEquipmentKey } = useSelector(
    (store: any) => store.frobotEquipment
  )

  const handleOnClickAttach = () =>
    attachEquipment({
      id: activeEquipment.id,
      equipment_class: activeEquipment.equipment_class,
      frobot_id: currentFrobotId,
      current_equipment_key: activeEquipmentKey,
    })

  const handleOnClickDetach = () =>
    detachEquipment({
      ...activeEquipment,
      current_equipment_key: activeEquipmentKey,
    })

  const handleOnClickRedeploy = () => {
    redeployEquipment({
      ...activeEquipment,
      current_frobot_id: currentFrobotId,
      current_equipment_key: activeEquipmentKey,
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
                  textTransform={'capitalize'}
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
                    <Box>
                      <Grid container spacing={3} pl={4}>
                        <Grid item xs={4}>
                          <Box textAlign="left">
                            <Typography my={4} variant="subtitle2">
                              Accel Speed
                            </Typography>
                            <Typography my={4} variant="subtitle2">
                              Max Speed
                            </Typography>
                            <Typography my={4} variant="subtitle2">
                              Max Throttle
                            </Typography>
                            <Typography my={4} variant="subtitle2">
                              Turn Speed
                            </Typography>
                            <Typography my={4} variant="subtitle2">
                              Max Health
                            </Typography>
                            <Typography my={4} variant="subtitle2">
                              Attached Frobot
                            </Typography>
                          </Box>
                        </Grid>
                        <Grid item>
                          <Box textAlign="center">
                            <Typography my={4} variant="subtitle2">
                              :
                            </Typography>
                            <Typography my={4} variant="subtitle2">
                              :
                            </Typography>
                            <Typography my={4} variant="subtitle2">
                              :
                            </Typography>
                            <Typography my={4} variant="subtitle2">
                              :
                            </Typography>
                            <Typography my={4} variant="subtitle2">
                              :
                            </Typography>
                            <Typography my={4} variant="subtitle2">
                              :
                            </Typography>
                          </Box>
                        </Grid>
                        <Grid pr={4} item xs={7}>
                          <Box textAlign="right">
                            <Typography my={4} variant="body2">
                              {activeEquipment?.accel_speed_mss} m/s^2
                            </Typography>
                            <Typography my={4} variant="body2">
                              {activeEquipment?.max_speed_ms} m/s
                            </Typography>
                            <Typography my={4} variant="body2">
                              {activeEquipment?.max_throttle}
                            </Typography>
                            <Typography my={4} variant="body2">
                              {activeEquipment?.turn_speed}%
                            </Typography>
                            <Typography my={4} variant="body2">
                              {activeEquipment?.max_health} ap
                            </Typography>
                            <Typography my={4} variant="body2">
                              {activeEquipment?.frobot_name || 'Unattached'}
                            </Typography>
                          </Box>
                        </Grid>
                      </Grid>
                    </Box>
                  )}
                  {activeEquipment.equipment_class === 'cannon' && (
                    <Box>
                      <Grid container spacing={3} pl={4}>
                        <Grid item xs={4}>
                          <Box textAlign="left">
                            <Typography my={4} variant="subtitle2">
                              Magazine
                            </Typography>
                            <Typography my={4} variant="subtitle2">
                              Reload
                            </Typography>
                            <Typography my={4} variant="subtitle2">
                              Rate of Fire
                            </Typography>
                            <Typography my={4} variant="subtitle2">
                              Attached Frobot
                            </Typography>
                          </Box>
                        </Grid>
                        <Grid item>
                          <Box textAlign="center">
                            <Typography my={4} variant="subtitle2">
                              :
                            </Typography>
                            <Typography my={4} variant="subtitle2">
                              :
                            </Typography>
                            <Typography my={4} variant="subtitle2">
                              :
                            </Typography>

                            <Typography my={4} variant="subtitle2">
                              :
                            </Typography>
                          </Box>
                        </Grid>
                        <Grid pr={4} item xs={7}>
                          <Box textAlign="right">
                            <Typography my={4} variant="body2">
                              {activeEquipment?.magazine_size}
                            </Typography>
                            <Typography my={4} variant="body2">
                              {activeEquipment?.reload_time} s
                            </Typography>
                            <Typography my={4} variant="body2">
                              {activeEquipment?.rate_of_fire} s
                            </Typography>

                            <Typography my={4} variant="body2">
                              {activeEquipment?.frobot_name || 'Unattached'}
                            </Typography>
                          </Box>
                        </Grid>
                      </Grid>
                    </Box>
                  )}
                  {activeEquipment.equipment_class === 'scanner' && (
                    <Box>
                      <Grid container spacing={2} pl={4}>
                        <Grid item xs={4}>
                          <Box textAlign="left">
                            <Typography my={4} variant="subtitle2">
                              Max Range
                            </Typography>
                            <Typography my={4} variant="subtitle2">
                              Resolution
                            </Typography>
                            <Typography my={4} variant="subtitle2">
                              Attached Frobot
                            </Typography>
                          </Box>
                        </Grid>
                        <Grid item>
                          <Box textAlign="center">
                            <Typography my={4} variant="subtitle2">
                              :
                            </Typography>
                            <Typography my={4} variant="subtitle2">
                              :
                            </Typography>
                            <Typography my={4} variant="subtitle2">
                              :
                            </Typography>
                          </Box>
                        </Grid>
                        <Grid pr={4} item xs={7}>
                          <Box textAlign="right">
                            <Typography my={4} variant="body2">
                              {activeEquipment?.max_range} m
                            </Typography>
                            <Typography my={4} variant="body2">
                              +/- {activeEquipment?.resolution} deg
                            </Typography>
                            <Typography my={4} variant="body2">
                              {activeEquipment?.frobot_name || 'Unattached'}
                            </Typography>
                          </Box>
                        </Grid>
                      </Grid>
                    </Box>
                  )}
                  {activeEquipment.equipment_class === 'missile' && (
                    <Box>
                      <Grid container spacing={2} pl={4}>
                        <Grid item xs={4}>
                          <Box textAlign="left">
                            <Typography my={4} variant="subtitle2">
                              Range
                            </Typography>
                            <Typography my={4} variant="subtitle2">
                              Speed
                            </Typography>
                            <Typography my={4} variant="subtitle2">
                              Direct Damage
                            </Typography>
                            <Typography my={4} variant="subtitle2">
                              Far Damage
                            </Typography>
                            <Typography my={4} variant="subtitle2">
                              Near Damage
                            </Typography>
                            <Typography my={4} variant="subtitle2">
                              Attached Frobot
                            </Typography>
                          </Box>
                        </Grid>
                        <Grid item>
                          <Box textAlign="center">
                            <Typography my={4} variant="subtitle2">
                              :
                            </Typography>
                            <Typography my={4} variant="subtitle2">
                              :
                            </Typography>
                            <Typography my={4} variant="subtitle2">
                              :
                            </Typography>
                            <Typography my={4} variant="subtitle2">
                              :
                            </Typography>
                            <Typography my={4} variant="subtitle2">
                              :
                            </Typography>
                            <Typography my={4} variant="subtitle2">
                              :
                            </Typography>
                          </Box>
                        </Grid>
                        <Grid pr={4} item xs={7}>
                          <Box textAlign="right">
                            <Typography my={4} variant="body2">
                              {activeEquipment?.range} m
                            </Typography>
                            <Typography my={4} variant="body2">
                              {activeEquipment?.speed} m
                            </Typography>
                            <Typography my={4} variant="body2">
                              {activeEquipment?.damage_direct} [range, damage]
                            </Typography>
                            <Typography my={4} variant="body2">
                              {activeEquipment?.damage_far}
                            </Typography>
                            <Typography my={4} variant="body2">
                              {activeEquipment?.damage_near}
                            </Typography>
                            <Typography my={4} variant="body2">
                              {activeEquipment?.frobot_name || 'Unattached'}
                            </Typography>
                          </Box>
                        </Grid>
                      </Grid>
                    </Box>
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
                  bottom: 10,
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
