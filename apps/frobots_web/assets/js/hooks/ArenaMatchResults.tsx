import { mount } from '../mounter'
import MatchResults from '../container/MatchResults'

export default {
  mounted() {
    this.pushEventTo(this.el, 'react.fetch_arena_match_results')
    this.handleEvent('react.return_match_results', (details: any) => {
      this.unmountComponent = mount(MatchResults)(
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
      name: 'ArenaMatchResults',
      ...details,
    }
  },
}
