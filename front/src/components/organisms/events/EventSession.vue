<template>
  <div>
    <AddMusicModal v-if="displayModal"
      :partCategoriesProp="partCategories"
      @close-modal="displayModal=false"/>
    <div @click="displayAddMusic">
      + 曲を追加する
    </div>
    <table class="session-musics">
      <tr>
        <td/>
        <td v-for="partCategory in partCategories" :key="partCategory">
          {{partCategory.name}}
        </td>
      </tr>
      <tr v-for="sessionMusic in sessionMusics" :key="sessionMusic">
        <td>{{sessionMusic[0].title}}</td>
        <td v-for="sessionPart in sessionMusic[1]" :key="sessionPart">
          {{ sessionPart.status }}
          <p @click="entryPart(sessionMusic[0].id ,sessionPart.id)" class="part-entry">エントリー</p>
        </td>
      </tr>
    </table>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import AddMusicModal from "@/components/organisms/events/AddMusicModal.vue";

export default {
  components: {
    AddMusicModal
  },
  data() {
    return {
      displayModal: false,
      partCategories: [],
      sessionMusics:  []
    }
  },
  methods: {
    displayAddMusic: function() {
      this.displayModal = true
    },
    getPartCategoies: function() {
      axios.get(
        `http://${g.hostName}/api/part_categories`
      )
      .then((response) => {
        this.partCategories = response.data;
      })
      .catch((error) => {
        this.apiErrors(error.response.status);
      })
    },
    getSessionMusics: function() {
      axios.get(
        `http://${g.hostName}/api/events/${this.$route.params.id}/session_musics`
      )
      .then((response) => {
        this.sessionMusics = response.data;
      })
      .catch((error) => {
        this.apiErrors(error.response.status);
      })
    },
    entryPart: function(sessionMusicId, sessionPartId) {
      axios.post(
        `http://${g.hostName}/api/events/${this.$route.params.id}/session_musics/${sessionMusicId}/session_parts/${sessionPartId}/entry`,
        {},
        {
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then((response) => {
        console.log(response)
      })
      .catch((error) => {
        this.apiErrors(error.response.status);
      })
    }
  },
  mounted() {
    this.getPartCategoies();
    this.getSessionMusics();
  }
}
</script>

<style scoped lang="scss">
.session-musics {
  width: 100%;
  border: 1px solid;
  td {
    border: 1px solid;
    width: 60px;
  }
  .part-entry {
    background: lightgreen;
    font-size: 12px;
    text-align: center;
    cursor: pointer;
  }
}
</style>