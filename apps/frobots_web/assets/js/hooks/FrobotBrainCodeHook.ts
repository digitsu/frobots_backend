import { mount } from '../mounter'
import FrobotBrainCode from '../container/FrobotDetails/BrainCode'

export default {
  mounted() {
    this.pushEventTo(this.el, 'react.fetch_bot_braincode')
    this.handleEvent('react.return_bot_braincode', (brainCodeDetails) => {
      this.unmountComponent = mount(FrobotBrainCode)(
        this.el.id,
        this.opts({ ...brainCodeDetails })
      )
    })
  },

  updateFrobotCode(params) {
    this.pushEventTo(this.el, 'react.update_bot_braincode', params)
    this.handleEvent('react.updated_bot_braincode', (brainCodeDetails) => {
      this.unmountComponent = mount(FrobotBrainCode)(
        this.el.id,
        this.opts({ ...brainCodeDetails })
      )
    })
  },

  requestMatch(params) {
    this.pushEventTo(this.el, 'request_match', params)
    this.handleEvent('request_match', (requestMatchDetails) => {
      this.unmountComponent = mount(FrobotBrainCode)(
        this.el.id,
        this.opts({ ...requestMatchDetails })
      )
    })
  },

  runSimulation(params) {
    this.pushEventTo(this.el, 'start_match', params)
    this.handleEvent('start_match', (startMatchDetails) => {
      this.unmountComponent = mount(FrobotBrainCode)(
        this.el.id,
        this.opts({ ...startMatchDetails })
      )
    })
  },

  cancelSimulation(params) {
    this.pushEventTo(this.el, 'cancel_match', params)
    this.handleEvent('cancel_match', (cancelMatchDetails) => {
      this.unmountComponent = mount(FrobotBrainCode)(
        this.el.id,
        this.opts({ ...cancelMatchDetails })
      )
    })
  },

  changeOpponentFrobot(params) {
    this.pushEventTo(this.el, 'react.change-opponent-frobot', params)
    this.handleEvent(
      'react.change-opponent-frobot',
      (changeOpponentFrobotDetails) => {
        this.unmountComponent = mount(FrobotBrainCode)(
          this.el.id,
          this.opts({ ...changeOpponentFrobotDetails })
        )
      }
    )
  },

  destroyed() {
    if (!this.unmountComponent) {
      console.error('Component unmounted')
      return
    }
    this.unmountComponent(this.el)
  },

  opts(brainCodeDetails) {
    return {
      name: 'FrobotBrainCode',
      ...brainCodeDetails,
      updateFrobotCode: this.updateFrobotCode.bind(this),
      requestMatch: this.requestMatch.bind(this),
      runSimulation: this.runSimulation.bind(this),
      cancelSimulation: this.cancelSimulation.bind(this),
      changeOpponentFrobot: this.changeOpponentFrobot.bind(this),
    }
  },
}
