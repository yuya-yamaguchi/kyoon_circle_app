<template>
  <div class="single-container">
    <EventList v-if="events.length!=0" :events-prop="events"/>
  </div>
</template>

<script>
import axios from 'axios';
import EventList from '@/components/EventList.vue';

const hostName = 'localhost:3000';

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
        `http://${hostName}/api/events`
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
</style>