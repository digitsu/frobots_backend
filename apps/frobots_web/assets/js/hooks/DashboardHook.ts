import { mount } from '../mounter'
import Dashboard from '../container/Dashboard'

export default {
  mounted() {
    this.unmountComponent = mount(Dashboard)(this.el.id, this.opts())
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
      name: 'Dashboard',
    }
  },
}
