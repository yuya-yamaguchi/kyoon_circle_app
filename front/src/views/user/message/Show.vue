<template>
  <div class="message-container">
    <div  class="message-contents">
      <MessageDisplay
        v-if="messages.length!=0"
        :messagesProp="messages"
        :dmUserProp="dmUser"/>
      <div class="send-message">
        <textarea v-model="message.text"></textarea>
        <fa @click="postMessage()" icon="paper-plane"></fa>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import MessageDisplay from "@/components/organisms/message/MessageDisplay.vue";
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [errorMethods],
  components: {
    MessageDisplay
  },
  data() {
    return {
      messageroom: {},
      message: {},  // 送信用のメッセージ
      messages: [], // 既存メッセージ
      dmUser: {}
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
.message-container {
  min-height: calc(100vh - 130px);
  .send-message {
    display: flex;
    justify-content: space-between;
    background: #333;
    padding: 10px;
    position: fixed;
    bottom: 0;
    width: 100%;
    box-sizing: border-box;
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
</style>