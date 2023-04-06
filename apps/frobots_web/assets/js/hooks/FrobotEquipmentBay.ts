import { mount } from '../mounter'
import FrobotDetails from '../container/FrobotDetails'
import FrobotEquipmentBay from '../container/FrobotEquipmentBay'

export default {
  mounted() {
    this.unmountComponent = mount(FrobotEquipmentBay)(this.el.id, this.opts())
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
      name: 'FrobotEquipmentBay',
    }
  },
}
