<template>
  <div id="nav">
    <Header/>
    <FlashMsg v-if="$store.getters['flash/message'].length!=0"/>
    <LoginModal v-if="$store.getters['loginGuide/isDisplay']"/>
    <div class="base-container">
      <NotFound v-if="[404].includes(errorStatus)"/>
      <Forbidden v-else-if="[403].includes(errorStatus)"/>
      <SystemError v-else-if="[500].includes(errorStatus)" :error-status-prop="errorStatus"/>
      <router-view v-else/>
    </div>
    <Footer v-if="footerShow"/>
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
import Forbidden from "@/views/errors/Forbidden.vue";
import SystemError from "@/views/errors/SystemError.vue";

export default {
  components: {
    Header,
    Footer,
    FlashMsg,
    NotFound,
    Forbidden,
    LoginModal,
    SystemError
  },
  data() {
    return {
      urlPath: location.pathname
    }
  },
  computed: {
    errorStatus() {
      return this.$store.getters["response/status"]
    },
    footerShow() {
      let paths = this.$route.path.split('/')
      if (paths[paths.length-1] == "messages") {
        return false
      }
      return true
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
  font-size: 1.0rem;
}

.base-container{
  width: 100%;
  padding-top: 60px;
  margin: 0 auto;
  box-sizing: border-box;
}

@media screen and (max-width: 700px) {
  #app {
    font-size: 0.9rem;
  }
}
</style>
