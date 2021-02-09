<template>
  <div>
    <BreadCrumbs :breadCrumbs="breadCrumbs"/>
    <div class="single-container">
      <EditMusicModal v-if="displayModal"
        @update-music="getSessionMusic"
        @close-modal="displayModal=false"/>
      <ConfirmModal v-if="displayDelModal"
        :modal-msg-prop="modalMsg"
        @process-confirm="deleteSessionMusic"/>
      <div class="space-between">
        <div class="music-info">
          <div class="music-info--title main-title">{{sessionMusic.title}}</div>
          <div>{{sessionMusic.artist}}</div>
        </div>
        <div class="operate-btns"
          v-if="sessionMusic.user_id==$store.getters['user/id'] || $store.getters['user/adminType']>0">
          <a @click="displayModal=true"
            class="edit-btn some-updown-center">
            <fa icon="edit"></fa>
            <span>編集する</span>
          </a>
          <a @click="displayDelModal=true" class="delete-btn some-updown-center">
            <fa icon="trash"></fa>
            <span>削除する</span>
          </a>
        </div>
      </div>
      <div v-if="sessionMusic.youtube_url_embed" class="youtube-outer">
        <iframe
          class="youtube-embed"
          :src="sessionMusic.youtube_url_embed"/>
      </div>
      <div class="music-url">
        <a :href="sessionMusic.music_url" target="_blank">{{sessionMusic.music_url}}</a>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import BreadCrumbs from "@/components/organisms/common/BreadCrumbs.vue";
import EditMusicModal from "@/components/organisms/events/EditMusicModal.vue";
import ConfirmModal from "@/components/organisms/common/ConfirmModal.vue";
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [errorMethods],
  components: {
    BreadCrumbs,
    EditMusicModal,
    ConfirmModal
  },
  data() {
    return {
      event: {},
      sessionMusic: {},
      displayModal: false,
      displayDelModal: false,
      modalMsg: {
        title: "",
        message: "この楽曲を取り消します。<br>削除した楽曲は元へは戻せません。よろしいですか？",
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
          name: 'イベント一覧',
          path: '/events/page=1'
        },
        {
          name: this.event.title,
          path: `/event/${this.sessionMusic.event_id}`
        },
        {
          name: this.sessionMusic.title,
          path: ''
        }
      ]
      return breadCrumbsLists
    }
  },
  methods: {
    getSessionMusic: function() {
      axios.get(
        `http://${g.hostName}/api/events/${this.$route.params.event_id}/session_musics/${this.$route.params.session_music_id}`
      )
      .then((response) => {
        this.event = response.data.event;
        this.sessionMusic = response.data.session_music;
      })
      .catch((error) => {
        this.apiErrors(error.response.status);
      })
    },
    deleteSessionMusic: function(confirm) {
      this.displayDelModal = false;
      if (confirm) {
        axios.delete(
          `http://${g.hostName}/api/events/${this.event.id}/session_musics/${this.sessionMusic.id}`
        )
        .then(() => {
          this.$router.push({ 
            name: "EventShow",
            params: {
              id: this.event.id
            }
          })
        })
        .catch((error) => {
          this.apiErrors(error.response.status);
        })
      }
    }
  },
  mounted() {
    this.getSessionMusic()
  }
}
</script>

<style scoped lang="scss">
.music-info {
  width: 100%;
  height: 100%;
}
.operate-btns {
  white-space: nowrap;
}
.youtube-outer {
  width: 100%;
  padding-top: 56.25%;
  margin-top: 20px;
  position: relative;
  top: 0;
  left: 0;
  .youtube-embed {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    min-width: 400px;
    min-height: 225px;
  }
}
.music-url {
  margin-top: 20px;
}
</style>