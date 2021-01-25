<template>
  <div>
    <BreadCrumbs :breadCrumbs="breadCrumbs"/>
    <div class="single-container">
      <h1 class="main-title">イベント一覧</h1>
      <p class="event-explain">
        セッションや飲み会など、毎月いろんなイベントを開催しています！<br>
        お気軽にご参加ください！
      </p>
      <select v-model="selectEventType" @change="searchEvents(value)">
        <option value="0">すべて</option>
        <option v-for="option in options" :value="option.event_type" :key="option.event_type">
          {{ option.name }}
        </option>
      </select>
      <EventList v-if="events.length!=0" :events-prop="events"/>
      <div v-if="events.length==0" class="nothing-msg">該当のイベントはありません</div>
      <Pagination v-if="events.length!=0" :pagy-prop="pagy" @chage-page="changePage"/>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import EventList from '@/components/EventList.vue';
import Pagination from '@/components/Pagination.vue';
import BreadCrumbs from "@/components/BreadCrumbs.vue";
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [errorMethods],
  components: {
    EventList,
    Pagination,
    BreadCrumbs
  },
  data() {
    var selectEventType = (this.$route.query.event_type == undefined ) ? 0 : this.$route.query.event_type
    return {
      events: [],
      pagy: "",
      selectEventType: selectEventType,
      options: [
        { event_type: 1, name: 'セッション' },
        { event_type: 2, name: '飲み会・懇親会' },
        { event_type: 3, name: '合宿' },
        { event_type: 4, name: 'その他' }
      ]
    }
  },
  computed: {
    breadCrumbs() {
      var breadCrumbsLists = [
        {
          name: 'トップ',
          path: '/'
        },
        {
          name: 'イベント一覧',
          path: ''
        }
      ]
      return breadCrumbsLists
    }
  },
  watch: {
    // パラメータのみの変更はコンポーネントが再描画されないため、
    // $routeが変更されたことをパラメータが変更されたことをwatchにて検知する
    '$route' (to) {
      if ( to.query.page != undefined ) {
        this.getEvents(to.query.page, to.query.event_type)
      }
    }
  },
  methods: {
    getEvents: function(pageNo, eventType) {
      axios.get(
        `http://${g.hostName}/api/events`,
        {
          params: {
            page: pageNo,
            event_type: eventType
          }
        }
      )
      .then((response) => {
        this.events = response.data.events;
        this.pagy = response.data.pagy;
      })
      .catch((error) => {
        this.apiErrors(error.response.status);
      });
    },
    changePage: function(pageNo) {
      this.$router.push({
        name: "EventIndex",
        query: {
          page: pageNo,
          event_type: this.selectEventType
        }
      })
    },
    searchEvents: function() {
      this.$router.push({
        name: "EventIndex",
        query: {
          page: 1,
          event_type: this.selectEventType
        }
      })
    }
  },
  mounted: function() {
    // var eventType = this.$route.query.event_type == undefined ? this.$route.query.event_type : 0
    this.getEvents(this.$route.query.page, this.$route.query.event_type);
  }
}
</script>

<style scoped lang="scss">
.event-explain {
  padding: 20px;
}
select {
  margin-left: 20px;
}
</style>