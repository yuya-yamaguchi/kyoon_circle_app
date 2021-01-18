const state = {
  status: 0
};

const getters = {
  status: state => state.status
}

 const mutations = {
  update(state, response) {
    state.status = response.status;
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