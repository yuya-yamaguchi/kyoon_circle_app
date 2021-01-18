import { createStore } from 'vuex'
import createPersistedState from 'vuex-persistedstate'
import user from './modules/user'
import flash from './modules/flash'
import response from './modules/response'

export default createStore({
  modules: {
    user,
    flash,
    response
  },
  plugins: [createPersistedState({
    key: 'UserInfo',
    paths: ['user']
  })]
})
