<template>
  <div class="about-event">
    <h3 class="top-each-title">EVENT</h3>
    <div class="about-event--content">
      <Loading v-if="loadingProp"/>
      <div class="event-lists w800">
        <EventList v-if="eventsProp.length!=0" :events-prop="eventsProp"/>
        <div v-else class="nothing-msg" style="margin-bottom: 30px;">開催予定のイベントはありません</div>
        <router-link :to="{name: 'EventIndex', query: {page: 1}}" class="all-view-link">すべてのイベントを見る</router-link>
      </div>
    </div>
  </div>
</template>

<script>
import EventList from '@/components/organisms/events/EventList.vue';
import Loading from '@/components/organisms/common/Loading.vue';

export default {
  props: {
    eventsProp: {},
    loadingProp: {}
  },
  components: {
    EventList,
    Loading
  }
}
</script>

<style scoped lang="scss">
.about-event {
  padding: 100px 10px;
  .event-lists{
    margin-top: 20px;
  }
}
.top-each-title {
  font-size: 40px;
  font-weight: bold;
  text-align: center;
}
</style>