<template>
  <div>
    <div class="tabs">
      <div class="tabs--tab"
            :class="{ active: currentTab === 1 }"
            @click="changeTab(1)">
        参加予定のイベント
      </div>
      <div class="tabs--tab"
            :class="{ active: currentTab === 2 }"
            @click="changeTab(2)">
        参加したイベント
      </div>
    </div>
    <Loading v-if="loading"/>
    <div v-else>
      <div v-show="currentTab === 1" class="my-events">
        <EventList v-if="futureEvents.length!=0" :events-prop="futureEvents"/>
        <p v-else class="nothing-msg">参加予定のイベントはありません</p>
      </div>
      <div v-show="currentTab === 2" class="my-events">
        <EventList v-if="historyEvents.length!=0" :events-prop="historyEvents"/>
        <p v-else class="nothing-msg">過去参加したイベントはありません</p>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import EventList from '@/components/organisms/events/EventList.vue';
import Loading from '@/components/organisms/common/Loading.vue';
import { errorMethods } from '@/mixins/errorMethods';
import { scrollable } from '@/mixins/scrollable';

export default {
  mixins: [errorMethods, scrollable],
  components: {
    EventList,
    Loading
  },
  data() {
    return {
      futureEvents: [],
      futurePage: 0,
      futureLastPage: 1,
      historyEvents: [],
      historyPage: 0,
      historyLastPage: 1,
      currentTab: 1,
      loading: true
    }
  },
  methods: {
    getFutureEvents() {
      axios.get(
        `http://${g.hostName}/api/mypage/future_events`,
        {
          params: {
            user_id: this.$store.getters['user/id'],
            page:    this.futurePage + 1
          },
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then((response) => {
        this.futureEvents = this.futureEvents.concat(response.data.future_events);
        this.futurePage = response.data.pagy.page
        this.futureLastPage = response.data.pagy.last
      })
      .catch((error) => {
        this.apiErrors(error.response);
      })
      .finally(() => {
        this.loading = false
        this.requesting = false
      });
    },
    getHistoryEvents() {
      axios.get(
        `http://${g.hostName}/api/mypage/history_events`,
        {
          params: {
            user_id: this.$store.getters['user/id'],
            page:    this.historyPage + 1
          },
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then((response) => {
        this.historyEvents = this.historyEvents.concat(response.data.history_events);
        this.historyPage = response.data.pagy.page
        this.historyLastPage = response.data.pagy.last
      })
      .catch((error) => {
        this.apiErrors(error.response);
      })
      .finally(() => {
        this.loading = false
        this.requesting = false
      });
    },
    changeTab(tabNo) {
      if (this.currentTab === tabNo) { return }

      // 初回読込の時は読込のCSSを出すため、loadingをTrueにする
      if (this.futurePage === 0 || this.historyPage === 0) { this.loading = true }
      this.currentTab = tabNo
      this.fetchNextPage()
    },
    fetchNextPage() {
      if (this.requesting) { return }
      
      if (this.currentTab === 1) {
        if (this.futureLastPage > this.futurePage) {
          this.getFutureEvents()
        }
      } else {
        if (this.historyLastPage > this.historyPage) {
          this.getHistoryEvents()
        }
      }
    },
  },
  mounted() {
    this.getFutureEvents();
    document.addEventListener('scroll', this.handleScroll);
  },
  unmounted() {
    document.removeEventListener('scroll', this.handleScroll)
  }
}
</script>

<style lang="scss" scoped>
.my-events {
  padding: 10px;
}
</style>