import React, { useMemo, ReactNode } from 'react'
// material
import {
  CssBaseline,
  ThemeProvider,
  ThemeOptions,
  createTheme,
  StyledEngineProvider,
} from '@mui/material'

// hooks

//
import shape from './shape'
import palette from './palette'
import typography from './typography'
import breakpoints from './breakpoints'
import GlobalStyles from './globalStyles'
import componentsOverride from './overrides'
import shadows, { customShadows } from './shadows'

// ----------------------------------------------------------------------

type ThemeConfigProps = {
  children: ReactNode
}

export default function ThemeConfig({ children }: ThemeConfigProps) {
  const { themeMode, themeDirection } = {
    themeMode: 'dark',
    themeDirection: 'ltr',
  }

  const isLight = themeMode === 'light'

  const themeOptions: ThemeOptions = useMemo(
    () => ({
      palette: isLight
        ? { ...palette.light, mode: 'light' }
        : { ...palette.dark, mode: 'dark' },
      shape,
      typography,
      breakpoints,
      direction: 'ltr',
      shadows: isLight ? shadows.light : shadows.dark,
      customShadows: isLight ? customShadows.light : customShadows.dark,
    }),
    [isLight, themeDirection]
  )

  const theme = createTheme(themeOptions)
  theme.components = componentsOverride(theme)

  return (
    <StyledEngineProvider injectFirst={false}>
      <ThemeProvider theme={theme}>
        <CssBaseline />
        <GlobalStyles />
        {children}
      </ThemeProvider>
    </StyledEngineProvider>
  )
}
