<template>
  <div class="single-container">
    <h1 class="main-title">イベント一覧</h1>
    <p class="event-explain">
      セッションや飲み会など、毎月いろんなイベントを開催しています！<br>
      お気軽にご参加ください！
    </p>
    <EventList v-if="events.length!=0" :events-prop="events"/>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import EventList from '@/components/EventList.vue';

export default {
  components: {
    EventList
  },
  data() {
    return {
      events: []
    }
  },
  methods: {
    getEvents: function() {
      axios.get(
        `http://${g.hostName}/api/events`
      )
      .then((response) => {
        this.events = response.data;
      })
      .catch(function(error) {
        console.log(error);
      });
    }
  },
  mounted: function() {
    this.getEvents();
  }
}
</script>

<style scoped lang="scss">
.event-explain {
  padding: 20px;
}
</style>