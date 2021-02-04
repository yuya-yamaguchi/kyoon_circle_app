<template>
  <div id="overlay">
    <div class="add-music-container">
      <button @click="closeModal()" class="close-button">×</button>
      <h1>曲の追加</h1>
      <div class="add-music-info">
        <div class="form-item">
          <input type="text" v-model="sessionMusic.title" placeholder="曲名を入力..." class="default-input">
        </div>
        <div class="form-item">
          <input type="text" v-model="sessionMusic.artist" placeholder="アーティスト名を入力..." class="default-input">
        </div>
        <table class="parts-table form-item">
          <tr>
            <td></td>
            <td v-for="partCategory in partCategoriesProp" :key="partCategory">
              {{ partCategory.name }}
            </td>
          </tr>
          <tr>
            <td>
              <div class="session-part-guide">必須</div>
              <div class="session-part-guide">任意</div>
              <div class="session-part-guide">不要</div>
            </td>
            <td v-for="(sessionPart, i) in sessionParts" :key="i">
              <label :for="'need'+i" class="session-part"
                :class="{'selectd-part': sessionPart.status==partStatus.need}">
                <span>◯</span>
                <input type="radio" :id="'need'+i"
                  :value="partStatus.need"
                  v-model="sessionPart.status"
                  class="session-part-radio">
              </label>
              <label :for="'any'+i" class="session-part"
                :class="{'selectd-part': sessionPart.status==partStatus.any}">
                <span>△</span>
                <input type="radio" :id="'any'+i"
                  :value="partStatus.any"
                  v-model="sessionPart.status"
                  class="session-part-radio">
              </label>
              <label :for="'noneed'+i" class="session-part"
                :class="{'selectd-part': sessionPart.status==partStatus.noneed}">
                <span>−</span>
                <input type="radio" :id="'noneed'+i"
                  :value="partStatus.noneed"
                  v-model="sessionPart.status"
                  class="session-part-radio">
              </label>
            </td>
          </tr>
        </table>
      </div>
      <div class="btn-area">
        <button @click="closeModal()" class="default-button back-btn">戻る</button>
        <button @click="postSessionMusic()" class="default-button confirm-btn">登録</button>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";

export default {
  props: {
    partCategoriesProp: {}
  },
  data() {
    return {
      sessionMusic: {},
      sessionParts: this.partCategoriesProp.map(function(pc){ return {part_category_id: pc.id, status: "1"} }),
      partStatus: {
        need:   '1',
        any:    '2',
        noneed: '0',
      }
    }
  },
  methods: {
    closeModal: function() {
      this.$emit('close-modal');
    },
    postSessionMusic: function() {
      axios.post(
        `http://${g.hostName}/api/events/${this.$route.params.id}/session_musics`,
        {
          session_music: this.sessionMusic,
          session_parts: this.sessionParts
        },
        {
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then(() => {
        this.$emit('close-modal');
      })
      .catch((error) => {
        this.apiErrors(error.response.status);
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
  margin: 0 auto;
  background: #FFF;
  position: absolute;
  top: 40%;
  left: 50%;
  transform: translate(-50%,-50%);
  h1 {
    margin: 30px;
    font-weight: bold;
    font-size: 24px;
    text-align: center;
  }
  .add-music-info{
    width: 80%;
    margin: 0 auto;
    .parts-table {
      td {
        width: 60px;
        text-align: center;
        margin: 10px 5px;
      }
      .session-part-guide {
        margin: 10px 0;
      }
      .session-part {
        display: block;
        border: 1px solid;
        margin: 10px 5px;
        border-radius: 10px;
        font-weight: bold
      }
      .selectd-part {
        background: var(--accent-color);
        color: #FFF;
      }
      .session-part-radio {
        display: none;
      }
    }
  }
  .btn-area {
    display: flex;
    justify-content: space-between;
    margin-bottom: 30px;
    .confirm-btn {
      width: 150px;
    }
    .back-btn {
      width: 150px;
      color: #333;
      background: #FFF;
    }
  }
}
</style>