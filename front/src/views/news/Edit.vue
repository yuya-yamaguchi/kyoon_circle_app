<template>
<div>
    <BreadCrumbs :breadCrumbs="breadCrumbs"/>
    <div class="double-container">
      <div class="double-container--left">
        <SideBar :select-menu-prop="104"/>
      </div>
      <div class="double-container--right">
        <div class="news-edit-container">
          <h1 class="main-title text-center">お知らせ編集</h1>
          <div class="error-messages">
            <ErrMsg/>
          </div>
          <NewsForm v-if="news" 
            :news-prop="news"
            :modal-msg-prop="modalMsg"
            @post-news="updateNews"/>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import SideBar from "@/components/organisms/common/SideBar.vue";
import NewsForm from "@/components/organisms/news/NewsForm.vue";
import ErrMsg from "@/components/organisms/common/ErrMsg.vue";
import BreadCrumbs from "@/components/organisms/common/BreadCrumbs.vue";
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [errorMethods],
  components: {
    SideBar,
    NewsForm,
    ErrMsg,
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
        { name: `${this.news.title}`,
          path: `/news/${this.news.id}`
        },
        { name: '編集',
          path: ''
        }
      ]
      return breadCrumbsLists
    }
  },
  data() {
    return {
      news: '',
      modalMsg: {
        title: "お知らせの変更",
        message: 'お知らせを変更します。よろしいですか？',
        btn: "変更"
      }
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
        this.$router.push({
          name: "NewsShow"
        })
      })
      .catch((error) => {
        this.apiErrors(error.response);
      });
    }
  },
  mounted() {
    this.getNews();
  }
}
</script>

<style scoped lang="scss">
.news-edit-container {
  width: 100%;
  margin: 0 auto;
  padding: 20px 0;
  background: #FFF;
}
</style>