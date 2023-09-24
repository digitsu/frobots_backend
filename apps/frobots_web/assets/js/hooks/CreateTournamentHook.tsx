import { mount } from '../mounter'
import CreateTournament from '../container/Tournament/CreateTournament'

export default {
  mounted() {
    this.pushEventTo(this.el, 'react.fetch_create_tournament_details')
    this.handleEvent(
      'react.return_create_tournament_details',
      (createTournamentDetails) => {
        this.unmountComponent = mount(CreateTournament)(
          this.el.id,
          this.opts({ ...createTournamentDetails })
        )
      }
    )
  },
  createTournament(tournament_params) {
    this.pushEventTo(this.el, 'react.create_tournament', tournament_params)
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
      name: 'CreateTournament',
      ...details,
      createTournament: this.createTournament.bind(this),
    }
  },
}
