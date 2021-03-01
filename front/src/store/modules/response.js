const state = {
  status:   0,
  messages: []
};

const getters = {
  status:   state => state.status,
  messages: state => state.messages
}

 const mutations = {
  update(state, response) {
    state.status   = response.status;
    state.messages = response.messages;
  }
}

const actions = {
  update(context, response) {
    context.commit('update', response);
  }
}

export default {
  namespaced: true,
  state,
  getters,
  mutations,
  actions
};