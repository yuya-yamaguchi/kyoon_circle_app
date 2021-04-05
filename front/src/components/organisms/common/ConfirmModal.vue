<template>
  <div id="overlay">
    <div class="confirm-container">
      <LoadingCircle v-if="isProcessingProp"/>
      <div @click="closeModal()" class="close-button">×</div>
      <h1>{{ modalMsgProp.title }}</h1>
      <p v-html="modalMsgProp.message" class="caution-msg"></p>
      <div class="btn-area">
        <button @click="closeModal()" class="default-button back-btn">戻る</button>
        <button @click="confirmCancel()" class="default-button confirm-btn">{{ modalMsgProp.btn }}</button>
      </div>
    </div>
  </div>
</template>

<script>
import LoadingCircle from '@/components/organisms/common/LoadingCircle.vue';

export default {
  props: {
    modalMsgProp: {},
    isProcessingProp: {
      type: Boolean,
      default: false
    }
  },
  components: {
    LoadingCircle
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
  z-index: 99;
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0,0,0,0.5);
  display: flex;
}

.confirm-container {
  z-index: 2;
  width: 90%;
  max-width: 700px;
  margin: 0 auto;
  background: #FFF;
  position: absolute;
  top: 40%;
  left: 50%;
  transform: translate(-50%,-50%);
  h1 {
    margin-bottom: 30px;
    font-weight: bold;
    font-size: 1.2rem;
    text-align: center;
  }
  .caution-msg {
    text-align: center;
    font-size: 1.0rem;
    margin: 20px;
  }
  .btn-area {
    display: flex;
    justify-content: space-between;
    margin-bottom: 30px;
    .confirm-btn {
      width: 160px;
    }
    .back-btn {
      width: 160px;
      color: #333;
      background: #FFF;
    }
  }
}

@media screen and (max-width: 600px) {
  .confirm-container {
    .btn-area {
      display: block;
    }
  }
}
</style>