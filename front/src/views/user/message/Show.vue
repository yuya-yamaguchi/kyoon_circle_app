<template>
  <div class="message-container">
    <div class="message-contents">
      <div class="">
        
      </div>
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
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [errorMethods],
  data() {
    return {
      messageroom: {},
      message: {}
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
        this.messageroom = response.data.messageroom
      })
      .catch((error) => {
        this.apiErrors(error.response);
      })
      .finally(() => {
        
      });
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
        console.log(response);
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
  .send-message {
    display: flex;
    justify-content: space-between;
    background: red;
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
      cursor: pointer;
    }
  }
}
</style>