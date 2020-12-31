<template>
  <div class="single-container">
    <h1 class="main-title">{{ event.title }}</h1>
    <p v-show="entryFlg" class="entry-now-msg">このイベントに参加中です</p>
    <div class="event-top-info">
      <div class="number-info">
        <p class="number-info--title">参加費</p>
        <p class="number-info--value">{{ event.fee }}</p>
      </div>
      <div class="number-info">
        <p class="number-info--title">参加人数</p>
        <p class="number-info--value">0人 / {{ event.max_entry }}人</p>
      </div>
    </div>
    <div class="event-middle-info">開催日時 {{ event.start_datetime }}〜{{ event.end_datetime }}</div>
    <div class="event-middle-info">開催場所 {{ event.place }}</div>
    <div class="event-details">{{ event.details }}</div>
    <button v-if="!entryFlg"
            @click="postEventEntry()"
            class="default-button"
            :disabled="entryFlg">参加する
    </button>
    <button v-if="entryFlg"
            @click="cancelEventEntry()"
            class="cancel-button"
            :disabled="entryFlg">参加をやめる
    </button>
  </div>
</template>

<script>
import axios from 'axios';

const hostName = 'localhost:3000';

export default {
  data() {
    return {
      event: "",
      entryFlg: false
    }
  },
  methods: {
    getEvent: function() {
      axios.get(
        `http://${hostName}/api/events/${this.$route.params.id}`,
        {
          params:{
            user_id: this.$store.getters['user/id']
          }
        }
      )
      .then((response) => {
        this.event = response.data.event;
        this.entryFlg = response.data.entry_flg;
      })
      .catch(function(error) {
        console.log(error);
      });
    },
    postEventEntry: function() {
      axios.post(
        `http://${hostName}/api/events/${this.$route.params.id}/entry`,
        {
          user_id: this.$store.getters['user/id']
        }
      )
      .then(() => {
        this.entryFlg = true;
      })
      .catch(function(error) {
        console.log(error);
      });
    }
  },
  mounted: function() {
    this.getEvent();
  }
}
</script>

<style scoped lang="scss">
.entry-now-msg {
  color: red;
  font-weight: bold;
  margin: 10px;
}
.event-top-info {
  margin: 20px 0;
  display: flex;
  justify-content: flex-start;
  .number-info {
    background: rgb(222, 222, 245);
    border-radius: 10px;
    width: 120px;
    padding: 10px;
    text-align: center;
    margin-right: 20px;
    &--value {
      color: #13b1c0;
      font-size: 1.2rem;
      font-weight: bold;
    }
  }
}
.event-details {
  background: rgb(245, 242, 222);
  margin: 20px auto;
  padding: 10px;
}
</style>