<template>
  <div>
    <div v-for="(event, i) in eventsProp" :key="i">
      <router-link :to="transLinks(event.id)" class="event-card">
        <div v-if="checkDateOver(event.start_datetime)" class="event-end">このイベントは終了しました</div>
        <div class="event-card--left">
          <p class="event-card--left--date">{{ formatDate(event.start_datetime, 'M/D') }}</p>
          <p class="event-card--left--week">{{ calcWeek(event.start_datetime, 2) }}</p>
        </div>
        <div class="event-card--middle">
          <p class="event-card--middle--title">{{ event.title }}</p>
          <p class="event-card--middle--type">{{ event.event_category }}</p>
          <p>参加費
            <span class="event-card--middle--fee">{{ event.fee }}</span>
          </p>
        </div>
        <div class="event-card--right">
          <div class="entry-user-cnt some-updown-center">
            <fa class="entry-user-cnt--icon" icon="user"/>
            <span class="entry-user-cnt--num">{{ event.entry_count }}</span>
          </div>
        </div>
      </router-link>
    </div>
  </div>
</template>

<script>
import { commonMethods } from '@/mixins/commonMethods';

export default {
  mixins: [commonMethods],
  props: {
    eventsProp: {}
  },
  methods: {
    checkDateOver: function(dateTime) {
      var today = new Date();
      var holdDate = new Date(dateTime.substr(0, 4),
                              Number(dateTime.substr(5, 2))-1,
                              dateTime.substr(8, 2),
                              23, 59, 59)
      return (holdDate < today) ? true : false
    },
    transLinks: function(eventId) {
      return (location.pathname == '/events/editlist') ? `/event/${eventId}/edit` : `/event/${eventId}`
    }
  }
}
</script>

<style scoped lang="scss">
.event-card {
  margin-bottom: 20px;
  color: #333;
  background: #FFF;
  display: flex;
  justify-content: flex-start;
  text-decoration: none;
  box-shadow:  2px 2px 0 0 rgba(0,0,0,0.3);
  position: relative;
  .event-end {
    position: absolute;
    width: 100%;
    height: 100%;
    color: #FFF;
    font-size: 20px;
    font-weight: bold;
    display: flex;
    justify-content: center;
    align-items: center;
    background-color: rgba(0,0,0,0.6);
    z-index: 1;
  }
  &--left {
    width: 20%;
    max-width: 100px;
    padding: 20px;
    font-weight: bold;
    text-align: center;
    background: var(--accent-color);
    &--date {
      font-size: 24px;
    }
    &--week {
      font-size: 20px;
      color: #FFF;
    }
  }
  &--middle {
    padding: 10px;
    width: 80%;
    &--title {
      font-size: 18px;
    }
    &--type {
      background: rgb(71, 71, 241);
      display: inline-block;
      color: #FFF;
      font-size: 10px;
      font-weight: bold;
      border-radius: 5px;
      padding: 2px 10px;
      margin: 5px 0;
    }
    &--fee {
      font-weight: bold;
      margin-left: 10px;
    }
  }
  &--right {
    .entry-user-cnt {
      margin: 5px 5px 0 0;
      white-space: nowrap;
      color: #888;
      &--icon {
        width: 14px;
        height: 14px;
      }
      &--num {
        margin-left: 2px;
        font-size: 16px;
        font-weight: bold;
      }
    }
  }
}
</style>