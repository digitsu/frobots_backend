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

  detachEquipment(params: any) {
    if (params.equipment_class === 'xframe') {
      this.pushEventTo(this.el, 'react.detach_frobot_xframe', params)
    } else {
      this.pushEventTo(this.el, 'react.detach_frobot_equipments', params)
    }
  },

  attachEquipment(params: any) {
    if (params.equipment_class === 'xframe') {
      this.pushEventTo(this.el, 'react.frobot_equipy_xframe', params)
    } else {
      this.pushEventTo(this.el, 'react.frobot_equipy_equipment', params)
    }
  },

  redeployEquipment(params: any) {
    if (params.equipment_class === 'xframe') {
      this.pushEventTo(this.el, 'react.frobot_redeploy_xframe', params)
    } else {
      this.pushEventTo(this.el, 'react.frobot_redeploy_equipment', params)
    }
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
      detachEquipment: this.detachEquipment.bind(this),
      attachEquipment: this.attachEquipment.bind(this),
      redeployEquipment: this.redeployEquipment.bind(this),
    }
  },
}
