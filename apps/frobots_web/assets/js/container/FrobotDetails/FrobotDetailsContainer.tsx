import { Grid, Box, Card, Typography, CardContent, Chip, Button, Table, TableCell, TableRow, TableBody } from "@mui/material"
import React from "react"
import AttachedEquipments from "./AttachedEquipments"
import FrobotAdvancedDetails from "./FrobotAdvancedDetails"

const basicDetails = {
  name: 'X-Tron',
  hash: '867c8da2de2f26216b74d11310b89e6a',
  mech: 'Mech MK2',
  isBoost: true,
  bio: 'XTron is a revolutionary new robot that combines the latest in artificial intelligence and robotics technology to bring you an interactive and intelligent companion. This innovative device is designed to bring a new level of fun and excitement to your life. With its sleek, modern design and intuitive controls, the Frobot is easy to use and operate.',
}

export default ()=>{
    return (
      <Grid container pb={2} spacing={2}>
        <Grid item lg={4} md={4} sm={12} xs={12}>
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
                p: 5,
                transform: 'translate(-50%, -50%)',
              }}
              component={'img'}
              width={'100%'}
              src={'/images/frobot1.png'}
            ></Box>
          </Card>
        </Grid>

        <Grid item lg={4} md={4} sm={12} xs={12}>
          
            <Card
              sx={{
                overflowY: 'scroll',
                bgcolor: '#212B36',
                borderRadius: 4,
                paddingTop: '100%',
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
                <Typography variant="h6" component="h2" gutterBottom>
                  Name
                </Typography>
                <Typography variant="body1" gutterBottom mt={1}>
                  {basicDetails.name}
                </Typography>
                <Typography variant="h6" gutterBottom mt={2}>
                  Hash
                </Typography>
                <Typography variant="body2" gutterBottom>
                  #{basicDetails.hash}
                </Typography>
                <Typography variant="h6" gutterBottom mt={2}>
                  Mech/Tank
                </Typography>
                <Box display={'flex'} alignItems={'center'}>
                  <Typography pr={2} variant="body2" gutterBottom>
                    {basicDetails.mech}
                  </Typography>
                  {basicDetails.isBoost && (
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
                <Box sx={{ height: 100, overflowY: 'scroll' }}>
                  <Typography variant="body2" gutterBottom>
                    {basicDetails.bio}
                  </Typography>
                </Box>
              </Box>
            </Card>
        </Grid>

        <FrobotAdvancedDetails />
        <AttachedEquipments />
      </Grid>
    )
    
}