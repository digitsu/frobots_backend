import { mount } from '../mounter'
import FrobotDetails from '../container/FrobotDetails'

export default {
  mounted() {
    this.pushEventTo(this.el, 'react.fetch_frobot_details')
    this.handleEvent('react.return_frobot_details', (details: any) => {
      this.unmountComponent = mount(FrobotDetails)(
        this.el.id,
        this.opts({ ...details })
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

  opts(frobotDetails: any) {
    return {
      name: 'FrobotDetails',
      ...frobotDetails,
    }
  },
}
