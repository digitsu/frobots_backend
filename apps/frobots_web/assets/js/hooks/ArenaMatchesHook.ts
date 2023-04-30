import { mount } from '../mounter'
import ArenaMatches from '../container/ArenaMatches'

export default {
  mounted() {
    this.pushEventTo(this.el, 'react.fetch_arena_matches')
    this.handleEvent('react.return_arena_matches', (arenaMatches: any) => {
      this.unmountComponent = mount(ArenaMatches)(
        this.el.id,
        this.opts({ ...arenaMatches })
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
  opts(arenaMatches: any) {
    return {
      name: 'ArenaMatches',
      ...arenaMatches,
    }
  },
}
