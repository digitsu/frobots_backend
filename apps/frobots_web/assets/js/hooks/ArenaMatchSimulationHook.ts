import { mount } from '../mounter'
import ArenaMatchSimulation from '../container/ArenaMatchSimulation'

export default {
  mounted() {
    this.pushEventTo(this.el, 'react.fetch_match_details')
    this.handleEvent('react.return_match_details', (matchDetails) => {
      this.unmountComponent = mount(ArenaMatchSimulation)(
        this.el.id,
        this.opts({ ...matchDetails })
      )
    })
  },
  
  runSimulation(params) {
    this.pushEventTo(this.el, 'load_simulater', { ...params })
  },

  destroyed() {
    if (!this.unmountComponent) {
      console.error('Component unmounted')
      return
    }

    this.unmountComponent(this.el)
  },
  opts(matchDetails) {
    return {
      name: 'ArenaMatchSimulation',
      ...matchDetails,
      runSimulation: this.runSimulation.bind(this),
    }
  },
}
