import { mount } from '../mounter'
import FrobotBrainCode from '../container/FrobotDetails/BrainCode'

export default {
  mounted() {
    this.pushEventTo(this.el, 'react.fetch_bot_braincode')
    this.handleEvent('react.return_bot_braincode', (brainCodeDetails) => {
      this.unmountComponent = mount(FrobotBrainCode)(
        this.el.id,
        this.opts({ ...brainCodeDetails })
      )
    })
  },

  updateFrobotCode(params) {
    this.pushEventTo(this.el, 'react.update_bot_braincode', params)
    this.handleEvent('react.updated_bot_braincode', (brainCodeDetails) => {
      this.unmountComponent = mount(FrobotBrainCode)(
        this.el.id,
        this.opts({ ...brainCodeDetails })
      )
    })
  },

  destroyed() {
    if (!this.unmountComponent) {
      console.error('Component unmounted')
      return
    }
    this.unmountComponent(this.el)
  },

  opts(brainCodeDetails) {
    return {
      name: 'FrobotBrainCode',
      ...brainCodeDetails,
      updateFrobotCode: this.updateFrobotCode.bind(this),
    }
  },
}
