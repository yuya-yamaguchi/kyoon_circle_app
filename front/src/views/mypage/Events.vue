<template>
  <div class="double-container">
    <div class="double-container--left">
      <SideBar :select-menu-prop="4"/>
    </div>
    <div class="double-container--right">
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
import SideBar from "@/components/SideBar.vue";
import EventList from '@/components/EventList.vue';

export default {
  components: {
    SideBar,
    EventList
  },
  data() {
    return {
      futureEvents: [],
      historyEvents: [],
      currentTab: 1
    }
  },
  methods: {
    getMyEvents: function() {
      axios.get(
        `http://${g.hostName}/api/mypage/events`,
        {
          params: {
            user_id: this.$store.getters['user/id']
          }
        }
      )
      .then((response) => {
        this.futureEvents  = response.data.future_events;
        this.historyEvents  = response.data.history_events;
      })
      .catch(function(error) {
        console.log(error);
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
  background: #FFF;
  padding: 10px;
}
</style>