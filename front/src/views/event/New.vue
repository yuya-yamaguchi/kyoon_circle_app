<template>
  <div class="double-container">
    <div class="double-container--left">
      <SideBar :select-menu-prop="103"/>
    </div>
    <div class="double-container--right">
      <h1 class="main-title text-center">イベント登録</h1>
      <ErrMsg :error-messages-prop="apiErrorMessages"/>
      <EventForm :event-prop="event" @post-event="postNewEvent"/>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import SideBar from "@/components/SideBar.vue";
import EventForm from "@/components/EventForm.vue";
import ErrMsg from "@/components/ErrMsg.vue";

export default {
  components: {
    SideBar,
    EventForm,
    ErrMsg
  },
  data() {
    return {
      event: {
        event_type: 0,
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
        }
      )
      .then((response) => {
        this.apiErrorMessages = []
        console.log(response);
      })
      .catch((error) => {
        this.apiErrorMessages = error.response.data;
      });
    }
  }
}
</script>

<style scoped lang="scss">
.event-time {
  width: 50px;
}
</style>