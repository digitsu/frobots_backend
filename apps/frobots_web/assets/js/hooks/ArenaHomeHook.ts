import { mount } from '../mounter'
import ArenaHome from '../container/Arena'

export default {
  mounted() {
    this.pushEventTo(this.el, 'react.mount_arena_home')
    this.handleEvent('react.return_arena_home', (details: any) => {
      this.unmountComponent = mount(ArenaHome)(
        this.el.id,
        this.opts({ ...details })
      )
    })
  },

  updateMatchSearch(params: any) {
    this.pushEventTo(this.el, 'react.update_arena_match_search', params)
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
      name: 'ArenaHome',
      ...details,
      updateMatchSearch: this.updateMatchSearch.bind(this),
    }
  },
}
