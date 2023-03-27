import React from 'react'
import { Grid, Box, Typography } from '@mui/material'
import ViewMore from '../../components/generic/Button/ViewMore'

type BlogPost = {
  id: string
  title: string
  html: string
  feature_image: string
  url: string
}

type NewsAndUpdatesProps = {
  blogPosts: BlogPost[]
}

export default (props: NewsAndUpdatesProps) => {
  const { blogPosts } = props

  return (
    <Box my={4}>
      <Grid container spacing={3}>
        {blogPosts.map((post: BlogPost, index: number) => (
          <Grid item lg={3} md={4} sm={6} xs={12} key={index}>
            <Box position={'relative'}>
              <Box width={'100%'} m={'auto'}>
                <Box
                  borderRadius={2}
                  component={'img'}
                  width={'100%'}
                  src={post.feature_image}
                />
                <Box
                  position={'absolute'}
                  bottom={0}
                  width={'100%'}
                  p={1}
                  sx={{
                    borderRadius: 2,
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
                        {post.title}
                      </Typography>
                    </Box>
                    <Box textAlign={'right'}>
                      {' '}
                      <ViewMore label={'Learn More'} link={post.url} />
                    </Box>
                  </Box>
                </Box>
              </Box>
            </Box>
          </Grid>
        ))}
      </Grid>
    </Box>
  )
}
