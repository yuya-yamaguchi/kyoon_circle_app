<template>
  <div class="message-container">
    <BreadCrumbs :breadCrumbs="breadCrumbs"/>
    <div class="message-contents">
      <div class="messages-display">
        <MessageDisplay
          v-if="messages.length!=0"
          :messagesProp="messages"
          :dmUserProp="dmUser"/>
      </div>
      <div class="send-message">
        <div class="send-message-form">
          <textarea v-model="message.text"></textarea>
          <fa @click="postMessage()" icon="paper-plane"></fa>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import MessageDisplay from "@/components/organisms/message/MessageDisplay.vue";
import BreadCrumbs from "@/components/organisms/common/BreadCrumbs.vue";
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [errorMethods],
  components: {
    MessageDisplay,
    BreadCrumbs
  },
  data() {
    return {
      messageroom: {},
      message: {},  // 送信用のメッセージ
      messages: [], // 既存メッセージ
      dmUser: {}
    }
  },
  computed: {
    breadCrumbs() {
      var breadCrumbsLists = [
        {
          name: 'トップ',
          path: '/'
        },
        {
          name: 'マイページ',
          path: '/mypage'
        },
        {
          name: 'メッセージ',
          path: '/mypage/messages'
        },
        {
          name: this.dmUser.name,
          path: ''
        }
      ]
      return breadCrumbsLists
    }
  },
  methods: {
    getMessages: function() {
      axios.get(
        `http://${g.hostName}/api/users/${this.$route.params.id}/messages`,
        {
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then((response) => {
        this.messageroom = response.data.messageroom;
        this.messages    = response.data.messages;
        this.dmUser      = response.data.dm_user;
      })
      .catch((error) => {
        this.apiErrors(error.response);
      })
    },
    postMessage: function() {
      axios.post(
        `http://${g.hostName}/api/users/${this.$route.params.id}/messages`,
        {
          messageroom: this.messageroom,
          message: this.message
        },
        {
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then((response) => {
        this.message = {};
        this.messages.push(response.data.message);
      })
      .catch((error) => {
        this.apiErrors(error.response);
      })
      .finally(() => {
        
      });
    }
  },
  mounted() {
    this.getMessages();
  }
}
</script>

<style scoped lang="scss">
.message-contents {
  padding-top: 40px;
  .messages-display {
    max-width: 1000px;
    margin: 0 auto;
    margin-bottom: 60px;
    min-height: calc(100vh - 170px);
    overflow-y: scroll;
  }
  .send-message {
    background: #333;
    padding: 10px;
    position: fixed;
    bottom: 0;
    width: 100%;
    box-sizing: border-box;
    .send-message-form {
      display: flex;
      justify-content: space-between;
      max-width: 1200px;
      margin: 0 auto;
      textarea {
        display: block;
        width: 98%;
        padding: 5px;
        margin-right: 10px;
        font-size: 0.9rem;
      }
      svg {
        width: 20px;
        padding: 5px;
        color: #FFF;
        cursor: pointer;
      }
    }
  }
}
</style>