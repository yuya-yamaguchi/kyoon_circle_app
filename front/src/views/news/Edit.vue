<template>
  <div class="single-container">
    <h1 class="main-title text-center">お知らせ編集</h1>
    <ErrMsg :error-messages-prop="apiErrorMessages"/>
    <NewsForm v-if="news" :news-prop="news" :modal-msg-prop="modalMsg" @post-news="updateNews"/>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import NewsForm from "@/components/NewsForm.vue";
import ErrMsg from "@/components/ErrMsg.vue";
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [errorMethods],
  components: {
    NewsForm,
    ErrMsg
  },
  data() {
    return {
      news: '',
      modalMsg: {
        title: "お知らせの変更",
        message: 'お知らせを変更します。よろしいですか？',
        btn: "変更"
      },
      apiErrorMessages: ''
    }
  },
  methods: {
    getNews: function() {
      axios.get(
        `http://${g.hostName}/api/news/${this.$route.params.id}`
      )
      .then((response) => {
        this.news = response.data;
      })
      .catch((error) => {
        this.apiErrors(error.response.status);
      });
    },
    updateNews: function(news) {
      axios.put(
        `http://${g.hostName}/api/news/${news.id}`,
        {
          user_id: this.$store.getters['user/id'],
          news: news
        },
        {
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then(() => {
        this.apiErrorMessages = []
        this.$router.push({
          name: "NewsShow"
        })
      })
      .catch((error) => {
        this.apiErrors(error.response.status);
        this.apiErrorMessages = error.response.data;
      });
    }
  },
  mounted() {
    this.getNews();
  }
}
</script>

<style scoped lang="scss">
</style>