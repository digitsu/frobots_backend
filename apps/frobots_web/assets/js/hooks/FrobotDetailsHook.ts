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

  updateBattleSearch(params: any) {
    this.pushEventTo(this.el, 'react.filter_frobot_battle_logs', params)
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
      updateBattleSearch: this.updateBattleSearch.bind(this),
    }
  },
}
