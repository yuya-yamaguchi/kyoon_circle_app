<template>
  <div>
    <AddMusicModal v-if="displayModal"
      :partCategoriesProp="partCategories"
      @close-modal="displayModal=false"
      @add-music="getSessionMusics"/>
    <div @click="displayAddMusic" class="add-music-btn">
      曲を追加する +
    </div>
    <div v-if="sessionMusics.length!=0" class="scroll">
      <table class="session-musics-table">
        <tr class="session-music-header">
          <td class="table-blank"/>
          <td v-for="partCategory in partCategories" :key="partCategory" class="part-category">
            {{partCategory.name}}
          </td>
        </tr>
        <tr v-for="(sessionMusic, i) in sessionMusics" :key="i" class="session-music">
          <td class="session-music--info">
            <p class="session-music--info--title">{{sessionMusic[0].title}}</p>
            <p v-if="sessionMusic[0].status==1" class="session-music--info--status">成立!</p>
          </td>
          <td v-for="(sessionPart, j) in sessionMusic[1]" :key="j" class="session-part">
            <div v-if="[1, 2].includes(sessionPart[0].status)" class="part-info">
              <div v-for="(entryUser, k) in sessionPart[1]" :key="k" class="entry-user">
                <router-link :to="{name: 'UserShow', params: { id: entryUser.id }}" class="entry-user--name">
                  {{ entryUser.name }}
                </router-link>
                <fa v-if="entryUser.id==$store.getters['user/id']"
                  @click="cancelPart(sessionMusic[0].id ,sessionPart[0].id, sessionMusic[0], sessionPart[1])"
                  icon="times-circle"
                  class="entry-cancel-btn"></fa>
              </div>
              <p v-if="!entryUserIds(sessionPart[1]).includes($store.getters['user/id'])"
                @click="entryPart(sessionMusic[0].id ,sessionPart[0].id, sessionMusic[0], sessionPart[1])"
                class="part-entry-btn">
                <span v-if="sessionPart[0].status==2">（</span>
                <span>エントリー</span>
                <span v-if="sessionPart[0].status==2">）</span>
              </p>
              <p v-else
                class="already-entry">エントリー中
              </p>
            </div>
            <div v-else class="noneed-part">
            </div>
          </td>
        </tr>
      </table>
    </div>
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
    entryPart: function(sessionMusicId, sessionPartId, sessionMusic, entryUsers) {
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
        sessionMusic.status = response.data.session_music.status;
        entryUsers.push({
          id: this.$store.getters['user/id'],
          name: this.$store.getters['user/name']
        })
      })
      .catch((error) => {
        this.apiErrors(error.response.status);
      })
    },
    cancelPart: function(sessionMusicId, sessionPartId, sessionMusic, entryUsers) {
      axios.post(
        `http://${g.hostName}/api/events/${this.$route.params.id}/session_musics/${sessionMusicId}/session_parts/${sessionPartId}/cancel`,
        {},
        {
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then((response) => {
        sessionMusic.status = response.data.session_music.status
        entryUsers.some((v, i) => {
          if (v.id==this.$store.getters['user/id']) entryUsers.splice(i, 1);
        });
      })
      .catch((error) => {
        this.apiErrors(error.response.status);
      })
    },
    entryUserIds(entryUsers) {
      let userIds = entryUsers.map(function(user){ return user.id })
      return userIds
    }
  },
  mounted() {
    this.getPartCategoies();
    this.getSessionMusics();
  }
}
</script>

<style scoped lang="scss">
.add-music-btn {
  display: inline-block;
  border: 1px solid;
  border-radius: 10px;
  padding: 2px 10px;
  margin: 10px 0;
  font-size: 18px;
  font-weight: bold;
  color: #FFF;
  background: #333;
  cursor: pointer;
}
.scroll {
  display: block;
  overflow-x: scroll;
  white-space: nowrap;
  -webkit-overflow-scrolling: touch;
  .session-musics-table {
    width: 100%;
    height: 100%;
    background: #FFF;
    .table-blank {
      border: 1px solid;
    }
    .part-category {
      border-top: 1px solid #333;
      border-right: 1px solid #333;
      border-bottom: 1px solid #333;
      font-weight: bold;
    }
    .session-music {
      &--info {
        min-width: 100px;
        border-right: 1px solid;
        border-left: 1px solid;
        border-bottom: 1px solid;
        &--title {
          font-size: 18px;
        }
        &--status {
          font-size: 12px;
          font-weight: bold;
          color: red;
        }
      }
      .session-part {
        border-right: 1px solid;
        border-bottom: 1px solid;
        min-width: 100px;
        .part-info {
          display: flex;
          flex-direction: column;
          height: 100%;
          font-size: 13px;
          .entry-user {
            display: flex;
            justify-content: flex-start;
            margin-bottom: 5px;
            &--name {
              color: #333;
            }
            .entry-cancel-btn {
              margin-left: 2px;
              width: 12px;
              color: lightgray;
              cursor: pointer;
            }
          }
          .part-entry-btn {
            margin-top: auto;
            background: rgb(238, 204, 129);
            padding: 8px 0;
            font-size: 10px;
            font-weight: bold;
            display: flex;
            justify-content: center;
            align-items: center;
            cursor: pointer;
          }
          .already-entry {
            margin-top: auto;
            color: #FFF;
            background: lightgray;
            padding: 8px 0;
            font-size: 10px;
            font-weight: bold;
            display: flex;
            justify-content: center;
            align-items: center;
          }
        }
        .noneed-part {
          height: 100%;
          background: lightgray;
        }
      }
    }
  }
}
</style>