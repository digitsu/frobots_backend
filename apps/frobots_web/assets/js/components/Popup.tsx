import React from 'react'
import {
  Modal,
  Card,
  CardHeader,
  CardContent,
  Box,
  Button,
  Typography,
  Fade,
  styled,
} from '@mui/material'
export default ({
  open,
  cancelAction,
  successAction,
  cancelLabel,
  successLabel,
  label,
  description,
}) => {
  const AnimatedModal = styled(Modal)`
    @keyframes fade-in-bottom {
      from {
        opacity: 0;
        transform: translateY(50px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    /* Other modal styles */
    opacity: 0;
    transform: translateY(50px);
    animation-name: fade-in-bottom;
    animation-duration: 0.3s;
    animation-fill-mode: forwards;
  `
  return (
    <AnimatedModal open={open} onClose={cancelAction}>
      <Fade in={open}>
        <Card
          sx={{
            width: '50%',
            position: 'absolute',
            top: '50%',
            right: '50%',
            transform: `translate(50%,-50%)`,
            p: 3,
          }}
        >
          <CardHeader title={<Typography variant="h5">{label}</Typography>} />
          <CardContent>{description}</CardContent>

          <Box
            mt={3}
            display={'flex'}
            justifyContent={'flex-end'}
            alignItems={'center'}
            gap={1}
          >
            <Button
              sx={{ minWidth: 100 }}
              onClick={cancelAction}
              variant="outlined"
              type="submit"
            >
              {cancelLabel}
            </Button>
            <Button
              onClick={successAction}
              sx={{ minWidth: 100 }}
              variant="contained"
              type="submit"
            >
              {successLabel}
            </Button>
          </Box>
        </Card>
      </Fade>
    </AnimatedModal>
  )
}
