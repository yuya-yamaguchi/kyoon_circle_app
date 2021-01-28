<template>
  <div class="about-news">
    <p class="top-each-title">NEWS</p>
    <Loading v-if="loadingProp"/>
    <NewsList v-if="newsProp.length!=0" :news-prop="newsProp"/>
    <router-link to="/news?page=1" class="all-view-link">すべてのお知らせを見る</router-link>
  </div>
</template>

<script>
import NewsList from '@/components/organisms/news/NewsList.vue';
import Loading from '@/components/organisms/common/Loading.vue';

export default {
  props: {
    newsProp: {},
    loadingProp: {}
  },
  components: {
    NewsList,
    Loading
  }
}
</script>

<style scoped>
.about-news {
  padding: 100px 0px;
  background: #FFF;
}
.all-view-link {
  display: block;
  text-decoration: none;
  margin: 0 auto;
  text-align: center;
  color: #333;
  font-size: 20px;
  font-weight: bold;
}
.top-each-title {
  font-size: 40px;
  font-weight: bold;
  text-align: center;
}
</style>