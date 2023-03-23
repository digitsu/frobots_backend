import { mount } from '../mounter'
import CreateMatch from '../container/CreateMatch'
export default {
  mounted() {
    this.unmountComponent = mount(CreateMatch)(this.el.id, this.opts())
  },
  destroyed() {
    if (!this.unmountComponent) {
      console.error('Component unmounted')
      return
    }
    this.unmountComponent(this.el)
  },
  opts(createMatchDetails) {
    return {
      name: 'ArenaCreateMatch',
      ...createMatchDetails,
    }
  },
}
