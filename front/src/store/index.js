import { createStore } from 'vuex'
import createPersistedState from 'vuex-persistedstate'
import user from './modules/user'

export default createStore({
  modules: {
    user
  },
  plugins: [createPersistedState({
    key: 'UserInfo',
    paths: ['user'],
    storage: window.sessionStorage
  })]
})
