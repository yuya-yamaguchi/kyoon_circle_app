<template>
  <div id="overlay">
    <div class="confirm-container">
      <button @click="closeModal()" class="close-button">×</button>
      <h1>{{ modalMsgProp.title }}</h1>
      <p class="caution-msg">{{ modalMsgProp.message }}</p>
      <div class="btn-area">
        <button @click="closeModal()" class="default-button back-btn">戻る</button>
        <button @click="confirmCancel()" class="default-button confirm-btn">{{ modalMsgProp.btn }}</button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    modalMsgProp: {}
  },
  data() {
    return {
      data: ""
    }
  },
  methods: {
    closeModal: function() {
      this.$emit('process-confirm', false);
    },
    confirmCancel: function() {
      this.$emit('process-confirm', true);
    }
  }
}
</script>

<style scoped lang="scss">
#overlay {
  z-index:1;
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0,0,0,0.5);
  display: flex;
  align-items: center;
  justify-content: center;
}

.confirm-container {
  z-index: 2;
  width: 70%;
  margin: 0 auto;
  background: #FFF;
  h1 {
    margin: 30px;
    font-weight: bold;
    font-size: 24px;
    text-align: center;
  }
  .caution-msg {
    text-align: center;
    font-size: 18px;
    margin: 20px;
  }
  .btn-area {
    display: flex;
    justify-content: space-between;
    margin-bottom: 30px;
    .confirm-btn {
      width: 150px;
    }
    .back-btn {
      width: 150px;
      color: #333;
      background: #FFF;
    }
  }
}
</style>