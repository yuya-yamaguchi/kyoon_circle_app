<template>
  <div>
    <BreadCrumbs :breadCrumbs="breadCrumbs"/>
    <div class="single-container">
      <h1 class="main-title">お知らせ一覧</h1>
      <NewsList v-if="news.length!=0" :news-prop="news"/>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import NewsList from '@/components/NewsList.vue';
import BreadCrumbs from "@/components/BreadCrumbs.vue";

export default {
  components: {
    NewsList,
    BreadCrumbs
  },
  data() {
    return {
      news: []
    }
  },
  computed: {
    breadCrumbs() {
      var breadCrumbsLists = [
        {
          name: 'トップ',
          path: '/'
        },
        {
          name: 'お知らせ一覧',
          path: ''
        }
      ]
      return breadCrumbsLists
    }
  },
  methods: {
    getNews: function() {
      axios.get(
        `http://${g.hostName}/api/news`
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