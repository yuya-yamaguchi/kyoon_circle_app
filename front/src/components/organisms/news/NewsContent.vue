<template>
  <div>
    <ConfirmModal v-show="modalFlg"
        :modal-msg-prop="modalMsg"
        @process-confirm="deleteNews"/>
    <div class="space-between">
      <h1 class="main-title">{{ news.title }}</h1>
      <div v-show="$store.getters['user/adminType']>0">
        <router-link :to="`/news/${news.id}/edit`" class="edit-btn some-updown-center">
          <fa icon="edit"></fa>
          <span class="edit-btn-name">編集する</span>
        </router-link>
        <a @click="displayConfirmModal" class="delete-btn some-updown-center">
          <fa icon="trash"></fa>
          <span class="delete-btn-name">削除する</span>
        </a>
      </div>
    </div>
    <div class="news-date">
      <p>投稿日時：{{ formatDate(news.created_at, 'YYYY/MM/DD HH24:MI:SS') }}</p>
      <p>更新日時：{{ formatDate(news.updated_at, 'YYYY/MM/DD HH24:MI:SS') }}</p>
    </div>
    <div class="news-details">
      {{ news.details }}
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import ConfirmModal from "@/components/organisms/common/ConfirmModal.vue";
import { commonMethods } from '@/mixins/commonMethods';
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [commonMethods, errorMethods],
  components: {
    ConfirmModal
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
  methods: {
    getNews: function() {
      axios.get(
        `http://${g.hostName}/api/news/${this.$route.params.id}`
      )
      .then((response) => {
        this.news = response.data;
        this.$emit('set-news-title', this.news.title);
      })
      .catch((error) => {
        this.apiErrors(error.response);
      });
    },
    deleteNews: function(confirm) {
      this.modalFlg = false;
      if (confirm) {
        axios.delete(
          `http://${g.hostName}/api/news/${this.news.id}`,
          {
            headers: {
              Authorization: this.$store.getters['user/secureToken']
            }
          }
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
        .catch((error) => {
          this.apiErrors(error.response);
        });
      }
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
  font-size: 0.9rem;
  margin: 20px 5px;
  padding: 10px;
  background: #FFF;
  white-space: pre-wrap;
}
</style>