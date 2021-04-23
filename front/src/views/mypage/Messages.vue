<template>
  <div class="messages-list-container">
    <router-link v-for="message in messagesList" :key="message"
      :to="{name: 'MessageShow', params: { id:message.user_id }}"
      class="message">
      <div class="message--left">
        <div class="message--left--user-avatar">
          <UserAvatar :avatarProp="message.avatar"/>
        </div>
      </div>
      <div class="message--middle">
        <p class="message--middle--username">{{ message.user_name }}</p>
        <p class="message--middle--text">{{ messageTrim(message.text) }}</p>
      </div>
      <div class="message--right">
        <p class="message--right--datetime">{{formatDate(message.created_at, 'YYYY/MM/DD HH24:MI:SS') }}</p>
      </div>
    </router-link>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import UserAvatar from "@/components/atoms/UserAvatar.vue";
import { commonMethods } from '@/mixins/commonMethods';
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [commonMethods, errorMethods],
  components: {
    UserAvatar
  },
  data() {
    return {
      messagesList: []
    }
  },
  methods: {
    getMessages: function() {
      axios.get(
        `http://${g.hostName}/api/mypage/messages`,
        {
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then((response) => {
        this.messagesList = response.data.messages_list;
      })
      .catch((error) => {
        this.apiErrors(error.response);
      })
    },
    messageTrim(text) {
      return (text.length > 20) ? text.substr(0, 20) + "..." : text;
    }
  },
  mounted() {
    this.getMessages();
  }
}
</script>

<style scoped lang="scss">
.messages-list-container {
  min-height: calc(100vh - 60px);;
  .message {
    display: flex;
    justify-content: flex-start;
    border-bottom: 1px solid #888;
    padding: 10px;
    text-decoration: none;
    &--left {
      &--user-avatar {
        width: 45px;
        height: 45px;
      }
    }
    &--middle {
      margin-left: 10px;
      &--username {
        font-size: 1.1rem;
        font-weight: bold;
        color: #333;
      }
      &--text {
        font-size: 0.8rem;
        color: #888;
      }
    }
    &--right {
      margin-left: auto;
      text-align: right;
      &--datetime {
        font-size: 0.7rem;
        color: #888;
      }
    }
  }
}
</style>