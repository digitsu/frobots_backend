import { mount } from '../mounter'
import BlogsContainer from '../container/Blogs'

export default {
  mounted() {
    this.pushEventTo(this.el, 'react.fetch_news_and_updates')
    this.handleEvent('react.return_news_and_updates', (data: any) => {
      this.unmountComponent = mount(BlogsContainer)(
        this.el.id,
        this.opts({ ...data })
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
  opts(data: any) {
    return {
      name: 'BlogPosts',
      ...data,
    }
  },
}
