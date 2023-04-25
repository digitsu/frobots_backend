import React, { useEffect, useState } from 'react'
import moment from 'moment'
import {
  Box,
  Card,
  Grid,
  Table,
  TableBody,
  TableCell,
  TableRow,
} from '@mui/material'
import { EditOutlined } from '@mui/icons-material'

interface UserProfileProps {
  user: any
  s3_base_url: string
  handleEditState: (value?: string) => void
}

export default (props: UserProfileProps) => {
  const { user, s3_base_url, handleEditState } = props
  const [userImage, setUserImage] = useState('')

  useEffect(() => {
    const gerUserImage = (s3_base_url: string, userImage: string) => {
      let profileImage = 'https://via.placeholder.com/50.png'
      if (userImage && userImage !== profileImage) {
        profileImage = `${s3_base_url}${user.avatar}`
      }

      return profileImage
    }

    setUserImage(gerUserImage(s3_base_url, user.avatar))
  }, [s3_base_url, user])

  return (
    <Box width={'90%'} m={'auto'}>
      <Card>
        <Grid container spacing={2} height={'100%'} alignItems={'center'}>
          <Grid item xs={12} sm={3} md={3} lg={3}>
            <Card
              sx={{
                bgcolor: '#212B36',
                borderRadius: 4,
                paddingTop: '100%',
                position: 'relative',
                boxShadow: 'none',
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
            </Card>
          </Grid>
          <Grid item xs={12} sm={9} md={9} lg={9}>
            <Box
              sx={{
                display: 'flex',
                px: '20px',
                flexDirection: 'row-reverse',
              }}
            >
              <EditOutlined
                fontSize="small"
                sx={{
                  color: '#FFFFFF7E',
                }}
                onClick={() => handleEditState()}
              />
            </Box>
            <Box px={8} py={4}>
              <Table>
                <TableBody>
                  <TableRow>
                    <TableCell>User Name</TableCell>
                    <TableCell>:</TableCell>
                    <TableCell>{user.name || '-'}</TableCell>
                  </TableRow>
                  <TableRow>
                    <TableCell>Email</TableCell>
                    <TableCell>:</TableCell>
                    <TableCell>{user.email}</TableCell>
                  </TableRow>
                  <TableRow>
                    <TableCell>Sparks Available</TableCell>
                    <TableCell>:</TableCell>
                    <TableCell>{user.sparks}</TableCell>
                  </TableRow>
                  <TableRow>
                    <TableCell>Signed From</TableCell>
                    <TableCell>:</TableCell>
                    <TableCell>
                      {moment(user.inserted_at).format('DD MMM YYYY HH:mm:ss')}
                    </TableCell>
                  </TableRow>
                </TableBody>
              </Table>
            </Box>
          </Grid>
        </Grid>
      </Card>
    </Box>
  )
}
