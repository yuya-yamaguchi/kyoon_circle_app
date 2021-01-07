<template>
  <div class="double-container">
    <div class="double-container--left">
      <SideBar :select-menu-prop="104"/>
    </div>
    <div class="double-container--right">
      <EventList v-if="events.length!=0" :events-prop="events"/>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import SideBar from "@/components/SideBar.vue";
import EventList from '@/components/EventList.vue';

export default {
  components: {
    SideBar,
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
</style>