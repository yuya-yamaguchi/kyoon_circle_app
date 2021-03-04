<template>
  <div>
    <BreadCrumbs :breadCrumbs="breadCrumbs"/>
    <div class="single-container">
      <h1 class="main-title">イベント一覧</h1>
      <p class="event-explain">
        セッションや飲み会など、毎月いろんなイベントを開催しています！<br>
        お気軽にご参加ください！
      </p>
      <div class="event-list">
        <SearchEvent :searchProp="search" @search-events="searchEvents"/>
        <Loading v-if="loading"/>
        <div v-else>
          <EventList v-if="events.length!=0" :events-prop="events"/>
          <div v-if="events.length==0" class="nothing-msg">該当のイベントはありません</div>
        </div>
        <Pagination v-if="events.length!=0" :pagy-prop="pagy" @chage-page="changePage"/>
      </div>
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
import Loading from '@/components/organisms/common/Loading.vue';
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [errorMethods],
  components: {
    EventList,
    SearchEvent,
    Pagination,
    BreadCrumbs,
    Loading
  },
  data() {
    let selectEventCategory = (this.$route.query.event_category == undefined ) ? 0 : this.$route.query.event_category;
    let selectOrder = (this.$route.query.order == undefined ) ? 'date_desc' : this.$route.query.order;
    let selectEndEventHide = (this.$route.query.end_event_hide == undefined ) ? false : this.$route.query.end_event_hide;
    return {
      events: [],
      pagy: "",
      search: {
        eventCategory: selectEventCategory,
        order:         selectOrder,
        endEventHide:  selectEndEventHide
      },
      loading: true
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
        this.getEvents(to.query)
      }
    }
  },
  methods: {
    getEvents: function(searchParams) {
      axios.get(
        `http://${g.hostName}/api/events`,
        {
          params: {
            page:           searchParams.page,
            event_category: searchParams.event_category,
            order:          searchParams.order,
            end_event_hide: searchParams.end_event_hide
          },
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then((response) => {
        this.events = response.data.events;
        this.pagy = response.data.pagy;
      })
      .catch((error) => {
        this.apiErrors(error.response);
      })
      .finally(() => {
        this.loading = false;
      });
    },
    changePage: function(pageNo) {
      this.$router.push({
        name: "EventIndex",
        query: {
          page: pageNo,
          event_category: this.search.eventCategory,
          order: this.search.order,
          end_event_hide: this.search.endEventHide
        }
      })
    },
    searchEvents: function(search) {
      this.search = search;
      this.$router.push({
        name: "EventIndex",
        query: {
          page: 1,
          event_category: this.search.eventCategory,
          order: this.search.order,
          end_event_hide: this.search.endEventHide
        }
      })
    }
  },
  mounted: function() {
    this.getEvents(this.$route.query);
  }
}
</script>

<style scoped lang="scss">
.event-explain {
  padding: 20px;
}
.event-list {
  max-width: 900px;
  margin: 0 auto;
}
</style>