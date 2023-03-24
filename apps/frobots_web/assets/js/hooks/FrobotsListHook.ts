import { mount } from '../mounter'
import FrobotsList from '../container/FrobotsList'

export default {
  mounted() {
    this.pushEventTo(this.el, 'react.fetch_user_frobots')
    this.handleEvent('react.return_user_frobots', (frobots: any) => {
      this.unmountComponent = mount(FrobotsList)(
        this.el.id,
        this.opts({ ...frobots })
      )
    })
  },

  destroyed() {
    if (!this.unmountComponent) {
      console.error('Component unmounted')
      return
    }

    this.unmountComponent(this.el)
  },

  opts(frobots: any) {
    return {
      name: 'FrobotsList',
      ...frobots,
    }
  },
}
