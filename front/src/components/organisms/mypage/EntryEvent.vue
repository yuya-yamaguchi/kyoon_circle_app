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

export default {
  mixins: [errorMethods],
  components: {
    EventList,
    Loading
  },
  data() {
    return {
      futureEvents: [],
      historyEvents: [],
      currentTab: 1,
      loading: true
    }
  },
  methods: {
    getMyEvents: function() {
      axios.get(
        `http://${g.hostName}/api/mypage/events`,
        {
          params: {
            user_id: this.$store.getters['user/id']
          },
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then((response) => {
        this.futureEvents  = response.data.future_events;
        this.historyEvents  = response.data.history_events;
      })
      .catch((error) => {
        this.apiErrors(error.response);
      })
      .finally(() => {
        this.loading = false
      });
    },
    changeTab: function(num) {
      this.currentTab = num
    }
  },
  mounted() {
    this.getMyEvents();
  }
}
</script>

<style lang="scss" scoped>
.my-events {
  padding: 10px;
}
</style>