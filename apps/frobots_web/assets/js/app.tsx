// assets/js/app.tsx
import './user_socket.js'
import 'phoenix_html'
import { mount } from './mounter'
import { Socket } from 'phoenix'
import { LiveSocket } from 'phoenix_live_view'
import topbar from '../vendor/topbar'
import { connectToSocket } from './user_socket'
import Dashboard from './container/Dashboard'

interface HookType {
  [key: string]: {
    mounted(): void
    destroyed(): void
    opts(): { name?: string }
    unmountComponent?(el: HTMLElement): void
  } & Partial<Record<string, unknown>>
}

let Hooks: Partial<HookType> = {}

Hooks.DashboardContentHook = {
  mounted() {
    this.unmountComponent = mount(Dashboard)(this.el.id, this.opts())
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
      name: 'Dashboard',
    }
  },
}

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute('content')
let liveSocket = new LiveSocket('/live', Socket, {
  hooks: Hooks,
  params: { _csrf_token: csrfToken },
})

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: '#29d' }, shadowColor: 'rgba(0, 0, 0, .3)' })
window.addEventListener('phx:page-loading-start', (info) => topbar.show())
window.addEventListener('phx:page-loading-stop', (info) => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

window.addEventListener(`phx:match`, (e) => {
  let match_id = e.detail.id
  console.log('MAtch ID:', match_id)
  if (match_id) {
    connectToSocket(match_id)
  }
})