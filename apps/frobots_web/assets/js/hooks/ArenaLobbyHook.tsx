import { mount } from '../mounter'
import Lobby from '../container/Lobby'
export default {
  mounted() {
    this.pushEventTo(this.el, 'react.fetch_lobby_details')
    this.handleEvent('react.return_lobby_details', (arenaLobbyDetails) => {
      this.unmountComponent = mount(Lobby)(
        this.el.id,
        this.opts({ ...arenaLobbyDetails })
      )
    })
  },
  updateSlot({ type, payload }) {
    this.pushEventTo(this.el, type, payload)
  },
  startMatch() {
    this.pushEventTo(this.el, 'start_match_redirect')
  },
  destroyed() {
    if (!this.unmountComponent) {
      console.error('Component unmounted')
      return
    }
    this.unmountComponent(this.el)
  },
  opts(arenaLobbyDetails) {
    return {
      name: 'ArenaLobbyHook',
      ...arenaLobbyDetails,
      updateSlot: this.updateSlot.bind(this),
      startMatch: this.startMatch.bind(this),
    }
  },
}
