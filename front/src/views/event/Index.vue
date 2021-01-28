<template>
  <div>
    <BreadCrumbs :breadCrumbs="breadCrumbs"/>
    <div class="single-container">
      <h1 class="main-title">イベント一覧</h1>
      <p class="event-explain">
        セッションや飲み会など、毎月いろんなイベントを開催しています！<br>
        お気軽にご参加ください！
      </p>
      <SearchEvent :searchSelectProp="searchSelect" @search-events="searchEvents"/>
      <EventList v-if="events.length!=0" :events-prop="events"/>
      <div v-if="events.length==0" class="nothing-msg">該当のイベントはありません</div>
      <Pagination v-if="events.length!=0" :pagy-prop="pagy" @chage-page="changePage"/>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import EventList from '@/components/organisms/events/EventList.vue';
import SearchEvent from '@/components/organisms/events/SearchEvent.vue';
import Pagination from '@/components/organisms/common/Pagination.vue';
import BreadCrumbs from "@/components/organisms/common/BreadCrumbs.vue";
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [errorMethods],
  components: {
    EventList,
    SearchEvent,
    Pagination,
    BreadCrumbs
  },
  data() {
    var selectEventType = (this.$route.query.event_type == undefined ) ? 0 : this.$route.query.event_type
    return {
      events: [],
      pagy: "",
      searchSelect: {
        eventType: selectEventType
      }
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
    searchEvents: function(searchSelect) {
      this.$router.push({
        name: "EventIndex",
        query: {
          page: 1,
          event_type: searchSelect.eventType
        }
      })
    }
  },
  mounted: function() {
    this.getEvents(this.$route.query.page, this.$route.query.event_type);
  }
}
</script>

<style scoped lang="scss">
.event-explain {
  padding: 20px;
}
</style>