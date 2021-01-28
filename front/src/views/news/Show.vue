<template>
  <div>
    <BreadCrumbs :breadCrumbs="breadCrumbs"/>
    <div class="single-container">
      <NewsContent @set-news-title="setNewsTitle"/>
    </div>
  </div>
</template>

<script>
import BreadCrumbs from "@/components/organisms/common/BreadCrumbs.vue";
import NewsContent from "@/components/organisms/news/NewsContent.vue";

export default {
  components: {
    BreadCrumbs,
    NewsContent
  },
  data() {
    return {
      newsTitle: ""
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
          path: '/news'
        },
        {
          name: this.newsTitle,
          path: ''
        }
      ]
      return breadCrumbsLists
    }
  },
  methods: {
    setNewsTitle: function(title) {
      this.newsTitle = title;
    }
  }
}
</script>
