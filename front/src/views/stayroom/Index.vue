<template>
  <div>
    <BreadCrumbs :breadCrumbs="breadCrumbs"/>
    <div class="single-container">
      <StayroomCalendar :stayrooms-prop="stayrooms"/>
      <StayroomCation/>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import BreadCrumbs from "@/components/organisms/common/BreadCrumbs.vue";
import StayroomCalendar from '@/components/organisms/stayroom/StayroomCalendar.vue';
import StayroomCation from '@/components/organisms/stayroom/StayroomCation.vue';
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [errorMethods],
  components: {
    BreadCrumbs,
    StayroomCalendar,
    StayroomCation
  },
  computed: {
    breadCrumbs() {
      const breadCrumbsLists = [
        { name: 'トップ',
          path: '/'
        },
        { name: '宿泊予約',
          path: ''
        }
      ]
      return breadCrumbsLists
    }
  },
  data() {
    return {
      stayrooms: []
    }
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