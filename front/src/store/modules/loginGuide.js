const state = {
  isDisplay: false
};

const getters = {
  isDisplay: state => state.isDisplay
}

 const mutations = {
  update(state, isDisplay) {
    state.isDisplay = isDisplay;
  }
}

const actions = {
  update(context, isDisplay) {
    context.commit('update', isDisplay);
  }
}

export default {
  namespaced: true,
  state,
  getters,
  mutations,
  actions
};