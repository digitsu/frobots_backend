import React, { useEffect, useState } from 'react'
import {
  Box,
  Button,
  Card,
  Grid,
  Stack,
  TextField,
  Tooltip,
  Typography,
} from '@mui/material'
import { KeyboardReturnOutlined } from '@mui/icons-material'

interface UserProfileEditProps {
  user: any
  s3_base_url: string
  user_avatars: string[]
  updateUserProfile: any
  updateUserEmail: any
  updateUserPassword: any
  handleEditState: (value?: string) => void
}

export default (props: UserProfileEditProps) => {
  const {
    user,
    s3_base_url,
    user_avatars,
    handleEditState,
    updateUserProfile,
    updateUserEmail,
    updateUserPassword,
  } = props
  const [userImage, setUserImage] = useState('')
  const [newImage, setNewImage] = useState('')
  const [userName, setUserName] = useState('')
  const [userEmail, setUserEmail] = useState('')
  const [currentPassword, setCurrentPassword] = useState('')
  const [currentPassword2, setCurrentPassword2] = useState('')
  const [password, setPassword] = useState('')
  const [confirmPassword, setConfirmPassword] = useState('')

  const generateUserImageUrl = (userImage: string) => {
    let profileImage = 'https://via.placeholder.com/50.png'
    if (userImage && userImage !== profileImage) {
      profileImage = `${s3_base_url}${userImage}`
    }

    return profileImage
  }

  useEffect(() => {
    setUserImage(generateUserImageUrl(user.avatar))
    setNewImage(user.avatar)
    setUserName(user.name)
    setUserEmail(user.email)
  }, [user])

  const handleClickAvatarImage = (avatarUrl: string) => {
    setUserImage(generateUserImageUrl(avatarUrl))
    setNewImage(avatarUrl)
  }

  const updatePlayerAvatar = () => {
    updateUserProfile({
      avatar: newImage,
    })
  }

  const updatePlayerName = () => {
    updateUserProfile({
      name: userName,
    })
  }

  const updatePlayerEmail = () => {
    updateUserEmail({
      user: {
        email: userEmail,
        name: userName,
      },
      current_password: currentPassword,
    })
  }

  const updatePlayerPassword = () => {
    updateUserPassword({
      user: {
        password: password,
        password_confirmation: confirmPassword,
      },
      current_password: currentPassword2,
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
              bgcolor: '#012130',
              borderRadius: 5,
              paddingTop: '50%',
              position: 'relative',
            }}
          >
            <Box
              sx={{
                position: 'absolute',
                top: '50%',
                left: '50%',
                p: 5,
                transform: 'translate(-50%, -50%)',
              }}
              width={'100%'}
              component={'img'}
              src={userImage}
            />
          </Box>

          <Box m={2}>
            <Button
              onClick={updatePlayerAvatar}
              variant="contained"
              sx={{
                px: 5,
                py: 1,
                visibility: 'visible',
                width: '100%',
              }}
            >
              Update Player Avatar
            </Button>
          </Box>

          <Box m={2}>
            <Grid container spacing={4}>
              {user_avatars.map((avatar, index) => (
                <Grid
                  item
                  xs={4}
                  sm={3}
                  md={2}
                  lg={12 / 5}
                  key={index}
                  onClick={() => handleClickAvatarImage(avatar)}
                >
                  <Box
                    width={'100%'}
                    height={'100%'}
                    sx={{
                      m: 2,
                      bgcolor: '#012130',
                      cursor: 'pointer',
                      borderRadius: '10px',
                      paddingTop: '50%',
                      position: 'relative',
                      boxShadow:
                        avatar === newImage ? '0 0 0 2pt #00AB55' : 'none',
                    }}
                  >
                    <Box
                      sx={{ transform: 'translate(-50%, -50%)' }}
                      top={'50%'}
                      left={'50%'}
                      zIndex={1}
                      position={'absolute'}
                      component={'img'}
                      height={'100%'}
                      src={`${s3_base_url}${avatar}`}
                    />
                  </Box>
                </Grid>
              ))}
            </Grid>
          </Box>
        </Card>

        <Card sx={{ p: 3, mt: 2 }}>
          <Box mt={2}>
            <Grid container spacing={2}>
              <Grid item xs={12} md={4}>
                <Typography mb={2} variant={'body2'} fontWeight={'bold'}>
                  Change User name
                </Typography>
              </Grid>
              <Grid item xs={12} sm={12} md={8}>
                <Stack
                  alignItems="center"
                  direction="row"
                  spacing={3}
                  marginBottom={2}
                >
                  <TextField
                    onChange={(evt) => setUserName(evt.target.value)}
                    label={'User Name'}
                    fullWidth
                    value={userName}
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
                    disabled={!userName}
                    onClick={updatePlayerName}
                  >
                    Save
                  </Button>
                </Stack>
              </Grid>
            </Grid>
          </Box>
        </Card>

        <Card sx={{ p: 3, mt: 2 }}>
          <Box mt={2}>
            <Grid container spacing={2}>
              <Grid item xs={12} md={4}>
                <Typography mb={2} variant={'body2'} fontWeight={'bold'}>
                  Change Email
                </Typography>
              </Grid>
              <Grid item xs={12} sm={12} md={8}>
                <Stack
                  alignItems="center"
                  direction="row"
                  spacing={3}
                  marginBottom={2}
                >
                  <TextField
                    onChange={(evt) => setUserEmail(evt.target.value)}
                    label={'Email'}
                    fullWidth
                    value={userEmail}
                  />
                </Stack>
                <Stack
                  alignItems="center"
                  direction="row"
                  spacing={3}
                  marginBottom={2}
                >
                  <TextField
                    type="password"
                    onChange={(evt) => setCurrentPassword(evt.target.value)}
                    label={'Current Password'}
                    fullWidth
                    value={currentPassword}
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
                    disabled={!userEmail || !currentPassword}
                    onClick={updatePlayerEmail}
                  >
                    Save
                  </Button>
                </Stack>
              </Grid>
            </Grid>
          </Box>
        </Card>

        <Card sx={{ p: 3, mt: 2 }}>
          <Box mt={2}>
            <Grid container spacing={2}>
              <Grid item xs={12} md={4}>
                <Stack alignItems="center" direction="row">
                  <Typography mb={2} variant={'body2'} fontWeight={'bold'}>
                    Change Password
                  </Typography>
                  <Tooltip
                    placement="right-start"
                    title="You need to login after successful password update"
                  >
                    <Typography mb={2} variant={'body2'} color={'red'}>
                      &nbsp;*
                    </Typography>
                  </Tooltip>
                </Stack>
              </Grid>
              <Grid item xs={12} sm={12} md={8}>
                <Stack
                  alignItems="center"
                  direction="row"
                  spacing={3}
                  marginBottom={2}
                >
                  <TextField
                    onChange={(evt) => setCurrentPassword2(evt.target.value)}
                    label={'Current Password'}
                    fullWidth
                    value={currentPassword2}
                  />
                </Stack>
                <Stack
                  alignItems="center"
                  direction="row"
                  spacing={3}
                  marginBottom={2}
                >
                  <TextField
                    onChange={(evt) => setPassword(evt.target.value)}
                    label={'New Password'}
                    fullWidth
                    value={password}
                  />
                </Stack>
                <Stack
                  alignItems="center"
                  direction="row"
                  spacing={3}
                  marginBottom={2}
                >
                  <TextField
                    error={
                      confirmPassword ? password !== confirmPassword : false
                    }
                    helperText={
                      confirmPassword && password !== confirmPassword
                        ? 'Password not match'
                        : ''
                    }
                    onChange={(evt) => setConfirmPassword(evt.target.value)}
                    label={'Confirm New Password'}
                    fullWidth
                    value={confirmPassword}
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
                    disabled={
                      !currentPassword2 || !password || !confirmPassword
                    }
                    onClick={updatePlayerPassword}
                  >
                    Save
                  </Button>
                </Stack>
              </Grid>
            </Grid>
          </Box>
        </Card>
      </Box>
    </>
  )
}
