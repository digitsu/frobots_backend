import { mount } from '../mounter'
import FrobotsList from '../container/FrobotsList'

export default {
  mounted() {
    this.unmountComponent = mount(FrobotsList)(this.el.id, this.opts())
  },

  destroyed() {
    if (!this.unmountComponent) {
      console.error('Component unmounted')
      return
    }

    this.unmountComponent(this.el)
  },
  opts() {
    return {
      name: 'FrobotsList',
    }
  },
}
