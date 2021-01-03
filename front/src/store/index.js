import { createStore } from 'vuex'
import createPersistedState from 'vuex-persistedstate'
import user from './modules/user'
import flash from './modules/flash'

export default createStore({
  modules: {
    user,
    flash
  },
  plugins: [createPersistedState({
    key: 'UserInfo',
    paths: ['user'],
    storage: window.sessionStorage
  })]
})
