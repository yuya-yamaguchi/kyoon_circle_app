<template>
  <div id="nav">
    <Header/>
    <div class="base-container">
      <router-view/>
    </div>
    <Footer/>
  </div>
</template>

<script>
import "@/assets/reset.css";
import "@/assets/style/_global.scss";
import Header from "@/components/Header.vue";
import Footer from "@/components/Footer.vue";

export default {
  components: {
    Header,
    Footer
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
}

.base-container{
  width: 100%;
  max-width: 100rem;
  min-height: calc(100vh - 190px);
  margin: 0 auto;
}
</style>
