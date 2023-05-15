import { mount } from '../mounter'
import PlayerProfile from '../container/PlayerProfile'

export default {
  mounted() {
    this.pushEventTo(this.el, 'react.get_player_profile')
    this.handleEvent('react.return_player_profile', (details: any) => {
      this.unmountComponent = mount(PlayerProfile)(
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
      name: 'PlayerProfile',
      ...details,
    }
  },
}
