const state = {
  message: '',
  type:    0
};

const getters = {
  message: state => state.message,
  type:    state => state.type
}

 const mutations = {
  create(state, flash) {
    state.message = flash.message;
    state.type    = flash.type;
  },
  remove (state) {
    state.message  = "";
    state.type     = 0;
  }
}

const actions = {
  create(context, flash) {
    context.commit('create', flash);
  },
  remove(context) {
    context.commit('remove');
  }
}

export default {
  namespaced: true,
  state,
  getters,
  mutations,
  actions
};