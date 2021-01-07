<template>
  <div class="double-container">
    <div class="double-container--left">
      <SideBar :select-menu-prop="104"/>
    </div>
    <div class="double-container--right">
      <h1 class="main-title text-center">イベント編集</h1>
      <ErrMsg :error-messages-prop="apiErrorMessages"/>
      <EventForm v-if="event" :event-prop="event" @post-event="updateEvent"/>
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
      event: '',
      apiErrorMessages: []
    }
  },
  methods: {
    getEvent: function() {
      axios.get(
        `http://${g.hostName}/api/events/${this.$route.params.id}/edit`
      )
      .then((response) => {
        this.event = response.data
      })
      .catch((error) => {
        console.log(error);
      });
    },
    updateEvent: function(event) {
      axios.put(
        `http://${g.hostName}/api/events/${event.id}`,
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
  },
  mounted() {
    console.log(this.event.title);
    this.getEvent();
  }
}
</script>

<style scoped lang="scss">
</style>