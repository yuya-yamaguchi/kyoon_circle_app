<template>
<div>
    <BreadCrumbs :breadCrumbs="breadCrumbs"/>
    <div class="double-container">
      <div class="double-container--left">
        <SideBar :select-menu-prop="106"/>
      </div>
      <div class="double-container--right">
        <h1 class="main-title">お知らせ編集</h1>
        <NewsList v-if="news.length!=0" :news-prop="news"/>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import SideBar from "@/components/organisms/common/SideBar.vue";
import NewsList from '@/components/organisms/news/NewsList.vue';
import BreadCrumbs from "@/components/organisms/common/BreadCrumbs.vue";
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [errorMethods],
  components: {
    SideBar,
    NewsList,
    BreadCrumbs
  },
  computed: {
    breadCrumbs() {
      const breadCrumbsLists = [
        { name: 'トップ',
          path: '/'
        },
        { name: '管理メニュー',
          path: '/admin'
        },
        { name: 'お知らせ編集',
          path: ''
        }
      ]
      return breadCrumbsLists
    }
  },
  data() {
    return {
      news: []
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
        this.apiErrors(error.response);
      });
    }
  },
  mounted: function() {
    this.getNews();
  }
}
</script>

<style scoped lang="scss">
</style>