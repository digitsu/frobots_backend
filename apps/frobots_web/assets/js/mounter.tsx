// assets/js/mounter.tsx

import React from 'react'
import { render, unmountComponentAtNode } from 'react-dom'
import { Provider } from 'react-redux'
import { store } from './redux/store'

export const mount = (Component) => (id: string, opts) => {
  const rootElement = document.getElementById(id)
  render(
    <>
      <Provider store={store}>
        <Component {...opts} />
      </Provider>
    </>,
    rootElement
  )
  return (el: Element) => {
    if (!unmountComponentAtNode(el)) {
      console.warn('unmount failed', el)
    }
  }
}
