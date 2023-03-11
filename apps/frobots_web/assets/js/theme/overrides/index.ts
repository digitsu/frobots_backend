import { merge } from 'lodash'
import { Theme } from '@mui/material/styles'
import Card from './Card'
import Tabs from './Tabs'
import Grid from './Grid'
import Table from './Table'
import Paper from './Paper'
import Input from './Input'
import Button from './Button'
import Tooltip from './Tooltip'
import Stepper from './Stepper'
import Typography from './Typography'
import Pagination from './Pagination'
import Autocomplete from './Autocomplete'

// ----------------------------------------------------------------------

export default function ComponentsOverrides(theme: Theme) {
  return merge(
    Tabs(theme),

    Card(theme),

    Grid(),
    Input(theme),

    Table(theme),
    Paper(),

    Button(theme),

    Stepper(theme),
    Tooltip(theme),

    Typography(theme),
    Pagination(theme),

    Autocomplete(theme)
  )
}
