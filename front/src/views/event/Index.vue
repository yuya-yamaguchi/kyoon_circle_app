<template>
  <div class="single-container">
    <div v-for="(event, i) in events" :key="i">
      {{ event.id }}
    </div>
  </div>
</template>

<script>
import axios from 'axios';

const hostName = 'localhost:3000';

export default {
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