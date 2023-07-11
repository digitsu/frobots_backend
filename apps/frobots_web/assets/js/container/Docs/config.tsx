import React from 'react'
import type { ReactNode } from 'react'

interface Item {
  icon?: ReactNode
  items?: Item[]
  label?: ReactNode
  path?: string
  title: string
}

export interface Section {
  items: Item[]
  subheader?: string
}

export const sections: Section[] = [
  {
    subheader: '',
    items: [
      {
        title: 'Getting Started',
        path: 'getting_started',
      },
      {
        title: 'Introduction',
        path: 'introduction',
      },
      {
        title: 'Controlling your Tank',
        path: 'controlling_tank',
      },
      {
        title: 'Cpu Rig Cycles',
        path: 'cpu_rig_cycle',
      },
    ],
  },
]
