import React from 'react'
import { Box, Grid, Typography } from '@mui/material'
import ViewMore from '../../components/generic/Button/ViewMore'
import { getBlogPostImage } from '../../utils/util'

type BlogPost = {
  id: string
  title: string
  html: string
  feature_image: string
  url: string
  excerpt: string
}

type NewsAndUpdatesProps = {
  blogPosts: BlogPost[]
}

export default (props: NewsAndUpdatesProps) => {
  const { blogPosts } = props

  return (
    <>
      <Box width={'90%'} m={'auto'}>
        <Grid container spacing={2} my={2}>
          {blogPosts.map((post: BlogPost, index: number) => (
            <Grid item lg={3} md={4} sm={6} xs={12} key={index}>
              <Box position={'relative'}>
                <Box width={'100%'} m={'auto'}>
                  <Box
                    borderRadius={2}
                    component={'img'}
                    width={'100%'}
                    height={'350px'}
                    src={post.feature_image || getBlogPostImage()}
                  />
                  <Box
                    position={'absolute'}
                    bottom={0}
                    width={'100%'}
                    p={2}
                    sx={{
                      borderRadius: 1,
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
                      justifyContent={'space-between'}
                      flexDirection={'column'}
                    >
                      <Box>
                        <Box mb={2}>
                          <Typography variant="h6" fontWeight={'bold'}>
                            {post.title}
                          </Typography>
                        </Box>
                        <Typography
                          variant="body2"
                          color={'lightslategray'}
                          textOverflow={'ellipsis'}
                          overflow={'hidden'}
                          whiteSpace={'nowrap'}
                        >
                          {post.excerpt}
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

          {!blogPosts.length && (
            <Box
              display="flex"
              width={'100%'}
              minHeight={'250px'}
              maxHeight={'250px'}
              alignItems="center"
              justifyContent="center"
            >
              <Typography variant={'subtitle1'}>{'Empty blogs'}</Typography>
            </Box>
          )}
        </Grid>
      </Box>
    </>
  )
}
