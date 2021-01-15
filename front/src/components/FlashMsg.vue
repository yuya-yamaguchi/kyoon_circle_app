<template>
  <transition name="vshow">
    <div v-show="showFlg" class="error-messages-container">
      <div v-if="$store.getters['flash/type'] === 1" class="success-msg">{{ $store.getters['flash/message'] }}</div>
      <div v-if="$store.getters['flash/type'] === 2" class="error-msg">{{ $store.getters['flash/message'] }}</div>
    </div>
  </transition>
</template>

<script>
export default {
  props: {
    flashProp: {}
  },
  data() {
    return {
      showFlg: false
    }
  },
  created() {
    this.showFlg = true;
    setTimeout(() => {
      this.showFlg = false;
    }, 3000);
    setTimeout(() => {
      this.$store.dispatch("flash/remove");
    }, 4000)
  }
}
</script>

<style scoped lang="scss">
.vshow-enter-active, .vshow-leave-active {
  transition: opacity 1s;
}

.vshow-enter, .vshow-leave-to {
  opacity: 0;
}

.error-messages-container {
  z-index:1;
  position: absolute;
  top: 20%;
  left: 50%;
  transform: translate(-50%, -50%);
  -webkit-transform: translate(-50%, -50%);
  -ms-transform: translate(-50%, -50%);
  .success-msg {
    color: #FFF;
    font-size: 20px;
    padding: 5px 20px;
    background: rgba(109, 106, 106, 0.8);
  }
  .error-msg {
    color: red;
    font-size: 20px;
    padding: 5px 20px;
    background: rgba(243, 195, 195, 0.7);
  }
}
</style>