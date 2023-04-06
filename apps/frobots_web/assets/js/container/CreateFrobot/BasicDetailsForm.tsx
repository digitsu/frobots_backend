import React from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { Box, Typography, Autocomplete, TextField, Button } from '@mui/material'
import { createFrobotActions } from '../../redux/slices/createFrobot'
export default (props: any) => {
  const { templates, starterImages } = props
  const templateFrobots =
    templates?.map(({ name, brain_code, blockly_code }, index) => ({
      label: name,
      brain_code,
      blockly_code,
      id: index,
    })) || []
  const dispatch = useDispatch()
  const {
    changeStarterMech,
    incrementStep,
    setFrobotName,
    setBio,
    setBrainCode,
  } = createFrobotActions
  const changeStarterMechHandler = (starterMech) => {
    dispatch(changeStarterMech(starterMech))
  }
  const { starterMech, frobotName, bio, brainCode } = useSelector(
    (store: any) => store.createFrobot
  )
  const selectedMech = starterMech.id
  const starterMechs = starterImages.map((starterImage, index) => ({
    id: index,
    bgUrl: '/images/frobot_bg.png',
    src: starterImage?.avatar,
    pixellatedImage: starterImage?.pixellated_img,
    name: '',
  }))
  return (
    <Box width={'60%'} m={'auto'} mt={10}>
      <Typography mb={2} variant={'body1'} fontWeight={'bold'}>
        Enter Basic Details
      </Typography>
      <Box my={2}>
        <TextField
          onChange={(evt) => dispatch(setFrobotName(evt.target.value))}
          label={'Frobot Name'}
          fullWidth
          value={frobotName}
        />
      </Box>
      <Box my={2}>
        <TextField
          label={'Bio'}
          fullWidth
          onChange={(evt) => dispatch(setBio(evt.target.value))}
          inputProps={{ style: { height: 100 } }}
          multiline
          InputProps={{
            style: { resize: 'none' },
          }}
          value={bio}
        />
      </Box>
      <Box my={2}>
        <Box mb={1}>
          <Typography variant="body2" color={'lightslategray'}>
            Select Starter Mech
          </Typography>
        </Box>
        <Box
          display={'flex'}
          alignItems={'center'}
          justifyContent={'flex-start'}
          gap={4}
        >
          {starterMechs.map((starterMech, index) => (
            <Box onClick={() => changeStarterMechHandler(starterMech)}>
              <Box
                position={'relative'}
                width={100}
                height={100}
                m={'auto'}
                sx={{ cursor: 'pointer' }}
              >
                <Box
                  component={'img'}
                  width={'100%'}
                  src={starterMech.bgUrl}
                  sx={{
                    boxShadow:
                      selectedMech === index ? '0 0 0 2pt #00AB55' : 'none',
                    borderRadius: '6px',
                  }}
                ></Box>
                <Box
                  sx={{ transform: 'translate(-50%, -50%)' }}
                  top={'50%'}
                  left={'50%'}
                  zIndex={1}
                  position={'absolute'}
                  component={'img'}
                  width={'70%'}
                  height={'70%'}
                  src={starterMech.src}
                />
              </Box>
              <Box textAlign={'center'} mt={1}>
                <Typography variant="body2" color={'lightslategray'}>
                  {starterMech.name}
                </Typography>
              </Box>
            </Box>
          ))}
        </Box>
      </Box>
      <Box my={2}>
        <Autocomplete
          id="brain-code"
          key="brain-code"
          options={templateFrobots}
          defaultValue={templateFrobots.find(({ id }) => id === brainCode?.id)}
          onChange={(_item, target) => dispatch(setBrainCode(target))}
          renderInput={(params) => (
            <TextField
              {...params}
              label="Select Brain Code Template"
              name="brain-code-input"
            />
          )}
        />
      </Box>
      <Box mt={6}>
        <Button
          disabled={!(frobotName && Object.keys(brainCode).length > 0)}
          variant="contained"
          fullWidth
          sx={{ py: 1.5, mb: 10 }}
          onClick={() => dispatch(incrementStep())}
        >
          Next
        </Button>
      </Box>
    </Box>
  )
}
