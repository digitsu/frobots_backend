import { mount } from '../mounter'
import FrobotBrainCode from '../container/FrobotDetails/BrainCode'

export default {
  mounted() {
    this.unmountComponent = mount(FrobotBrainCode)(this.el.id, this.opts())
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
      name: 'FrobotBrainCode',
    }
  },
}
