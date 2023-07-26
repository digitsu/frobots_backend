import React from 'react'
import { Box, Card, Typography } from '@mui/material'
import ViewMore from '../../components/generic/Button/ViewMore'

interface blogPost {
  excerpt: string
  feature_image: string
  title: string
  url: string
}

interface NewsAndUpdatesProps {
  post: blogPost
}

export default ({ post }: NewsAndUpdatesProps) => {
  return (
    <Card sx={{ mt: 1 }}>
      <Box
        position={'relative'}
        width={'100%'}
        height={'400px'}
        overflow={'hidden'}
        m={'auto'}
      >
        <Box
          borderRadius={2}
          component={'img'}
          width={'100%'}
          height={'100%'}
          sx={{
            objectFit: 'cover',
          }}
          src={post.feature_image || '/images/blog-post-bg.png'}
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
    </Card>
  )
}
