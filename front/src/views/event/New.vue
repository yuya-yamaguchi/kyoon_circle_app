<template>
  <div class="double-container">
    <div class="double-container--left">
      <SideBar :select-menu-prop="103"/>
    </div>
    <div class="double-container--right">
      <div class="event-new-container">
        <h1 class="main-title text-center">イベント登録</h1>
        <ErrMsg :error-messages-prop="apiErrorMessages"/>
        <EventForm :event-prop="event" :modal-msg-prop="modalMsg" @post-event="postNewEvent"/>
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
      event: {
        title: "",
        details: "",
        start_date: "",
        start_hour: "",
        start_min: "",
        end_hour: "",
        end_min: "",
        place: "",
        fee: "",
        max_entry: 0,
        line_msg_push: true
      },
      modalMsg: {
        title: "イベントの登録",
        message: 'イベントを登録します。よろしいですか？',
        btn: "登録"
      },
      apiErrorMessages: []
    }
  },
  methods: {
    postNewEvent: function(event) {
      axios.post(
        `http://${g.hostName}/api/events`,
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
      .then((response) => {
        this.apiErrorMessages = []
        this.$router.push({
          name: "EventShow",
          params: {
            id: response.data.id
          }
        })
      })
      .catch((error) => {
        this.apiErrors(error.response.status);
        this.apiErrorMessages = error.response.data;
      });
    }
  }
}
</script>

<style scoped lang="scss">
.event-new-container {
  width: 100%;
  margin: 0 auto;
  padding: 20px 0;
  background: #FFF;
  .event-time {
    width: 50px;
  }
}
</style>