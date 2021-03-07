<template>
  <div id="overlay">
    <div class="add-music-container">
      <div @click="closeModal()" class="close-button">×</div>
      <h1>曲の追加</h1>
      <SessionMusicForm
        :part-categories-prop="partCategoriesProp"
        :session-music-prop="sessionMusic"
        :session-parts-prop="sessionParts"
        :btn-name-prop="'登録'"
        @post-session-music="postSessionMusic"
        @close-modal="closeModal"/>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import SessionMusicForm from '@/components/organisms/events/sessions/SessionMusicForm';

export default {
  props: {
    partCategoriesProp: {}
  },
  components: {
    SessionMusicForm
  },
  data() {
    return {
      sessionMusic: {},
      sessionParts: this.partCategoriesProp.map(function(pc){ return {part_category_id: pc.id, status: "1"} }),
    }
  },
  methods: {
    closeModal: function() {
      this.$emit('close-modal');
    },
    postSessionMusic: function(sessionMusic, sessionParts) {
      axios.post(
        `http://${g.hostName}/api/events/${this.$route.params.id}/session_musics`,
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
        this.$emit('add-music');
        this.$emit('close-modal');
      })
      .catch((error) => {
        this.apiErrors(error.response);
      })
    }
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