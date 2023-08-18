import { mount } from '../mounter'
import UserSnippets from '../container/UserSnippets'

export default {
  mounted() {
    this.pushEventTo(this.el, 'react.fetch_user_snippets')
    this.handleEvent('react.return_user_snippets', (details: any) => {
      this.unmountComponent = mount(UserSnippets)(
        this.el.id,
        this.opts({ ...details })
      )
    })
  },

  createSnippet(snippet_params: any) {
    this.pushEventTo(this.el, 'react.create_snippet', snippet_params)
  },

  updateSnippet(snippet_params: any) {
    this.pushEventTo(this.el, 'react.update_snippet', snippet_params)
  },

  deleteSnippet(snippet_params: any) {
    this.pushEventTo(this.el, 'react.delete_snippet', snippet_params)
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
      name: 'UserSnippets',
      ...details,
      createUserSnippet: this.createSnippet.bind(this),
      updateUserSnippet: this.updateSnippet.bind(this),
      deleteUserSnippet: this.deleteSnippet.bind(this),
    }
  },
}
