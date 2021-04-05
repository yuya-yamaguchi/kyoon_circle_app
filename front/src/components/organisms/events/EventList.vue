<template>
  <div class="event-cards">
    <div v-for="(event, i) in eventsProp" :key="i">
      <router-link :to="transLinks(event.id)" class="event-card">
        <div v-if="checkDateOver(event.start_datetime)" class="event-end">このイベントは終了しました</div>
        <div class="event-card--left">
          <img v-if="event.event_category=='ライブ'" src="/events/live.jpg">
          <img v-else-if="event.event_category=='セッション'" src="/events/session.jpg">
          <img v-else-if="event.event_category=='飲み会・懇親会'" src="/events/bear.jpg">
          <img v-else-if="event.event_category=='合宿'" src="/events/snowboard.jpg">
          <img v-else src="/events/hummingbird.jpg">
          <div v-if="event.entry" class="entry-true">
            参加中
          </div>
          <div class="event-card--left--info">
            <p class="event-card--left--info--date">{{ formatDate(event.start_datetime, 'M/D') }}</p>
            <p class="event-card--left--info--week">{{ calcWeek(event.start_datetime, 2) }}</p>
          </div>
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
          <div class="entry-following-user">
            {{ set_following_users(event.following_users) }}
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
    },
    set_following_users(following_users) {
      if (following_users[0] && following_users[1]) {
        return `${following_users[0]}、${following_users[1]}も参加しています`
      }
      else if (following_users[0]) {
        return `${following_users[0]}も参加しています`
      }
      else {
        return
      }
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
    font-size: 1.1rem;
    font-weight: bold;
    display: flex;
    justify-content: center;
    align-items: center;
    background-color: rgba(0,0,0,0.6);
    z-index: 1;
  }
  &--left {
    min-width: 20%;
    max-width: 100px;
    position: relative;
    img {
      position: absolute;
      width: 100%;
      height: 100%;
      object-fit: cover;
      opacity: 0.3;
    }
    .entry-true {
      position: absolute;
      font-size: 0.7rem;
      padding: 1px 10px;
      margin: 3px 0 0 3px;
      background: orange;
      display: inline-block;
      border-radius: 10px;
      font-weight: bold;
      background:rgba(255, 145, 0, 0.7);
    }
    &--info {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%,-50%);
      text-align: center;
      &--date {
        font-size: 1.2rem;
        font-weight: bold;
      }
      &--week {
        font-size: 1.1rem;
        font-weight: bold;
        color: var(--accent-color);
        
      }
    }
  }
  &--middle {
    padding: 10px;
    width: 70%;
    &--title {
      font-size: 1.0rem;
    }
    &--type {
      background: var(--accent-color);
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
    margin: 5px 5px 0 0;
    display: flex;
    flex-direction: column;
    .entry-user-cnt {
      flex: 1;
      white-space: nowrap;
      color: #888;
      text-align: right;
      display: flex;
      justify-content: flex-end;
      &--icon {
        width: 14px;
        height: 14px;
      }
      &--num {
        margin-left: 2px;
        font-size: 0.9rem;
        font-weight: bold;
      }
    }
    .entry-following-user {
      flex: 2;
      font-size: 0.7rem;
      color: #888;
      max-width: 100px;
      margin-top: 5px;
      bottom: 0;
    }
  }
}
</style>