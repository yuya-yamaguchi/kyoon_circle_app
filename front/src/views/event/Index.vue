<template>
  <div class="single-container">
    <h1 class="main-title">イベント一覧</h1>
    <p class="event-explain">
      セッションや飲み会など、毎月いろんなイベントを開催しています！<br>
      お気軽にご参加ください！
    </p>
    <EventList v-if="events.length!=0" :events-prop="events"/>
    <Pagination :pagy-prop="pagy" @chage-page="changePage"/>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import EventList from '@/components/EventList.vue';
import Pagination from '@/components/Pagination.vue';

export default {
  components: {
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
        console.log(this.pagy);
      })
      .catch(function(error) {
        console.log(error);
      });
    },
    changePage: function(pageNo) {
      this.$router.push({
        name: "EventIndex",
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
.event-explain {
  padding: 20px;
}
</style>