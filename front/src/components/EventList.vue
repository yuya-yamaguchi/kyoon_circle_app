<template>
  <div>
    <div v-for="(event, i) in eventsProp" :key="i">
      <router-link :to="`/event/${event.id}`" class="event-card">
        <div class="event-card--left">
          <p class="event-card--left--date">{{ event.start_date }}</p>
          <p class="event-card--left--week">{{ event.start_week }}</p>
        </div>
        <div class="event-card--right">
          <p class="event-card--right--title">{{ event.title }}</p>
          <p v-if="event.event_type=='1'" class="event-card--right--type">セッション</p>
          <p v-else-if="event.event_type=='2'" class="event-card--right--type">飲み会・懇親会</p>
          <p v-else-if="event.event_type=='3'" class="event-card--right--type">合宿</p>
          <p v-else-if="event.event_type=='4'" class="event-card--right--type">その他</p>
          <p>参加費
            <span class="event-card--right--fee">{{ event.fee }}</span>
          </p>
        </div>
      </router-link>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    eventsProp: {}
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
  &--right {
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
}
</style>