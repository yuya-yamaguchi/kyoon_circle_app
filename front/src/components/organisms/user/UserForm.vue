<template>
  <div>
    <div class="error-messages">
      <ErrMsg/>
    </div>
    <form v-on:submit.prevent="updateProfile">
      <div class="form-item">
        <p class="form-item--name">ユーザ名</p>
        <input type="text" v-model="user.name" class="default-input" @blur="userNameChk()" @keyup="userNameChk()">
        <p class="form-item--err-msg">{{ errMsg.name }}</p>
      </div>
      <div>
        <div class="form-item">
          <p class="form-item--name">プロフィール</p>
          <textarea v-model="user.profile" @blur="userProfileChk()" @keyup="userProfileChk()"></textarea>
          <p class="form-item--err-msg">{{ errMsg.profile }}</p>
        </div>
      </div>
      <div class="form-item">
        <div class="avatar">
          <div class="avatar--image">
            <UserAvatar v-if="!loading" :avatar-prop="user.avatar"/>
          </div>
          <label id="select-avatar">
            <input type="file" id="select-avatar" @change="changeAvatar" class="avatar-input">
            <fa icon="edit" class="edit-icon"></fa>
          </label>
          <span>
            <fa icon="trash" class="delete-icon" @click="deleteAvatar"></fa>
          </span>
        </div>
        <p class="form-item--err-msg">{{ errMsg.avatar }}</p>
      </div>
      <div class="form-item">
        <UserInstrumentEdit
          v-if="userInstruments.length!=0"
          :userInstrumentsProp="userInstruments"
          @change-Instruments="changeUserInstruments"/>
      </div>
      <button class="default-button">変更する</button>
    </form>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import ErrMsg from "@/components/organisms/common/ErrMsg.vue";
import UserAvatar from "@/components/atoms/UserAvatar.vue";
import UserInstrumentEdit from "@/components/molecules/instruments/UserInstrumentEdit.vue";
import { commonCheck } from '@/mixins/commonCheck';
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [commonCheck, errorMethods],
  components: {
    ErrMsg,
    UserAvatar,
    UserInstrumentEdit
  },
  data() {
    return {
      user: {},
      userInstruments: [],
      errMsg: {},
      loading: true
    }
  },
  methods: {
    // プロフィール情報の取得
    getProfile: function() {
      axios.get(
        `http://${g.hostName}/api/mypage/${this.$store.getters['user/id']}`,
        {
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then((response) => {
        this.user = response.data.user,
        this.userInstruments = response.data.user_instruments
      })
      .catch((error) => {
        this.apiErrors(error.response);
      })
      .finally(() => {
        this.loading = false;
      });
    },
    // プロフィールの更新
    updateProfile: function() {
      axios.put(
        `http://${g.hostName}/api/users/${this.$store.getters['user/id']}`,
        {
          user: this.user
        },
        {
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then((response) => {
        this.$store.dispatch(
          "user/changeUserProfile",
          {
            name: response.data.name
          }
        );
        this.$router.push({ 
          name: "MypageTop"
        })
      })
      .catch((error) => {
        this.apiErrors(error.response);
      });
    },
    changeAvatar: function(e) {
      let files = e.target.files || e.dataTransfer.files;
      if (this.checkFile(files[0])) {
        this.createImage(files[0])
      }
    },
    checkFile(file) {
      const SIZE_LIMIT = 100 * 1024 // 100KB
      if (file.type != 'image/jpeg' && file.type != 'image/png') {
        this.errMsg.avatar = "jpegまたはpngの画像を選択してください"
        return false
      }
      if (file.size > SIZE_LIMIT) {
        this.errMsg.avatar = "100KB以下の画像を選択してください"
        return false
      }
      this.errMsg.avatar = ""
      return true
    },
    createImage(file) {
      let reader = new FileReader();
      reader.onload = (e) => {
        this.user.avatar = e.target.result;
      };
      reader.readAsDataURL(file);
    },
    deleteAvatar: function() {
      this.user.avatar = ""
    },
    changeUserInstruments: function(instrument_ids) {
      this.user.instrument_ids = instrument_ids
    },
    userNameChk: function() {
      this.errMsg.name = this.formStrChk(this.user.name, 20);
    },
    userProfileChk: function() {
      this.errMsg.profile = this.formStrChk(this.user.profile, 1000, "01");
    }
  },
  mounted: function() {
    this.getProfile();
  }
}
</script>

<style scoped lang="scss">
.avatar {
  display: flex;
  justify-content: flex-start;
  &--image {
    width: 120px;
    height: 120px;
    margin-right: 10px;
  }
  .avatar-input {
    display: none;
  }
  .delete-icon {
    width: 20px;
  }
  .edit-icon {
    width: 26px;
  }
  svg {
    cursor: pointer;
    margin: 0 10px;
    &:hover {
      opacity: 0.7;
    }
  }
}
</style>