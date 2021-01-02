<template>
  <div class="double-container">
    <div class="double-container--left">
      <SideBar/>
    </div>
    <div class="double-container--right">
      <h1 class="main-title text-center">イベント登録</h1>
      <form v-on:submit.prevent="postNewEvent()">
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
          <input type="text" v-model="event.title" placeholder="イベント名">
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
          <input type="text" v-model="event.place">
        </div>
        <div class="form-item">
          <p>参加費</p>
          <input type="text" v-model="event.fee">
        </div>
        <div class="form-item">
          <p>参加可能人数</p>
          <input type="number" v-model="event.max_entry">
        </div>
        <button class="default-button">登録</button>
    </form>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import SideBar from "@/components/SideBar.vue";

export default {
  components: {
    SideBar
  },
  data() {
    return {
      selected: "",
      options: [
        { event_type: 1, name: 'セッション' },
        { event_type: 2, name: '飲み会・懇親会' },
        { event_type: 3, name: '合宿' },
        { event_type: 4, name: 'その他' }
      ],
      event: {
        event_type: 0,
        title: "",
        details: "",
        start_date: "",
        start_hour: "",
        start_min: "",
        end_hour: "",
        end_min: "",
        place: "",
        fee: "",
        max_entry: 0
      }
    }
  },
  methods: {
    postNewEvent: function() {
      axios.post(
        `http://${g.hostName}/api/events`,
        {
          user_id: this.$store.getters['user/id'],
          event: this.event
        }
      )
      .then((response) => {
        console.log(response);
      })
      .catch(function(error) {
        console.log(error);
      });
    }
  }
}
</script>

<style scoped lang="scss">
.event-time {
  width: 50px;
}
</style>