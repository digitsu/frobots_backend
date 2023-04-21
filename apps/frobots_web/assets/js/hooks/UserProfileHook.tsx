import { mount } from '../mounter'
import userProfile from '../container/userProfile'

export default {
  mounted() {
    this.pushEventTo(this.el, 'react.get_user_profile')
    this.handleEvent('react.return_user_profile', (details: any) => {
      this.unmountComponent = mount(userProfile)(
        this.el.id,
        this.opts({ ...details })
      )
    })
  },

  updateUserProfile(params: any) {
    this.pushEventTo(this.el, 'react.update_user_details', params)
  },

  updateUserEmail(params: any) {
    this.pushEventTo(this.el, 'react.update_user_email', params)
  },

  updateUserPassword(params: any) {
    this.pushEventTo(this.el, 'react.update_user_password', params)
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
      name: 'UserProfile',
      ...details,
      updateUserProfile: this.updateUserProfile.bind(this),
      updateUserEmail: this.updateUserEmail.bind(this),
      updateUserPassword: this.updateUserPassword.bind(this),
    }
  },
}
