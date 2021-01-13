<template>
  <div>
    <div v-for="(event, i) in eventsProp" :key="i">
      <router-link :to="`/event/${event.id}`" class="event-card">
        <div v-if="checkDateOver(event.start_date)" class="event-end">このイベントは終了しました</div>
        <div class="event-card--left">
          <p class="event-card--left--date">{{ holdDate(event.start_date) }}</p>
          <p class="event-card--left--week">{{ event.start_week }}</p>
        </div>
        <div class="event-card--middle">
          <p class="event-card--middle--title">{{ event.title }}</p>
          <p v-if="event.event_type=='1'" class="event-card--middle--type">セッション</p>
          <p v-else-if="event.event_type=='2'" class="event-card--middle--type">飲み会・懇親会</p>
          <p v-else-if="event.event_type=='3'" class="event-card--middle--type">合宿</p>
          <p v-else-if="event.event_type=='4'" class="event-card--middle--type">その他</p>
          <p>参加費
            <span class="event-card--middle--fee">{{ event.fee }}</span>
          </p>
        </div>
        <div v-if="editLink()" class="event-card--right">
          <router-link :to="`/event/${event.id}/edit`">
            編集
          </router-link>
        </div>
      </router-link>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    eventsProp: {}
  },
  methods: {
    holdDate: function(startDate) {
      return Number(startDate.substr(5, 2)) + '/' + Number(startDate.substr(8, 2))
    },
    checkDateOver: function(startDate) {
      var today = new Date();
      var holdDate = new Date(startDate.substr(0, 4),
                              Number(startDate.substr(5, 2))-1,
                              startDate.substr(8, 2))
      if ( holdDate < today ) {
        return true
      }
      return false
    },
    editLink: function() {
      if (location.pathname == '/event/editlist') {
        return true
      }
      return false
    }
  }
}
</script>

<style scoped lang="scss">
.event-card {
  margin: 20px;
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
    width: 100px;
    padding: 20px;
    font-weight: bold;
    text-align: center;
    background: orange;
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
    &--title {
      font-size: 20px;
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
    margin-left: auto;
    a {
      display: block;
      text-decoration: none;
      background: red;
      color: #FFF;
      font-size: 14px;
      font-weight: bold;
      border-radius: 10px;
      padding: 2px 10px;
      margin: 10px;
    }
    a:hover {
      opacity: 0.6;
    }
  }
}
</style>