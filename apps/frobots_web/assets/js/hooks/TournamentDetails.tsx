import { mount } from '../mounter'
import TournamentDetails from '../container/Tournament/TournamentDetails'

export default {
  mounted() {
    this.pushEventTo(this.el, 'react.fetch_tournament_details')
    this.handleEvent(
      'react.return_fetch_tournament_details',
      (createTournamentDetails) => {
        this.unmountComponent = mount(TournamentDetails)(
          this.el.id,
          this.opts({ ...createTournamentDetails })
        )
      }
    )
  },
  joinTournament(tournament_params) {
    this.pushEventTo(this.el, 'react.join_tournament', tournament_params)
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
      name: 'TournamentDetails',
      joinTournament: this.joinTournament.bind(this),
      ...details,
    }
  },
}
