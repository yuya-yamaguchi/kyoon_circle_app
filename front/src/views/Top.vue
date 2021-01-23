<template>
  <div class="top-page">
    <transition name="fade-slow" appear>
      <div class="top-image-container">
        <img src="/studio/studio7.jpg">
        <h1 class="top-page-title">Kyo-ON</h1>
      </div>
    </transition>
    <div class="top-container">
      <div class="about-news">
        <p class="top-each-title">NEWS</p>
        <Loading v-if="loading"/>
        <NewsList v-if="news.length!=0" :news-prop="news"/>
        <router-link to="/news?page=1" class="all-view-link">すべてのお知らせを見る</router-link>
      </div>
      <div class="about-studio">
        <img src="/studio/studio1.jpg"/>
        <div class="studio-info">
          <div>
            <h3 class="studio-info--title top-each-title">STUDIO</h3>
            <div class="studio-info--explain">
              <p>広さ30畳の音楽スタジオ</p>
              <p>ライブやバンド練習にご利用できます</p>
              <p>ご予約は下記から</p>
            </div>
            <router-link to="/studios/1?week=0" class="studio-info--link gorgeous-button">
              <p>予約はこちら</p>
              <fa icon="play-circle"></fa>
            </router-link>
          </div>
        </div>
      </div>
      <div class="about-event">
        <h3 class="top-each-title">EVENT</h3>
        <div class="about-event--content">
          <Loading v-if="loading"/>
          <EventList v-if="events.length!=0" :events-prop="events"/>
          <router-link :to="{name: 'EventIndex', query: {page: 1}}" class="all-view-link">すべてのイベントを見る</router-link>
        </div>
      </div>
      <div class="about-stay">
        <img src="/studio/studio5.jpg"/>
        <div class="stay-info">
          <div>
            <h3 class="stay-info--title top-each-title">STAY</h3>
            <div class="stay-info--explain">
              <p>宿泊可能なお部屋をご用意しております</p>
              <p>遠方からお越しの際などにご利用ください</p>
              <p>※準備中、しばらくお待ちください</p>
            </div>
            <button class="stay-info--btn default-button">Comming<br>Soon...</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import NewsList from '@/components/NewsList.vue';
import EventList from '@/components/EventList.vue';
import Loading from '@/components/Loading.vue';
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [errorMethods],
  components: {
    NewsList,
    EventList,
    Loading
  },
  data() {
    return {
      news: [],
      events: [],
      loading: true
    }
  },
  methods: {
    getTop: function(){
      axios.get(`http://${g.hostName}/api/top`)
      .then((response) => {
        this.events = response.data.events;
        this.news = response.data.news;
        this.loading = false;
      })
      .catch((error) => {
        this.loading = false;
        this.apiErrors(error.response.status);
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
    opacity: 0.8;
  }
}

.top-container {
  margin-bottom: 100px;
  max-width: 1400px;
  margin: 0 auto;
  .about-news {
    padding: 100px 0px;
    background: #FFF;
  }
  .about-studio {
    position: relative;
    img {
      width: 100%;
      vertical-align: bottom;
      filter: blur(6px);
    }
    .studio-info {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background-color: rgba(0, 0, 0, 0.8);
      color: #FFF;
      display: flex;
      align-items: center;
      justify-content: center;
      &--explain {
        margin-top: 30px;
        margin-bottom: 60px;
        text-align: center;
        p {
          margin: 15px;
          font-weight: lighter;
        }
      }
      &--link {
        display: flex;
        align-items: center;
        justify-content: center;
        white-space: nowrap;
        text-align: center;
        width: 150px;
        svg {
          width: 20px;
          margin-left: 10px;
        }
      }
    }
  }
  .about-event {
    padding: 100px 20px;
  }
  .about-stay {
    position: relative;
    img {
      width: 100%;
      vertical-align: bottom;
      filter: blur(3px);
    }
    .stay-info {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background-color: rgba(160, 156, 156, 0.8);
      color: #FFF;
      display: flex;
      align-items: center;
      justify-content: center;
      &--explain {
        margin-top: 30px;
        margin-bottom: 60px;
        text-align: center;
        p {
          margin: 15px;
          font-weight: lighter;
        }
      }
      &--btn {
        white-space: nowrap;
        background: #888;
        cursor: not-allowed;
      }
    }
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
}

</style>