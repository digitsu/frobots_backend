import { mount } from '../mounter'
import FrobotDetails from '../container/FrobotDetails'

export default {
  mounted() {
    this.unmountComponent = mount(FrobotDetails)(this.el.id, this.opts())
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
      name: 'FrobotDetails',
    }
  },
}
