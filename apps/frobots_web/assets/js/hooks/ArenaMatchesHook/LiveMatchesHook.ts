import { mount } from '../../mounter'
import { LiveMatches } from '../../container/ArenaMatches'
export default {
  mounted() {
    this.unmountComponent = mount(LiveMatches)(this.el.id, this.opts())
  },

  destroyed() {
    if (!this.unmountComponent) {
      console.error('Component unmounted')
      return
    }

    this.unmountComponent(this.el)
  },
  opts() {
    return {
      name: 'ArenaLiveMatches',
    }
  },
}
