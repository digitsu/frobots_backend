import { mount } from '../mounter'
import CreateMatch from '../container/CreateMatch'
export default {
  mounted() {
    this.pushEventTo(this.el, 'react.fetch_create_match_details')
    this.handleEvent(
      'react.return_create_match_details',
      (createMatchDetails) => {
        this.unmountComponent = mount(CreateMatch)(
          this.el.id,
          this.opts({ ...createMatchDetails })
        )
      }
    )
  },
  createMatch(match_params) {
    this.pushEventTo(this.el, 'react.create_match', { match: match_params })
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
      createMatch: this.createMatch.bind(this),
    }
  },
}
