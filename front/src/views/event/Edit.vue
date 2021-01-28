<template>
  <div class="double-container">
    <div class="double-container--left">
      <SideBar :select-menu-prop="104"/>
    </div>
    <div class="double-container--right">
      <div class="event-edit-container">
        <h1 class="main-title text-center">イベント編集</h1>
        <ErrMsg :error-messages-prop="apiErrorMessages"/>
        <EventForm v-if="event"
          :event-prop="event"
          :modal-msg-prop="modalMsg"
          @post-event="updateEvent"/>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import SideBar from "@/components/organisms/common/SideBar.vue";
import EventForm from "@/components/organisms/events/EventForm.vue";
import ErrMsg from "@/components/organisms/common/ErrMsg.vue";
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [errorMethods],
  components: {
    SideBar,
    EventForm,
    ErrMsg
  },
  data() {
    return {
      event: '',
      modalMsg: {
        title: "イベント変更",
        message: 'イベントの内容を変更します。よろしいですか？',
        btn: "変更"
      },
      apiErrorMessages: []
    }
  },
  methods: {
    getEvent: function() {
      axios.get(
        `http://${g.hostName}/api/events/${this.$route.params.id}/edit`,
        {
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then((response) => {
        this.event = response.data
      })
      .catch((error) => {
        this.apiErrors(error.response.status);
      });
    },
    updateEvent: function(event) {
      axios.put(
        `http://${g.hostName}/api/events/${event.id}`,
        {
          user_id: this.$store.getters['user/id'],
          event: event
        },
        {
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then(() => {
        this.apiErrorMessages = []
        this.$router.push({
          name: "EventShow"
        })
      })
      .catch((error) => {
        this.apiErrorMessages = error.response.data;
        this.apiErrors(error.response.status);
      });
    }
  },
  mounted() {
    this.getEvent();
  }
}
</script>

<style scoped lang="scss">
.event-edit-container {
  width: 100%;
  margin: 0 auto;
  padding: 20px 0;
  background: #FFF;
}
</style>