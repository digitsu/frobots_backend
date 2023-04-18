import { mount } from '../mounter'
import FrobotEquipments from '../container/FrobotEquipments'

export default {
  mounted() {
    this.pushEventTo(this.el, 'react.fetch_frobot_equipments_details')
    this.handleEvent(
      'react.return_frobot_equipments_details',
      (details: any) => {
        this.unmountComponent = mount(FrobotEquipments)(
          this.el.id,
          this.opts({ ...details })
        )
      }
    )
  },

  destroyed() {
    if (!this.unmountComponent) {
      console.error('Component unmounted')
      return
    }

    this.unmountComponent(this.el)
  },

  opts(frobotEquipments: any) {
    return {
      name: 'FrobotEquipments',
      ...frobotEquipments,
    }
  },
}
