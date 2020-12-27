<template>
  <div class="single-container">
    {{ event.id }}
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
    },
    mounted: function() {
      this.getEvent();
    }
  }
}
</script>

<style scoped lang="scss">
</style>