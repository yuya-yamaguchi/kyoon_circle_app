<template>
  <div class="single-container">
    <div>
      <div>曲名：{{sessionMusic.title}}</div>
      <div>アーティスト名：{{sessionMusic.artist}}</div>
      <div>＜準備中＞</div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [errorMethods],
  data() {
    return {
      sessionMusic: {}
    }
  },
  methods: {
    getSessionMusic: function() {
      axios.get(
        `http://${g.hostName}/api/events/${this.$route.params.event_id}/session_musics/${this.$route.params.session_music_id}`
      )
      .then((response) => {
        this.sessionMusic = response.data.session_music;
      })
      .catch((error) => {
        this.apiErrors(error.response.status);
      })
    }
  },
  mounted() {
    this.getSessionMusic()
  }
}
</script>
