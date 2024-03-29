import { mount } from '../mounter'
import CreateFrobot from '../container/CreateFrobot'

export default {
  mounted() {
    this.pushEventTo(this.el, 'react.fetch_frobot_create_details')
    this.handleEvent(
      'react.return_frobot_create_details',
      (createFrobotDetails) => {
        this.unmountComponent = mount(CreateFrobot)(
          this.el.id,
          this.opts({ ...createFrobotDetails })
        )
      }
    )
  },
  createFrobot(frobot_params) {
    this.pushEventTo(this.el, 'react.create_frobot', frobot_params)
  },
  destroyed() {
    if (!this.unmountComponent) {
      console.error('Component unmounted')
      return
    }

    this.unmountComponent(this.el)
  },
  opts(createFrobotDetails) {
    return {
      name: 'CreateFrobot',
      createFrobot: this.createFrobot.bind(this),
      ...createFrobotDetails,
    }
  },
}
