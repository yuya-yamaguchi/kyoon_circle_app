<template>
  <div>
    <div v-for="(event, i) in events" :key="i" class="event-card">
      <router-link :to="`/event/${event.id}`">
        <p class="event-card--title">{{ event.title }}</p>
        <div class="event-card--middle">
          <span v-if="event.event_type=='1'" class="event-card--middle--type">セッション</span>
          <span v-else-if="event.event_type=='2'" class="event-card--middle--type">飲み会・懇親会</span>
          <span v-else-if="event.event_type=='3'" class="event-card--middle--type">合宿</span>
          <span v-else-if="event.event_type=='4'" class="event-card--middle--type">その他</span>
          <span>参加費</span><span class="event-card--middle--fee">{{ event.fee }}</span>
        </div>
        <p class="event-card--hold-datetime">開催日時：{{ event.start_datetime }} 〜 {{ event.end_datetime }}</p>
      </router-link>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    eventsProp: []
  },
  data() {
    return {
      events: this.eventsProp
    }
  }
}
</script>

<style scoped lang="scss">
.event-card {
  box-shadow: 10px 10px 10px rgba(70, 70, 70, 0.2);
  margin: 40px 0;
  padding: 10px;
  color: #333;
  a {
    text-decoration: none;
    color: #333;
    display: block;
  }
  &--title {
    font-size: 24px;
  }
  &--middle {
    line-height: 20px;
    margin: 5px 0;
    &--type {
      background: rgb(71, 71, 241);
      color: #FFF;
      font-size: 10px;
      font-weight: bold;
      border-radius: 5px;
      margin: 5px;
      padding: 2px 10px;
    }
    &--fee {
      font-weight: bold;
      margin-left: 10px;
    }
  }
  &--hold-datetime {
    margin: 5px;
  }
}
</style>