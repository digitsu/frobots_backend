import React, { useState } from 'react'
import { Card, Typography, Box, Grid, Button } from '@mui/material'
import ChevronLeftIcon from '@mui/icons-material/ChevronLeft'
import ChevronRightIcon from '@mui/icons-material/ChevronRight'

interface AttachedEquipmentsProps {
  equipments: any[]
  isOwnedFrobot: boolean
  frobotId: string
  imageBaseUrl: string
}

export default (props: AttachedEquipmentsProps) => {
  const { equipments, imageBaseUrl, isOwnedFrobot } = props
  const itemsPerPage = 8
  const [firstIndex, setfirstIndex] = useState(0)
  const [lastIndex, setlastIndex] = useState(itemsPerPage)

  const totalSections = Math.ceil(equipments?.length / itemsPerPage)
  const [currentSection, setCurrentSection] = useState(1)
  const handlePreviousButton = () => {
    if (currentSection > 1) {
      setCurrentSection(currentSection - 1)
      setfirstIndex(firstIndex - itemsPerPage)
      setlastIndex(lastIndex - itemsPerPage)
    }
  }

  const handleNextButton = () => {
    if (currentSection < totalSections) {
      setCurrentSection(currentSection + 1)
      setfirstIndex(firstIndex + itemsPerPage)
      setlastIndex(lastIndex + itemsPerPage)
    }
  }

  return (
    <>
      <Typography paddingTop={2} variant={'subtitle1'}>
        Attached Equipments
      </Typography>
      <Grid paddingTop={2}>
        {equipments.length ? (
          <Card>
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
                }}
              >
                <ChevronLeftIcon
                  sx={{
                    color: firstIndex === 0 ? '#FFFFFF7E' : '#FFFFFF',
                  }}
                />
              </Box>
              <Grid container spacing={2}>
                {equipments
                  .slice(firstIndex, lastIndex)
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
                            borderRadius: '6px',
                          }}
                        ></Box>
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
                }}
              >
                <ChevronRightIcon
                  sx={{
                    color:
                      equipments.length < lastIndex + 1
                        ? '#FFFFFF7E'
                        : '#FFFFFF',
                  }}
                />
              </Box>
            </Box>
          </Card>
        ) : (
          <Card>
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
          </Card>
        )}
      </Grid>
    </>
  )
}
