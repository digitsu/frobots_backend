import React, { useState } from 'react'
import { Box, Grid, IconButton } from '@mui/material'
import { ArrowBackIos, ArrowForwardIos } from '@mui/icons-material'
import { SliderCardItem } from './CardItem'

const GridList = ({ items, images, buttonLabel, itemWidth, position }) => {
  return (
    <Grid
      container
      spacing={1}
      style={{
        display: 'flex',
        flexWrap: 'nowrap',
        transform: `translateX(-${position}px)`,
        marginLeft: '10px',
      }}
    >
      {items.map((item: any, index: number) => (
        <SliderCardItem
          key={index}
          title={item.title}
          description={item.description}
          backGroundImage={images[item.arena_id]}
          cardWidth={itemWidth}
          actionText={buttonLabel}
          actionUrl={`/arena/${item.id}`}
        />
      ))}
    </Grid>
  )
}

export const GridSlider = ({ items, imageList, actionLabel }) => {
  const [position, setPosition] = useState(0)
  const numItems = items.length
  const gridItemWidth = 300
  const maxPosition = (numItems - 1) * gridItemWidth

  const handlePrevClick = () => {
    if (position > 0) {
      setPosition(position - gridItemWidth)
    }
  }

  const handleNextClick = () => {
    if (position < maxPosition) {
      setPosition(position + gridItemWidth)
    }
  }

  return (
    <Box
      sx={{
        display: 'flex',
        flexWrap: 'nowrap',
        overflow: 'hidden',
        transition: 'transform 0.2s ease-in-out',
        alignItems: 'center',
        justifyContent: 'center',
        position: 'relative',
      }}
    >
      <IconButton
        className="prev-btn"
        onClick={handlePrevClick}
        sx={{
          position: 'absolute',
          top: '50%',
          transform: 'translateY(-50%)',
          width: '40px',
          height: '40px',
          border: 'none',
          borderRadius: '50%',
          backgroundColor: '#161c24',
          boxShadow: '0px 1px 2px rgba(0, 0, 0, 0.2)',
          cursor: 'pointer',
          color: '#FFF',
          zIndex: 5,
          left: 10,
        }}
        disabled={position <= 0}
      >
        <ArrowBackIos />
      </IconButton>
      <GridList
        items={items}
        images={imageList}
        buttonLabel={actionLabel}
        itemWidth={`${gridItemWidth}px`}
        position={position}
      />
      <IconButton
        className="next-btn"
        onClick={handleNextClick}
        sx={{
          position: 'absolute',
          top: '50%',
          transform: 'translateY(-50%)',
          width: '40px',
          height: '40px',
          border: 'none',
          borderRadius: '50%',
          backgroundColor: '#161c24',
          boxShadow: '0px 1px 2px rgba(0, 0, 0, 0.2)',
          cursor: 'pointer',
          color: '#FFF',
          zIndex: 5,
          right: 10,
        }}
        disabled={position >= maxPosition}
      >
        <ArrowForwardIos />
      </IconButton>
    </Box>
  )
}
