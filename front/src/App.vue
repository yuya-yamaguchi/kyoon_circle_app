<template>
  <div id="nav">
    <Header/>
    <FlashMsg v-if="$store.getters['flash/message'].length!=0"/>
    <LoginModal v-if="$store.getters['loginGuide/isDisplay']"/>
    <div class="base-container">
      <NotFound v-if="[404].includes(errorStatus)"/>
      <Errors v-else-if="[403, 500].includes(errorStatus)" :error-status-prop="errorStatus"/>
      <router-view v-else/>
    </div>
    <Footer/>
  </div>
</template>

<script>
import "@/assets/reset.css";
import "@/assets/style/_variable.scss";
import "@/assets/style/_global.scss";
import "@/assets/style/_add_class.scss";
import "@/assets/style/_transition.scss";
import Header from "@/components/organisms/common/Header.vue";
import Footer from "@/components/organisms/common/Footer.vue";
import FlashMsg from "@/components/organisms/common/FlashMsg.vue";
import LoginModal from "@/components/organisms/common/LoginModal.vue";
import NotFound from "@/views/errors/NotFound.vue";
import Errors from "@/views/errors/Errors.vue";

export default {
  components: {
    Header,
    Footer,
    FlashMsg,
    NotFound,
    LoginModal,
    Errors
  },
  computed: {
    errorStatus() {
      return this.$store.getters["response/status"]
    }
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
  background: var(--base-color);
}

.base-container{
  width: 100%;
  padding-top: 60px;
  margin: 0 auto;
  box-sizing: border-box;
}
</style>
