<template>
  <div class="single-container">
    <table>
      <tr>
        <th>
          タイトル
        </th>
        <th>
          演奏回数
        </th>
        <th>
          URL
        </th>
      </tr>
      <tr v-for="playedMusic in playedMusics" :key="playedMusic">
        <td>{{ playedMusic.title }}</td>
        <td>{{ playedMusic.play_cnt }}</td>
        <td>
          <a :href="playedMusic.music_url">{{ playedMusic.music_url }}</a>
        </td>
      </tr>
    </table>
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
      playedMusics: []
    }
  },
  methods: {
    getTop() {
      axios.get(
        `http://${g.hostName}/api/played_musics`
      )
      .then((response) => {
        this.playedMusics = response.data.played_musics
      })
      .catch((error) => {
        this.apiErrors(error.response);
      });
    },
  },
  mounted() {
    this.getTop();
  }
}
</script>

<style scoped>
th {
  border: 1px solid;
}
td {
  border: 1px solid;
}

</style>