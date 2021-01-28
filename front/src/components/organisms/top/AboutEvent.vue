<template>
  <div class="about-event">
    <h3 class="top-each-title">EVENT</h3>
    <div class="about-event--content">
      <Loading v-if="loadingProp"/>
      <EventList v-if="eventsProp.length!=0" :events-prop="eventsProp"/>
      <router-link :to="{name: 'EventIndex', query: {page: 1}}" class="all-view-link">すべてのイベントを見る</router-link>
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
  },
  mounted() {
    console.log(this.eventsProp)
  }
}
</script>

<style scoped>
.about-event {
    padding: 100px 20px;
}
.all-view-link {
  display: block;
  text-decoration: none;
  margin: 0 auto;
  text-align: center;
  color: #333;
  font-size: 20px;
  font-weight: bold;
}
.top-each-title {
  font-size: 40px;
  font-weight: bold;
  text-align: center;
}
</style>