<template>
  <div>
    <BreadCrumbs :breadCrumbs="breadCrumbs"/>
    <div class="single-container">
      <ConfirmModal v-show="modalFlg"
          :modal-msg-prop="modalMsg"
          @process-confirm="deleteNews"/>
      <h1 class="main-title">{{ news.title }}</h1>
      <div v-show="$store.getters['user/adminType']>0">
        <router-link :to="`/news/${news.id}/edit`" class="edit-btn">編集する</router-link>
        <a @click="displayConfirmModal" class="delete-btn">削除する</a>
      </div>
      <div class="news-date">
        <p>投稿日時：{{ formatDate(news.created_at) }}</p>
        <p>更新日時：{{ formatDate(news.updated_at) }}</p>
      </div>
      <div class="news-details">
        {{ news.details }}
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import ConfirmModal from "@/components/ConfirmModal.vue";
import BreadCrumbs from "@/components/BreadCrumbs.vue";
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [errorMethods],
  components: {
    ConfirmModal,
    BreadCrumbs
  },
  data() {
    return {
      news: "",
      modalFlg: false,
      modalMsg: {
        title: "お知らせの削除",
        message: "お知らせの削除を行います。<br>削除したお知らせは元へは戻せません。よろしいですか？",
        btn: "削除"
      }
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
          name: this.news.title,
          path: ''
        }
      ]
      return breadCrumbsLists
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
        this.apiErrors();
      });
    },
    deleteNews: function(confirm) {
      this.modalFlg = false;
      if (confirm) {
        axios.delete(
          `http://${g.hostName}/api/news/${this.news.id}`
        )
        .then(() => {
          this.$store.dispatch(
            "flash/create",
            { message: "お知らせを削除しました",
              type:    1
            }
          );
          this.$router.push({ 
            name: "NewsIndex"
          })
        })
        .catch(function(error) {
          console.log(error);
        });
      }
    },
    formatDate: function(date) {
      var dateFormat = ""
      if (date != undefined) {
        dateFormat = date.substr(0, 4) + '/' + date.substr(5, 2) + '/' + date.substr(8, 2) + ' ' + date.substr(11, 8)
      }
      return dateFormat
    },
    displayConfirmModal: function() {
      this.modalFlg = true;
    },
  },
  mounted() {
    this.getNews();
  }
}
</script>

<style scoped lang="scss">
.news-date {
  text-align: right;
}

.news-details {
  font-size: 18px;
  margin: 20px;
  padding: 10px;
  background: #FFF;
  white-space: pre-wrap;
}

.edit-btn {
  display: inline-block;
  padding: 2px 15px;
  margin: 10px;
  border-radius: 10px;
  font-weight: bold;
  text-decoration: none;
  color: #FFF;
  cursor: pointer;
  background: var(--accent-color);
}

.delete-btn {
  display: inline-block;
  padding: 2px 15px;
  margin: 10px;
  border-radius: 10px;
  font-weight: bold;
  text-decoration: none;
  color: #FFF;
  cursor: pointer;
  background: red;
}
</style>