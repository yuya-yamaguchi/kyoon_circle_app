<template>
  <div class="double-container">
    <div class="double-container--left">
      <SideBar :select-menu-prop="104"/>
    </div>
    <div class="double-container--right">
      <h1 class="main-title">イベント編集</h1>
      <EventList v-if="events.length!=0" :events-prop="events"/>
      <Pagination :pagy-prop="pagy" @chage-page="changePage"/>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import SideBar from "@/components/organisms/common/SideBar.vue";
import EventList from '@/components/organisms/events/EventList.vue';
import Pagination from '@/components/organisms/common/Pagination.vue';
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [errorMethods],
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
      if ( to.query.page != undefined ) {
        this.getEvents(to.query.page)
      }
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
      .catch((error) => {
        this.apiErrors(error.response);
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