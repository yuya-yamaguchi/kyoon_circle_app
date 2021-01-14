<template>
  <div class="double-container">
    <div class="double-container--left">
      <SideBar :select-menu-prop="104"/>
    </div>
    <div class="double-container--right">
      <EventList v-if="events.length!=0" :events-prop="events"/>
      <Pagination :pagy-prop="pagy" @chage-page="changePage"/>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import SideBar from "@/components/SideBar.vue";
import EventList from '@/components/EventList.vue';
import Pagination from '@/components/Pagination.vue';

export default {
  components: {
    SideBar,
    EventList,
    Pagination
  },
  data() {
    return {
      events: [],
      pagy: ""
    }
  },
  watch: {
    // パラメータのみの変更はコンポーネントが再描画されないため、
    // $routeが変更されたことをパラメータが変更されたことをwatchにて検知する
    '$route' (to) {
      this.getEvents(to.query.page)
    }
  },
  methods: {
    getEvents: function(pageNo) {
      axios.get(
        `http://${g.hostName}/api/events?page=${pageNo}`
      )
      .then((response) => {
        this.events = response.data.events;
        this.pagy = response.data.pagy;
      })
      .catch(function(error) {
        console.log(error);
      });
    },
    changePage: function(pageNo) {
      this.$router.push({
        name: "EventEditList",
        query: {
          page: pageNo
        }
      })
    }
  },
  mounted: function() {
    this.getEvents(this.$route.query.page);
  }
}
</script>

<style scoped lang="scss">
</style>