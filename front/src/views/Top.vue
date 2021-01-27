<template>
  <div class="top-page">
    <TopImage/>
    <div class="top-container">
      <AboutNews :news-prop="news" :loading-prop="loading"/>
      <AboutStudio/>
      <AboutEvent :events-prop="events" :loading-prop="loading"/>
      <AboutStay/>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import TopImage from '@/components/molecules/top/TopImage.vue'
import AboutNews from '@/components/molecules/top/AboutNews.vue'
import AboutStudio from '@/components/molecules/top/AboutStudio.vue'
import AboutEvent from '@/components/molecules/top/AboutEvent.vue'
import AboutStay from '@/components/molecules/top/AboutStay.vue'
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [errorMethods],
  components: {
    TopImage,
    AboutNews,
    AboutStudio,
    AboutEvent,
    AboutStay
  },
  data() {
    return {
      news: [],
      events: [],
      loading: true
    }
  },
  methods: {
    async getTop() {
      await axios.get(
        `http://${g.hostName}/api/top`
      )
      .then((response) => {
        this.news = response.data.news;
        this.events = response.data.events;
        this.loading = false;
      })
      .catch((error) => {
        this.apiErrors(error.response.status);
      });
    },
  },
  async mounted() {
    await this.getTop();
  }
}
</script>

<style scoped lang="scss">
.top-container {
  margin-bottom: 100px;
  max-width: 1400px;
  margin: 0 auto;
}
</style>