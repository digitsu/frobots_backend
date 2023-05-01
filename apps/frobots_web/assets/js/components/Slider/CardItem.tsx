import React, { FC } from 'react'
import { Box, Card, Grid, Typography } from '@mui/material'
import ViewMore from '../generic/Button/ViewMore'

interface CardItemProps {
  title: string
  description?: string
  backGroundImage: string
  actionUrl?: string
  cardWidth: string
  actionText?: string
}

export const SliderCardItem: FC<CardItemProps> = ({
  cardWidth,
  title,
  description,
  backGroundImage,
  actionUrl,
  actionText,
}) => {
  return (
    <Grid item xs={12} sm={6} md={4} lg={3}>
      <Card
        className="grid-item"
        sx={{
          backgroundColor: '#212B36',
          color: '#fff',
          borderRadius: 4,
          minWidth: cardWidth,
          marginRight: '15px',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          fontSize: '24px',
          fontWeight: 'bold',
          opacity: '1',
          transition: 'opacity 0.2s ease-in-out',
          ':hover': {
            filter: 'drop-shadow(4px 4px 6px orange)',
          },
          '.hidden': {
            opacity: 0,
          },
        }}
      >
        <Box width={'100%'} m={'auto'}>
          <Box
            borderRadius={4}
            component={'img'}
            width={'100%'}
            src={backGroundImage}
          />
          <Box
            position={'absolute'}
            bottom={0}
            width={'100%'}
            p={1}
            sx={{
              borderRadius: 4,
              overflow: 'hidden',
              '::after': {
                content: '""',
                position: 'absolute',
                top: 0,
                left: 0,
                width: '100%',
                height: '100%',
                zIndex: 0,
                backgroundImage:
                  'linear-gradient(180deg, rgba(0, 0, 0, 0) -1.23%, #000000 80%);',
              },
            }}
          >
            <Box
              position={'relative'}
              zIndex={1}
              display={'flex'}
              height={100}
              justifyContent={'space-between'}
              flexDirection={'column'}
            >
              <Box>
                {' '}
                <Typography variant="h6" fontWeight={'bold'}>
                  {title}
                </Typography>
                <Typography
                  variant="caption"
                  textOverflow={'ellipsis'}
                  overflow={'hidden'}
                  whiteSpace={'nowrap'}
                >
                  {description}
                </Typography>
              </Box>
              <Box textAlign={'right'}>
                {' '}
                <ViewMore label={actionText} link={actionUrl} />
              </Box>
            </Box>
          </Box>
        </Box>
      </Card>
    </Grid>
  )
}
