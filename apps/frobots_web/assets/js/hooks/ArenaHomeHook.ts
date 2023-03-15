import { mount } from '../mounter'
import ArenaHome from '../container/Arena'

export default {
  mounted() {
    this.unmountComponent = mount(ArenaHome)(this.el.id, this.opts())
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
      name: 'ArenaHome',
    }
  },
}
