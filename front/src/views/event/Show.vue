<template>
  <div class="single-container">
    <p class="main-title">{{ event.title }}</p>
    <p class="event--details">{{ event.details }}</p>
    <p class="event--details">開催日時 {{ event.start_datetime }}</p>
    <p class="event--fee">参加費 {{ event.fee }}</p>
  </div>
</template>

<script>
import axios from 'axios';

const hostName = 'localhost:3000';

export default {
  data() {
    return {
      event: ""
    }
  },
  methods: {
    getEvent: function() {
      console.log("a")
      axios.get(
        `http://${hostName}/api/events/${this.$route.params.id}`
      )
      .then((response) => {
        console.log(response);
        this.event = response.data;
      })
      .catch(function(error) {
        console.log(error);
      });
    }
  },
  mounted: function() {
    this.getEvent();
  }
}
</script>

<style scoped lang="scss">
</style>