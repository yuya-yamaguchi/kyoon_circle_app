<template>
  <div id="overlay">
    <div class="add-music-container">
      <div @click="closeModal()" class="close-button">×</div>
      <h1>曲の編集</h1>
      <SessionMusicForm v-if="!loading"
        :part-categories-prop="partCategories"
        :session-music-prop="sessionMusic"
        :session-parts-prop="sessionParts"
        :btn-name-prop="'更新'"
        @post-session-music="putSessionMusic"
        @close-modal="closeModal"/>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import SessionMusicForm from '@/components/organisms/events/sessions/SessionMusicForm';

export default {
  components: {
    SessionMusicForm
  },
  props: {
    partCategoriesProp: {}
  },
  data() {
    return {
      partCategories: {},
      sessionMusic: {},
      sessionParts: [],
      loading: true
    }
  },
  methods: {
    closeModal: function() {
      this.$emit('close-modal');
    },
    getSessionMusic() {
      axios.get(
        `http://${g.hostName}/api/events/${this.$route.params.event_id}/session_musics/${this.$route.params.session_music_id}/edit`,
        {
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then((response) => {
        this.sessionMusic = response.data.session_music
        this.sessionParts = response.data.session_parts
        this.loading = false
      })
      .catch((error) => {
        this.apiErrors(error.response);
      })
    },
    putSessionMusic: function(sessionMusic, sessionParts) {
      axios.put(
        `http://${g.hostName}/api/events/${this.sessionMusic.event_id}/session_musics/${this.sessionMusic.id}`,
        {
          session_music: sessionMusic,
          session_parts: sessionParts
        },
        {
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then(() => {
        this.$emit('update-music');
        this.$emit('close-modal');
      })
      .catch((error) => {
        this.apiErrors(error.response);
      })
    },
    getPartCategoies: function() {
      axios.get(
        `http://${g.hostName}/api/part_categories`
      )
      .then((response) => {
        this.partCategories = response.data;
      })
      .catch((error) => {
        this.apiErrors(error.response);
      })
    }
  },
  mounted() {
    this.getSessionMusic();
    this.getPartCategoies();
  }
}
</script>

<style scoped lang="scss">
#overlay {
  z-index: 99;
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0,0,0,0.5);
  display: flex;
}
.add-music-container {
  z-index: 2;
  width: 95%;
  max-width: 1000px;
  margin: 0 auto;
  background: #FFF;
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%,-50%);
  h1 {
    margin-bottom: 30px;
    font-weight: bold;
    font-size: 1.2rem;
    text-align: center;
  }
}
</style>