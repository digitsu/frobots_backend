import { Theme } from '@mui/material/styles'

// ----------------------------------------------------------------------

export default function Autocomplete(theme: Theme) {
  return {
    MuiAutocomplete: {
      styleOverrides: {
        root: {
          '& .MuiAutocomplete-option': {
            float: 'none !important',
          },
        },
        paper: {
          boxShadow: theme.customShadows.z20,
        },
      },
    },
  }
}
