import { mount } from '../mounter'
import Docs from '../container/Docs'

export default {
  mounted() {
    this.unmountComponent = mount(Docs)(this.el.id, this.opts())
    this.pushEventTo(this.el, 'react.get_document')
    this.handleEvent('react.return_document', (article: any) => {
      this.unmountComponent = mount(Docs)(this.el.id, this.opts({ ...article }))
    })
  },

  destroyed() {
    if (!this.unmountComponent) {
      console.error('Component unmounted')
      return
    }

    this.unmountComponent(this.el)
  },

  opts(article: any) {
    return {
      name: 'Docs',
      ...article,
    }
  },
}
