<template>
  <div class="top-page">
    <div class="top-image-container">
      <img src="@/assets/pictures/studio7.jpg">
      <h1 class="top-page-title">Kyo-ON</h1>
    </div>
    <div class="single-container">
      <div class="top-container">
        <p class="main-title">イベント一覧</p>
        <div v-for="(event, i) in events" :key="i" class="event-card">
          <router-link :to="`/event/${event.id}`">
            <p>{{ event.title }}</p>
            <p>{{ event.details }}</p>
            <p>開催日時：{{ event.start_datetime }} 〜 {{ event.end_datetime }}</p>
            <p>開催場所：{{ event.place }}</p>
            <p>料金：{{ event.fee }}</p>
          </router-link>
        </div>
      </div>
      <div class="top-container">
        <p class="main-title">スタジオ</p>
        <div class="about-studio">
          <div class="about-studio--left">
            <img src="@/assets/pictures/studio3.jpg">
          </div>
          <div class="about-studio--right">
            <p class="about-studio--right--explain">
              会員が利用可能なスタジオです！<br>
              広さ30畳でライブもできる広々スタジオです。<br>
              バンド練習やライブなどにご利用ください！
            </p>
            <router-link to="/studios/1" class="about-studio--right--btn default-button">スタジオ予約</router-link>
          </div>
        </div>
      </div>
      <div class="top-container">
        <p class="main-title">宿泊</p>
        <div class="about-stay">
          <div class="about-stay--left">
            <p class="about-stay--left--explain">
              会員が利用可能な宿泊部屋です！<br>
              2部屋利用可能です。<br>
              遠方からお越しの方など、下記よりご予約の上ご利用ください！
            </p>
            <button class="about-stay--left--btn default-button">宿泊予約</button>
          </div>
          <div class="about-stay--right">
            <img src="@/assets/pictures/studio5.jpg">
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

const hostName = 'localhost:3000';

export default {
  data() {
    return {
      events: []
    }
  },
  methods: {
    getTop: function(){
      axios.get(`http://${hostName}/api/top`)
      .then((response) => {
        this.events = response.data;
      })
      .catch(function(error) {
        console.log(error);
      });
    }
  },
  mounted: function() {
    this.getTop();
  }
}
</script>

<style scoped lang="scss">
.top-image-container {
  position: relative;
  img {
    width: 100%;
    opacity: 0.6;
    vertical-align: bottom;
    filter: drop-shadow(2px 2px 2px rgba(0,0,0,0.6));
  }
  .top-page-title {
    font-size: 50px;
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%,-50%);
  }
}

.top-container {
  margin: auto;
  margin-bottom: 200px;
  width: 95%;
  .event-card {
    border: 1px solid;
    border-radius: 5px;
    margin: 10px;
  }
  .about-studio {
    display: flex;
    justify-content: space-between;
    margin-top: 20px;
    &--left {
      width: 60%;
      img{
        width: 100%;
        filter: drop-shadow(2px 2px 2px rgba(0,0,0,0.6));
        vertical-align: bottom;
      }
    }
    &--right {
      width: 40%;
      margin-left: 20px;
      position: relative;
      &--explain {
        font-size: 18px;
        line-height: 30px;
      }
      &--btn {
        position: absolute;
        bottom: 0;
        left: 50%;
        transform: translate(-50%,0);
      }
    }
  }
  .about-stay {
    display: flex;
    justify-content: space-between;
    margin-top: 20px;
    &--left {
      width: 40%;
      margin-right: 20px;
      position: relative;
      &--explain {
        font-size: 18px;
        line-height: 30px;
      }
      &--btn {
        position: absolute;
        bottom: 0;
        left: 50%;
        transform: translate(-50%,0);
      }
    }
    &--right {
      width: 60%;
      img {
        width: 100%;
        filter: drop-shadow(2px 2px 2px rgba(0,0,0,0.6));
        vertical-align: bottom;
      }
    }
  }
}
</style>