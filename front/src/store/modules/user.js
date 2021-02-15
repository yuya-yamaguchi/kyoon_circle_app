const state = {
  id:     0,
  name:   '',
  email:  '',
  adminType: 0,
  secureToken: ''
};

const getters = {
  id:     state => state.id,
  name:   state => state.name,
  email:  state => state.email,
  adminType: state => state.adminType,
  secureToken: state => state.secureToken
}

const mutations = {
  logout (state) {
    state.id     = 0;
    state.name   = '';
    state.email  = '';
    state.adminType   = false;
    state.secureToken = '';
  },
  updateUser(state, user) {
    state.id     = user.id;
    state.name   = user.name;
    state.email  = user.email;
    state.adminType   = user.adminType;
    state.secureToken = user.secureToken;
  },
  changeUserProfile(state, user) {
    state.name = user.name;
  }
}

const actions = {
  updateUser(context, user) {
    context.commit('updateUser', user);
  },
  logout(context) {
    context.commit('logout');
  },
  changeUserProfile(context, user) {
    context.commit('changeUserProfile', user);
  }
}

export default {
  namespaced: true,
  state,
  getters,
  mutations,
  actions
};