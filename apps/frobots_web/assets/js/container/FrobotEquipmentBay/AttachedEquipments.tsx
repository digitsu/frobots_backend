import React, { useState } from 'react'
import {
  Card,
  Typography,
  Box,
  Grid,
  Button,
  ListItem,
  ListItemIcon,
  ListItemText,
  ListItemButton,
} from '@mui/material'
import ChevronLeftIcon from '@mui/icons-material/ChevronLeft'
import ChevronRightIcon from '@mui/icons-material/ChevronRight'
import { FixedSizeList, ListChildComponentProps } from 'react-window'

interface AttachedEquipmentsProps {
  equipments: any[]
  isOwnedFrobot: boolean
}

export default (props: AttachedEquipmentsProps) => {
  const { equipments, isOwnedFrobot } = props
  const [currentEquipment, setCurrentEquipment] = useState(equipments[0])

  const switchEquipment = (index: number) => {
    setCurrentEquipment(equipments[index])
  }

  return (
    <>
      <Grid paddingRight={10} paddingTop={4} item xs={12} sm={12} lg={12}>
        <Card>
          <Grid container spacing={2}>
            <Grid item xs={12} lg={12} md={12} sm={12}>
              <Box
                sx={{
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'space-between',
                  pl: 4,
                  pt: 2,
                  mt: 1,
                  mb: 2,
                }}
              >
                <Box
                  sx={{
                    backgroundColor: '#1C4250',
                    borderRadius: '4px',
                  }}
                >
                  <ChevronLeftIcon
                    sx={{
                      color: '#FFFFFF7E',
                    }}
                  />
                </Box>
                <Typography variant={'subtitle1'}>
                  Attached Equipments (1/2)
                </Typography>
                <Box
                  sx={{
                    mr: 4,
                    backgroundColor: '#1C4250',
                    borderRadius: '4px',
                  }}
                >
                  <ChevronRightIcon
                    sx={{
                      color: '#FFFFFF',
                    }}
                  />
                </Box>
              </Box>
              <Box display={'flex'} justifyContent={'center'}>
                <Box
                  display={'flex'}
                  justifyContent={'start'}
                  sx={{
                    justifyContent: 'start',
                    overflowX: 'scroll',
                    '&::-webkit-scrollbar': {display:'none'},
                  }}
                >
                  {equipments
                    .slice(0, 7)
                    .map((equipment: any, index: number) => (
                      <Box
                        textAlign={'center'}
                        maxWidth={'200px'}
                        minWidth={'200px'}
                        // minheight={'190px'}
                        sx={{ px: 4, pb: 2 }}
                      >
                        <Box pb={1} textAlign={'center'} mt={3}>
                          <Typography
                            color={'#919EAB'}
                            fontWeight={'bold'}
                            variant="subtitle1"
                          >
                            {equipment.name}
                          </Typography>
                        </Box>
                        <Box
                          textAlign={'center'}
                          component={'img'}
                          src={equipment.avatar}
                        />

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
                    ))}
                </Box>
              </Box>
            </Grid>
          </Grid>
        </Card>
      </Grid>
      {/* <Grid
      item
      xs={12}
      sm={12}
      sx={{
        pb: 5,
      }}
    >
      <Card>
        <Grid container spacing={2}>
          <Grid
            item
            xs={12}
            lg={12}
            md={12}
            sm={12}
            sx={{
              pb: 5,
              height: '60vh',
            }}
          >
            <Box
              sx={{
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'space-between',
                pl: 4,
                pt: 2,
                mt: 1,
                mb: 2,
              }}
            >
              <Box
                sx={{
                  backgroundColor: '#1C4250',
                  borderRadius: '4px',
                }}
              >
                <ChevronLeftIcon
                  sx={{
                    color: '#FFFFFF7E',
                  }}
                />
              </Box>
              
              <Box
                sx={{
                  mr: 4,
                  backgroundColor: '#1C4250',
                  borderRadius: '4px',
                }}
              >
                <ChevronRightIcon
                  sx={{
                    color: '#FFFFFF',
                  }}
                />
              </Box>
            </Box>

            <Box
              sx={{
                overflowX: 'scroll',
                '&::-webkit-scrollbar': { display: 'none' },
              }}
            >
              <Box
                sx={{
                  height: '30vh',
                }}
                display={'flex'}
              >
                {equipments.map((equipment: any, index: number) => (
                  <Grid
                    item
                    lg={4}
                    md={8}
                    sm={6}
                    xs={12}
                    key={index}
                    onClick={() => switchEquipment(index)}
                  >
                    <Box sx={{ px: 4, pb: 2 }}>
                      <Box
                        pl={2}
                        sx={{
                          height: '80px',
                        }}
                        component={'img'}
                        src={equipment.avatar}
                      />
                      <Box textAlign={'center'} mt={3}>
                        <Typography fontWeight={'bold'} variant="subtitle1">
                          {equipment.name}
                        </Typography>
                      </Box>
                    </Box>
                  </Grid>
                ))}
              </Box>
            </Box>
          </Grid>
        </Grid>
      </Card>
    </Grid>  */}
      {/* <Box
      display={'flex'}
        sx={{
          width: '100%',
          height: 400,
          bgcolor: 'background.paper',
        }}
      >
        {equipments.map((eq) => (<Box width={400}>
          <ListItem component="div" disablePadding>
            <ListItemButton>
              <ListItemText primary={`Item ${eq.id}`} />
            </ListItemButton>
          </ListItem>
          </Box>
        ))}
      </Box> */}
    </>
  )
}

{
  /* {equipments.map((tool) => {
        console.log(tool);
        
        return (
          <ListItem  key={tool.id} component="div" disablePadding>
            {' '}
            <ListItemText primary={tool.name} />
          </ListItem>
        )
      })} */
}

{
  /* <Grid
      item
      xs={12}
      sm={12}
      sx={{
        pb: 5,
      }}
    >
      <Card>
        <Grid container spacing={2}>
          <Grid
            item
            xs={12}
            lg={12}
            md={12}
            sm={12}
            sx={{
              pb: 5,
              height: '60vh',
            }}
          >
            <Box
              sx={{
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'space-between',
                pl: 4,
                pt: 2,
                mt: 1,
                mb: 2,
              }}
            >
              <Box
                sx={{
                  backgroundColor: '#1C4250',
                  borderRadius: '4px',
                }}
              >
                <ChevronLeftIcon
                  sx={{
                    color: '#FFFFFF7E',
                  }}
                />
              </Box>
              
              <Box
                sx={{
                  mr: 4,
                  backgroundColor: '#1C4250',
                  borderRadius: '4px',
                }}
              >
                <ChevronRightIcon
                  sx={{
                    color: '#FFFFFF',
                  }}
                />
              </Box>
            </Box>

            <Box
              sx={{
                overflowX: 'scroll',
                '&::-webkit-scrollbar': { display: 'none' },
              }}
            >
              <Box
                sx={{
                  height: '30vh',
                }}
                display={'flex'}
              >
                {equipments.map((equipment: any, index: number) => (
                  <Grid
                    item
                    lg={4}
                    md={8}
                    sm={6}
                    xs={12}
                    key={index}
                    onClick={() => switchEquipment(index)}
                  >
                    <Box sx={{ px: 4, pb: 2 }}>
                      <Box
                        pl={2}
                        sx={{
                          height: '80px',
                        }}
                        component={'img'}
                        src={equipment.avatar}
                      />
                      <Box textAlign={'center'} mt={3}>
                        <Typography fontWeight={'bold'} variant="subtitle1">
                          {equipment.name}
                        </Typography>
                      </Box>
                    </Box>
                  </Grid>
                ))}
              </Box>
            </Box>
          </Grid>
        </Grid>
      </Card>
    </Grid> */
}
