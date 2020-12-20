const state = {
  id:     0,
  email:  '',
  token:  '',
  uid:    '',
  client: '',
  admin_flg: false
};

const getters = {
  id:     state => state.id,
  email:  state => state.email,
  token:  state => state.token,
  uid:    state => state.uid,
  client: state => state.client,
  admin_flg: state => state.admin_flg
}

const mutations = {
  logout (state) {
    state.id     = 0;
    state.email  = null;
    state.token  = null;
    state.uid    = null;
    state.client = null;
    state.admin_flg = false;
  },
  updateUser(state, user) {
    state.id     = user.id;
    state.email  = user.email;
    state.token  = user.token;
    state.uid    = user.uid;
    state.client = user.client;
    state.admin_flg = user.admin_flg;
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