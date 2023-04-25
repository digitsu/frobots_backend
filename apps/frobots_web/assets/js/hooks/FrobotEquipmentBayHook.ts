import { mount } from '../mounter'
import FrobotEquipmentBay from '../container/FrobotEquipmentBay'

export default {
  mounted() {
    this.pushEventTo(this.el, 'react.fetch_frobot_equipment_bay_details')
    this.handleEvent(
      'react.return_frobot_equipment_bay_details',
      (EquipmentDetails: any) => {
        this.unmountComponent = mount(FrobotEquipmentBay)(
          this.el.id,
          this.opts({ ...EquipmentDetails })
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

  opts(EquipmentDetails: any) {
    return {
      name: 'FrobotEquipmentBay',
      ...EquipmentDetails,
    }
  },
}
