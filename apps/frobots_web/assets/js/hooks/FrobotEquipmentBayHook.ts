import { mount } from '../mounter'
import FrobotEquipmentBay from '../container/FrobotEquipmentBay'

export default {
  mounted() {
    this.pushEventTo(this.el, 'react.fetch_frobot_equipment_bay_details')
    this.handleEvent(
      'react.return_frobot_equipment_bay_details',
      (frobotEqDetails: any) => {
        this.unmountComponent = mount(FrobotEquipmentBay)(
          this.el.id,
          this.opts({ ...frobotEqDetails })
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

  opts(frobotEqDetails: any) {
    return {
      name: 'FrobotEquipmentBay',
      ...frobotEqDetails,
    }
  },
}
