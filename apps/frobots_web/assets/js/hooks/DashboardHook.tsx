import { mount } from '../mounter'
import Dashboard from '../container/Dashboard'

export default {
  mounted() {
    this.pushEventTo(this.el, 'react.fetch_dashboard_details')
    this.handleEvent('react.return_dashboard_details', (dashboardDetails) => {
      this.unmountComponent = mount(Dashboard)(
        this.el.id,
        this.opts({ ...dashboardDetails })
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
  opts(dashboardDetails) {
    return {
      name: 'Dashboard',
      ...dashboardDetails,
    }
  },
}
