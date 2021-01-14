<template>
  <div id="nav">
    <Header/>
    <div class="base-container">
      <FlashMsg v-if="$store.getters['flash/message'].length!=0"/>
      <router-view/>
    </div>
    <Footer/>
  </div>
</template>

<script>
import "@/assets/reset.css";
import "@/assets/style/_global.scss";
import "@/assets/style/_transition.scss";
import Header from "@/components/Header.vue";
import Footer from "@/components/Footer.vue";
import FlashMsg from "@/components/FlashMsg.vue";

export default {
  components: {
    Header,
    Footer,
    FlashMsg
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
  background: rgb(245, 245, 245);
}

.base-container{
  width: 100%;
  min-height: calc(100vh - 190px);
  margin: 0 auto;
  box-sizing: border-box;
}
</style>
