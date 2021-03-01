<template>
  <div class="single-container">
    <Calendar :stayrooms-prop="stayrooms"/>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import Calendar from '@/components/organisms/stayroom/Calendar.vue';
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [errorMethods],
  data() {
    return {
      stayrooms: []
    }
  },
  components: {
    Calendar
  },
  methods: {
    getStayRooms: function() {
      axios.get(
        `http://${g.hostName}/api/stayrooms`
      )
      .then((response) => {
        this.stayrooms = response.data.stayrooms
      })
      .catch((error) => {
        this.apiErrors(error.response);
      });
    },
  },
  mounted() {
    this.getStayRooms();
  }
}
</script>

<style scoped lang="scss">
</style>