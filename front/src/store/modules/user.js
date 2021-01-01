const state = {
  id:     0,
  name:   '',
  email:  '',
  token:  '',
  uid:    '',
  client: '',
  adminType: 0
};

const getters = {
  id:     state => state.id,
  name:   state => state.name,
  email:  state => state.email,
  token:  state => state.token,
  uid:    state => state.uid,
  client: state => state.client,
  adminType: state => state.adminType
}

const mutations = {
  logout (state) {
    state.id     = 0;
    state.name   = null;
    state.email  = null;
    state.token  = null;
    state.uid    = null;
    state.client = null;
    state.adminType = false;
  },
  updateUser(state, user) {
    state.id     = user.id;
    state.name     = user.name;
    state.email  = user.email;
    state.token  = user.token;
    state.uid    = user.uid;
    state.client = user.client;
    state.adminType = user.adminType;
  }
}

const actions = {
  updateUser(context, user) {
    context.commit('updateUser', user);
  },
  logout(context) {
    context.commit('logout');
  }
}

export default {
  namespaced: true,
  state,
  getters,
  mutations,
  actions
};