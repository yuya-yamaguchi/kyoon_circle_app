<template>
  <div>
    <BreadCrumbs :breadCrumbs="breadCrumbs"/>
    <div class="single-container">
      <h1 class="main-title">イベント一覧</h1>
      <p class="event-explain">
        セッションや飲み会など、毎月いろんなイベントを開催しています！<br>
        お気軽にご参加ください！
      </p>
      <SearchEvent :selectEventCategoryProp="selectEventCategory" @search-events="searchEvents"/>
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
    let selectEventCategory = (this.$route.query.event_category == undefined ) ? 0 : this.$route.query.event_category
    return {
      events: [],
      pagy: "",
      selectEventCategory: selectEventCategory
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
        this.getEvents(to.query.page, to.query.event_category)
      }
    }
  },
  methods: {
    getEvents: function(pageNo, eventCategory) {
      axios.get(
        `http://${g.hostName}/api/events`,
        {
          params: {
            page: pageNo,
            event_category_id: eventCategory
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
          eventCategory: this.selectEventCategory
        }
      })
    },
    searchEvents: function(selectEventCategory) {
      this.$router.push({
        name: "EventIndex",
        query: {
          page: 1,
          event_category: selectEventCategory
        }
      })
    }
  },
  mounted: function() {
    this.getEvents(this.$route.query.page, this.$route.query.event_category);
  }
}
</script>

<style scoped lang="scss">
.event-explain {
  padding: 20px;
}
</style>