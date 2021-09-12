<template>
  <div>
    <div class="add-music-info">
      <div class="form-item">
        <input type="text" v-model="sessionMusic.title" placeholder="曲名を入力..." class="default-input">
        <p class="form-item--err-msg">{{ errMsg.title }}</p>
      </div>
      <div class="form-item">
        <input type="text" v-model="sessionMusic.artist" placeholder="アーティスト名を入力..." class="default-input">
        <p class="form-item--err-msg">{{ errMsg.artist }}</p>
      </div>
      <div class="form-item">
        <input type="text" v-model="sessionMusic.music_url" placeholder="楽曲のURLを入力...(任意)" class="default-input">
        <p class="form-item--err-msg">{{ errMsg.musicUrl }}</p>
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
      <button @click="postSessionMusic()" class="default-button confirm-btn">{{btnNameProp}}</button>
    </div>
  </div>
</template>

<script>
import { sessionMusicValidates } from '@/mixins/validates/sessionMusicValidates';

export default {
  mixins: [sessionMusicValidates],
  props: {
    partCategoriesProp: {},
    sessionMusicProp: {},
    sessionPartsProp: {},
    btnNameProp: {}
  },
  data() {
    return {
      sessionMusic: this.sessionMusicProp,
      sessionParts: this.sessionPartsProp,
      partStatus: {
        need:   '1',
        any:    '2',
        noneed: '0',
      },
      errMsg: {}
    }
  },
  methods: {
    postSessionMusic: function() {
      if (this.sessionMusicValid()) {
        this.$emit('post-session-music',
                    this.sessionMusic,
                    this.sessionParts);
      }
    },
    sessionMusicValid: function() {
      this.errMsg.title  = this.sessionMusicTitleValid(this.sessionMusic.title)
      this.errMsg.artist = this.sessionMusicArtistValid(this.sessionMusic.artist)
      for (var key in this.errMsg) {
        if (this.errMsg[key]) {
          return false
        }
      }
      return true
    },
    closeModal: function() {
      this.$emit('close-modal');
    }
  }
}
</script>

<style scoped lang="scss">
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
      white-space: nowrap;
    }
    .session-part {
      display: block;
      border: 1px solid;
      margin: 10px 5px;
      border-radius: 10px;
      font-weight: bold;
      cursor: pointer;
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

@media screen and (max-width: 700px) {
  .btn-area {
    display: block;
    .confirm-btn {
      width: 70%;
    }
    .back-btn {
      width: 70%;
    }
  }
}
</style>