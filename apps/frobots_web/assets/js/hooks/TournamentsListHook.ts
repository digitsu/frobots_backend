import { mount } from '../mounter'
import TournamentsList from '../container/Tournament/TournamentsList'

export default {
  mounted() {
    this.pushEventTo(this.el, 'react.fetch_tournaments_list')
    this.handleEvent('react.return_tournaments_list', (details: any) => {
      this.unmountComponent = mount(TournamentsList)(
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

  opts(details: any) {
    return {
      name: 'TournamentsList',
      ...details,
    }
  },
}
