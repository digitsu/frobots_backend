import React from 'react'
import { Grid, Box, Card, Typography, Button } from '@mui/material'
import { generateRandomString } from '../../utils/util'
import FrobotAdvancedDetails from './FrobotAdvancedDetails'
import { EditOutlined } from '@mui/icons-material'

interface frobotDetailsProps {
  frobotDetails: any
  currentUser: any
  isOwnedFrobot: boolean
  imageBaseUrl: string
  xFrameDetails: any
  handleEditState: (value?: string) => void
}

export default (props: frobotDetailsProps) => {
  const {
    frobotDetails,
    isOwnedFrobot,
    imageBaseUrl,
    xFrameDetails,
    handleEditState,
  } = props

  return (
    <Grid container mb={2} spacing={2}>
      <Grid item lg={4} md={12} sm={12} xs={12}>
        <Card
          sx={{
            bgcolor: '#212B36',
            borderRadius: 4,
            paddingTop: '100%',
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
          ></Box>
          <Box
            sx={{
              position: 'absolute',
              top: '50%',
              left: '50%',
              transform: 'translate(-50%, -50%)',
              objectFit: 'cover',
            }}
            component={'img'}
            width={'100%'}
            src={`${imageBaseUrl}${frobotDetails.avatar}`}
          ></Box>
        </Card>
      </Grid>

      <Grid item lg={4} md={6} sm={6} xs={12}>
        <Card
          sx={{
            bgcolor: '#212B36',
            borderRadius: 4,
            paddingTop: '100%',
            overflowY: 'scroll',
            '&::-webkit-scrollbar': { display: 'none' },
            position: 'relative',
            '@media (max-width: 600px)': {
              paddingTop: '50%',
            },
          }}
        >
          <Box
            sx={{
              position: 'absolute',
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              p: 4,
            }}
          >
            {isOwnedFrobot && (
              <Box
                sx={{
                  display: 'flex',
                  px: '13px',
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
            )}

            <Typography variant="h6" component="h2" gutterBottom>
              Name
            </Typography>
            <Typography variant="body1" gutterBottom mt={1}>
              {frobotDetails.name}
            </Typography>
            <Typography variant="h6" gutterBottom mt={2}>
              Hash
            </Typography>
            <Typography variant="body2" gutterBottom>
              #{generateRandomString(31)}
            </Typography>
            <Typography variant="h6" gutterBottom mt={2}>
              Xframe
            </Typography>
            <Box display={'flex'} alignItems={'baseline'}>
              <Typography pr={2} variant="body2" gutterBottom>
                {xFrameDetails?.equipment_type || '-'}
              </Typography>
              {frobotDetails.isBoost && (
                <Button
                  color="warning"
                  size="small"
                  style={{ fontSize: '12px', padding: '4px 8px' }}
                >
                  Boost
                </Button>
              )}
            </Box>

            <Typography variant="h6" gutterBottom>
              Bio
            </Typography>
            <Box
              sx={{
                height: 100,
                overflowY: 'scroll',
                '&::-webkit-scrollbar': { display: 'none' },
              }}
            >
              <Typography variant="body2" gutterBottom>
                {frobotDetails.bio || '-'}
              </Typography>
            </Box>
          </Box>
        </Card>
      </Grid>

      <FrobotAdvancedDetails
        frobotDetails={frobotDetails}
        isOwnedFrobot={isOwnedFrobot}
        xFrameDetails={xFrameDetails}
      />
    </Grid>
  )
}
