import { mount } from '../mounter'
import CreateFrobot from '../container/CreateFrobot'

export default {
  mounted() {
    this.unmountComponent = mount(CreateFrobot)(this.el.id, this.opts())
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
      name: 'CreateFrobot',
    }
  },
}
