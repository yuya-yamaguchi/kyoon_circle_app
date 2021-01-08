<template>
  <div>
    <form v-on:submit.prevent="postEvent()">
      <div class="form-item">
        <p>イベントの種類</p>
        <select v-model="event.event_type">
          <option disabled value="">イベントの種類を選択して下さい</option>
          <option v-for="option in options" :value="option.event_type" :key="option.id">
            {{ option.name }}
          </option>
        </select>
      </div>
      <div class="form-item">
        <p>イベント名</p>
        <input type="text" v-model="event.title" placeholder="イベント名" class="default-input">
      </div>
      <div class="form-item">
        <p>イベント内容</p>
        <textarea v-model="event.details"></textarea>
      </div>
      <div class="form-item">
        <p>開催日時</p>
        <input type="date" v-model="event.start_date">
        <input type="text" v-model="event.start_hour" class="event-time">時
        <input type="text" v-model="event.start_min" class="event-time">分 〜
        <input type="text" v-model="event.end_hour" class="event-time">時
        <input type="text" v-model="event.end_min" class="event-time">分
      </div>
      <div class="form-item">
        <p>場所</p>
        <input type="text" v-model="event.place" class="default-input">
      </div>
      <div class="form-item">
        <p>参加費</p>
        <input type="text" v-model="event.fee" class="default-input">
      </div>
      <div class="form-item">
        <p>参加可能人数</p>
        <input type="number" v-model="event.max_entry">
      </div>
      <div class="form-item" v-if="displayLinePush()">
        <p>グループLINEへの通知</p>
        <input type="checkbox" id="lineMsgFlg" class="checkbox" v-model="event.line_msg_push">
        <label for="lineMsgFlg">通知する</label>
      </div>
      <button class="default-button">登録</button>
    </form>
  </div>
</template>

<script>
export default {
  props: {
    eventProp: {}
  },
  data() {
    return {
      event: this.eventProp,
      options: [
        { event_type: 1, name: 'セッション' },
        { event_type: 2, name: '飲み会・懇親会' },
        { event_type: 3, name: '合宿' },
        { event_type: 4, name: 'その他' }
      ]
    }
  },
  methods: {
    postEvent: function() {
      this.$emit('post-event', this.event);
    },
    displayLinePush: function() {
      if (location.pathname == '/event/new') {
        return true
      }
      return false
    }
  }
}
</script>

<style scoped lang="scss">
.event-time {
  width: 50px;
}
</style>