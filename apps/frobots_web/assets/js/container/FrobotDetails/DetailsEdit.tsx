import React, { useEffect, useState } from 'react'
import { Box, Button, Card, Grid, Stack, TextField } from '@mui/material'
import { KeyboardReturnOutlined } from '@mui/icons-material'

interface FrobotEditProps {
  frobot: any
  s3_base_url: string
  avatar_images: string[]
  updateFrobotDetails: any
  handleEditState: (value?: string) => void
}

export default (props: FrobotEditProps) => {
  const {
    frobot,
    s3_base_url,
    avatar_images,
    handleEditState,
    updateFrobotDetails,
  } = props
  const [frobotAvatar, setFrobotAvatar] = useState({
    avatar: '',
    pixellated_img: '',
  })
  const [frobotName, setFrobotName] = useState('')
  const [frobotBio, setFrobotBio] = useState('')

  useEffect(() => {
    setFrobotName(frobot.name)
    setFrobotBio(frobot.bio)
    setFrobotAvatar({
      avatar: frobot.avatar,
      pixellated_img: frobot.pixellated_img,
    })
  }, [frobot])

  const handleClickAvatarImage = (data: any) => {
    setFrobotAvatar({
      avatar: data.avatar,
      pixellated_img: data.pixellated_img,
    })
  }

  const updateDetails = () => {
    updateFrobotDetails({
      name: frobotName,
      bio: frobotBio,
      avatar: frobotAvatar?.avatar,
      pixellated_img: frobotAvatar?.pixellated_img,
      frobot_id: frobot.frobot_id,
    })
  }

  return (
    <>
      <Box width={'60%'} m={'auto'} mt={5}>
        <Card sx={{ p: 6 }}>
          <Box
            sx={{
              display: 'flex',
              px: '20px',
              flexDirection: 'row',
            }}
          >
            <KeyboardReturnOutlined
              fontSize="small"
              sx={{
                color: '#FFFFFF7E',
              }}
              onClick={() => handleEditState()}
            />
          </Box>
          <Box
            width={'50%'}
            m={'auto'}
            sx={{
              borderRadius: 4,
              paddingTop: '50%',
              position: 'relative',
            }}
          >
            <Box
              component={'img'}
              src={'/images/frobot_bg.png'}
              width="100%"
              height="100%"
              sx={{
                position: 'absolute',
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
              }}
            />
            <Box
              sx={{
                position: 'absolute',
                top: '50%',
                left: '50%',
                transform: 'translate(-50%, -50%)',
                objectFit: 'cover',
                borderRadius: 3,
              }}
              width={'100%'}
              height={'100%'}
              component={'img'}
              src={`${s3_base_url}${frobotAvatar?.avatar}`}
            />
          </Box>

          <Box m={2}>
            <Button
              onClick={updateDetails}
              variant="contained"
              sx={{
                px: 5,
                py: 1,
                visibility: 'visible',
                width: '100%',
              }}
            >
              Update Frobot Avatar
            </Button>
          </Box>

          <Box m={2}>
            <Grid
              container
              spacing={4}
              sx={{
                minHeight: '350px',
                maxHeight: '350px',
                overflowY: 'scroll',
              }}
            >
              {avatar_images.map((data: any, index) => (
                <Grid
                  item
                  xs={4}
                  sm={3}
                  md={2}
                  lg={12 / 5}
                  key={index}
                  onClick={() => handleClickAvatarImage(data)}
                >
                  <Box
                    position={'relative'}
                    width={'100%'}
                    height={'100%'}
                    m={'auto'}
                    sx={{ cursor: 'pointer' }}
                  >
                    <Box
                      component={'img'}
                      width={'100%'}
                      height={'100%'}
                      src={'/images/frobot_bg.png'}
                      sx={{
                        boxShadow:
                          data.avatar === frobotAvatar.avatar
                            ? '0 0 0 2pt #00AB55'
                            : 'none',
                        borderRadius: '6px',
                        objectFit: 'cover',
                      }}
                    />
                    <Box
                      sx={{
                        transform: 'translate(-50%, -50%)',
                        borderRadius: '6px',
                        objectFit: 'cover',
                      }}
                      top={'50%'}
                      left={'50%'}
                      zIndex={1}
                      position={'absolute'}
                      component={'img'}
                      width={'100%'}
                      height={'100%'}
                      src={`${s3_base_url}${data.avatar}`}
                    />
                  </Box>
                </Grid>
              ))}
            </Grid>
          </Box>
        </Card>

        <Card sx={{ p: 3, mt: 2 }}>
          <Box mt={2}>
            <Stack
              alignItems="center"
              direction="row"
              spacing={3}
              marginBottom={2}
            >
              <TextField
                onChange={(evt) => setFrobotName(evt.target.value)}
                label={'Frobot Name'}
                fullWidth
                value={frobotName}
                error={!frobotName}
                helperText={!frobotName ? 'Required field frobot name' : ''}
              />
            </Stack>
            <Stack
              alignItems="center"
              direction="row"
              spacing={3}
              marginBottom={2}
            >
              <TextField
                onChange={(evt) => setFrobotBio(evt.target.value)}
                label={'Bio'}
                fullWidth
                multiline
                value={frobotBio}
                inputProps={{ style: { height: 100, resize: 'none' } }}
              />
            </Stack>
            <Stack
              alignItems="center"
              direction="row"
              spacing={3}
              marginBottom={2}
            >
              <Button
                variant="outlined"
                disabled={!frobotName}
                onClick={updateDetails}
                sx={{
                  px: 5,
                  py: 1,
                  visibility: 'visible',
                  width: '100%',
                }}
              >
                Save
              </Button>
            </Stack>
          </Box>
        </Card>
      </Box>
    </>
  )
}
