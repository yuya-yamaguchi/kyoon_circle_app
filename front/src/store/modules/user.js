const state = {
  id:     0,
  name:   '',
  email:  '',
  token:  '',
  uid:    '',
  client: '',
  admin_flg: false
};

const getters = {
  id:     state => state.id,
  name:   state => state.name,
  email:  state => state.email,
  token:  state => state.token,
  uid:    state => state.uid,
  client: state => state.client,
  admin_flg: state => state.admin_flg
}

const mutations = {
  logout (state) {
    state.id     = 0;
    state.name   = null;
    state.email  = null;
    state.token  = null;
    state.uid    = null;
    state.client = null;
    state.admin_flg = false;
  },
  updateUser(state, user) {
    state.id     = user.id;
    state.name     = user.name;
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