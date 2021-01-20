<template>
  <div class="double-container">
    <div class="double-container--left">
      <SideBar :select-menu-prop="105"/>
    </div>
    <div class="double-container--right">
      <div class="news-new-container">
        <h1 class="main-title text-center">お知らせの登録</h1>
        <ErrMsg :error-messages-prop="apiErrorMessages"/>
        <NewsForm :news-prop="news" :modal-msg-prop="modalMsg" @post-news="postNewNews"/>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import SideBar from "@/components/SideBar.vue";
import NewsForm from "@/components/NewsForm.vue";
import ErrMsg from "@/components/ErrMsg.vue";
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [errorMethods],
  components: {
    SideBar,
    NewsForm,
    ErrMsg
  },
  data() {
    return {
      news: {
        title: "",
        details: "",
        line_msg_push: true
      },
      modalMsg: {
        title: "お知らせの登録",
        message: 'お知らせを登録します。よろしいですか？',
        btn: "登録"
      },
      apiErrorMessages: ""
    }
  },
  methods: {
    postNewNews: function(news) {
      axios.post(
        `http://${g.hostName}/api/news`,
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
      .then((response) => {
        this.apiErrorMessages = []
        this.$router.push({
          name: "NewsShow",
          params: {
            id: response.data.id
          }
        })
      })
      .catch((error) => {
        this.apiErrors(error.response.status);
        this.apiErrorMessages = error.response.data;
      });
    }
  }
}
</script>

<style scoped lang="scss">
.news-new-container {
  width: 100%;
  margin: 0 auto;
  padding: 20px 0;
  background: #FFF;
}
</style>