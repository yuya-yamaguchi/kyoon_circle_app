<template>
  <div>
    <AddMusicModal v-if="displayModal"
      :partCategoriesProp="partCategories"
      @close-modal="displayModal=false"
      @add-music="getSessionMusics"/>
    <ConfirmModal v-if="displayConfirmModal"
      :modal-msg-prop="modalMsg"
      @process-confirm="doneEventEntry"/>
    <SelectUserModal v-if="displaySelectUserModal"
      :users-prop="users"
      @post-entry-part="entryPartSelect"
      @close-modal="displaySelectUserModal=false"/>
    <div @click="displayAddMusic" class="add-music-btn">
      曲を追加する +
    </div>
    <Loading v-if="loading"/>
    <div v-if="sessionMusics.length!=0" class="scroll">
      <div v-if="$store.getters['user/adminType']>0">
        <input type="checkbox" id="adminEditMode" class="checkbox" v-model="adminEditMode">
        <label for="adminEditMode">管理者モードで編集する</label>
      </div>
      <table class="session-musics-table">
        <tr class="session-music-header">
          <td class="table-blank"/>
          <td v-for="partCategory in partCategories" :key="partCategory" class="part-category">
            {{partCategory.name}}
          </td>
        </tr>
        <tr v-for="(sessionMusic, i) in sessionMusics" :key="i" class="session-music">
          <td class="session-music--info">
            <router-link :to="{name: 'SessionMusicShow', params: { event_id: $route.params.id, session_music_id: sessionMusic[0].id }}" class="session-music--info--title">
              {{sessionMusic[0].title}}
            </router-link>
            <p v-if="sessionMusic[0].status==1" class="session-music--info--status">成立!</p>
          </td>
          <td v-for="(sessionPart, j) in sessionMusic[1]" :key="j" class="session-part">
            <div v-if="[1, 2].includes(sessionPart[0].status)" class="part-info">
              <div v-for="(entryUser, k) in sessionPart[1]" :key="k" class="entry-user">
                <router-link :to="{name: 'UserShow', params: { id: entryUser.id }}" class="entry-user--name">
                  {{ entryUser.name }}
                </router-link>
                <fa v-if="entryUser.id==$store.getters['user/id'] || (adminEditMode && $store.getters['user/adminType']>0)"
                  @click="cancelPart(sessionMusic[0].id ,sessionPart[0].id, sessionMusic[0], sessionPart[1], entryUser)"
                  icon="times-circle"
                  class="entry-cancel-btn"></fa>
              </div>
              <p v-if="sessionPart[1].length==0 && adminEditMode"
                @click="displaySelectUser(sessionMusic[0] ,sessionPart[0], sessionPart[1])"
                class="part-entry-btn select-btn">
                <span v-if="sessionPart[0].status==2">（</span>
                <span>選択</span>
                <span v-if="sessionPart[0].status==2">）</span>
              </p>
              <!-- 1パートに複数人エントリーさせたい場合には下記処理を有効にする -->
              <!-- <p v-if="!entryUserIds(sessionPart[1]).includes($store.getters['user/id'])" -->
              <p v-else-if="sessionPart[1].length==0"
                @click="entryPart(sessionMusic[0].id ,sessionPart[0].id, sessionMusic[0], sessionPart[1])"
                class="part-entry-btn">
                <span v-if="sessionPart[0].status==2">（</span>
                <span>エントリー</span>
                <span v-if="sessionPart[0].status==2">）</span>
              </p>
              <!-- <p v-else
                class="already-entry">エントリー中
              </p> -->
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
import ConfirmModal from "@/components/organisms/common/ConfirmModal.vue";
import SelectUserModal from "@/components/organisms/common/SelectUserModal.vue";
import Loading from '@/components/organisms/common/Loading.vue';
import { errorMethods } from '@/mixins/errorMethods';
import { eventEntry } from '@/mixins/events/eventEntry';

export default {
  mixins: [errorMethods, eventEntry],
  components: {
    AddMusicModal,
    ConfirmModal,
    SelectUserModal,
    Loading
  },
  props: {
    isEntryProp: {},
  },
  data() {
    return {
      displayModal: false,
      displayConfirmModal: false,
      displaySelectUserModal: false,
      partCategories: [],
      sessionMusics:  [],
      modalMsg: {
        title: "",
        message: "エントリーにはこのイベントへの参加が必要です",
        btn: "参加する"
      },
      loading: true,
      adminEditMode: false,
      users: {},
      escSessionMusic: {},
      escSessionPart: {},
      escUsers: {}
    }
  },
  methods: {
    displayAddMusic: function() {
      this.displayModal = true
    },
    displaySelectUser: function(sessionMusic, sessionPart, users) {
      this.escSessionMusic = sessionMusic;
      this.escSessionPart = sessionPart;
      this.escUsers = users;
      this.displaySelectUserModal = true;
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
      .finally(() => {
        this.loading = false
      })
    },
    entryPart: function(sessionMusicId, sessionPartId, sessionMusic, entryUsers) {
      if (this.entryPartValid()) {
        axios.post(
          `http://${g.hostName}/api/events/${this.$route.params.id}/session_musics/${sessionMusicId}/session_parts/${sessionPartId}/entry`,
          {
            user_id: this.$store.getters['user/id']
          },
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
      }
    },
    entryPartSelect: function(user) {
      axios.post(
        `http://${g.hostName}/api/events/${this.$route.params.id}/session_musics/${this.escSessionMusic.id}/session_parts/${this.escSessionPart.id}/entry`,
        {
          user_id: user.id
        },
        {
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then((response) => {
        this.escSessionMusic.status = response.data.session_music.status;
        this.escUsers.push(user)
      })
      .catch((error) => {
        this.apiErrors(error.response.status);
      })
    },
    cancelPart: function(sessionMusicId, sessionPartId, sessionMusic, entryUsers, entryUser) {
      axios.post(
        `http://${g.hostName}/api/events/${this.$route.params.id}/session_musics/${sessionMusicId}/session_parts/${sessionPartId}/cancel`,
        {
          user_id: entryUser.id
        },
        {
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then((response) => {
        sessionMusic.status = response.data.session_music.status
        entryUsers.some((v, i) => {
          if (v.id==entryUser.id) entryUsers.splice(i, 1);
        });
      })
      .catch((error) => {
        this.apiErrors(error.response.status);
      })
    },
    entryUserIds(entryUsers) {
      let userIds = entryUsers.map(function(user){ return user.id })
      return userIds
    },
    entryPartValid: function() {
      // ログインしていない場合
      if (!this.$store.getters['user/id']) {
        // ログインモーダルを表示
        this.$store.dispatch(
          "loginGuide/update", true
        );
        this.$store.dispatch(
          "flash/create",
          { message: "ログインまたは会員登録を行ってください。",
            type:    2
          }
        );
        return false
      }
      // イベントに参加していない場合
      if (!this.isEntryProp) {
        // イベントへの参加確認モーダルを表示
        this.displayConfirmModal = true
        return false
      }
      return true
    },
    doneEventEntry: function(confirm) {
      this.displayConfirmModal = false;
      if (confirm) {
        this.postEventEntry()
      }
    },
    getUsers: function() {
      axios.get(
        `http://${g.hostName}/api/admin/users`
      )
      .then((response) => {
        this.users = response.data;
      })
      .catch((error) => {
        this.apiErrors(error.response.status);
      })
    }
  },
  mounted() {
    this.getPartCategoies();
    this.getSessionMusics();
    this.getUsers();
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
          font-size: 16px;
          color: #333;
          margin-left: 5px;
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
            justify-content: center;
            align-items: center;
            height: 100%;
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
            height: 100%;
            font-weight: bold;
            display: flex;
            justify-content: center;
            align-items: center;
            cursor: pointer;
            &:hover {
              opacity: 0.7;
            }
          }
          .select-btn {
            background: #dedef5;
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