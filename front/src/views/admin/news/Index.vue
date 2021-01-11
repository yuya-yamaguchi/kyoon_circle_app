<template>
  <div class="single-container">
    <h1 class="main-title">お知らせ一覧</h1>
    <NewsList v-if="news.length!=0" :news-prop="news"/>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import NewsList from '@/components/NewsList.vue';

export default {
  components: {
    NewsList
  },
  data() {
    return {
      news: []
    }
  },
  methods: {
    getNews: function() {
      axios.get(
        `http://${g.hostName}/api/admin/news`
      )
      .then((response) => {
        this.news = response.data;
      })
      .catch((error) => {
        console.log(error);
      });
    }
  },
  mounted() {
    this.getNews();
  }
}
</script>