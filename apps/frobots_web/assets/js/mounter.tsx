// assets/js/mounter.tsx

import React from 'react'
import { render, unmountComponentAtNode } from 'react-dom'

export const mount = (Component) => (id: string, opts) => {
  const rootElement = document.getElementById(id)
  render(
    <>
      <Component {...opts} />
    </>,
    rootElement
  )
  return (el: Element) => {
    if (!unmountComponentAtNode(el)) {
      console.warn('unmount failed', el)
    }
  }
}
