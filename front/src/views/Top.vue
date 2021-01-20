<template>
  <div class="top-page">
    <transition name="fade-slow" appear>
      <div class="top-image-container">
        <img src="/studio/studio7.jpg">
        <h1 class="top-page-title">Kyo-ON</h1>
      </div>
    </transition>
    <div class="single-container">
      <div class="top-container">
        <div class="about-news">
          <p class="main-title">お知らせ</p>
          <NewsList v-if="news.length!=0" :news-prop="news"/>
          <router-link to="/news?page=1" class="all-view-link">すべてのお知らせを見る</router-link>
        </div>
        <div class="about-event">
          <p class="main-title">開催予定のイベント</p>
          <div class="about-event--content">
            <Loading v-if="loading"/>
            <EventList v-if="events.length!=0" :events-prop="events"/>
            <router-link :to="{name: 'EventIndex', query: {page: 1}}" class="all-view-link">すべてのイベントを見る</router-link>
          </div>
        </div>
        <div class="about-studio">
          <p class="main-title">スタジオ</p>
          <div class="about-studio--content">
            <div class="about-studio--content--left">
              <img src="/studio/studio3.jpg"/>
            </div>
            <div class="about-studio--content--right">
              <p class="about-studio--content--right--explain">
                会員が利用可能なスタジオです！<br>
                広さ30畳でライブもできる広々スタジオです。<br>
                バンド練習やライブなどにご利用ください！
              </p>
              <router-link to="/studios/1?week=0" class="about-studio--content--right--btn default-button">
                <p>予約はこちら</p>
                <fa icon="play-circle"></fa>
              </router-link>
            </div>
          </div>
        </div>
        <div class="about-stay">
          <p class="main-title">宿泊</p>
          <div class="about-stay--content">
            <div class="about-stay--content--left">
              <p class="about-stay--content--left--explain">
                会員が利用可能な宿泊部屋です！<br>
                2部屋利用可能です。<br>
                遠方からお越しの方など、下記よりご予約の上ご利用ください！<br>
                ※準備中、しばらくお待ちください
              </p>
              <button class="about-stay--content--left--btn default-button">Comming<br>Soon...</button>
            </div>
            <div class="about-stay--content--right">
              <img src="/studio/studio5.jpg">
            </div>
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
  margin: 0 10px;
  .about-news {
    padding: 50px 20px;
  }
  .about-event {
    padding: 50px 20px;
  }
  .about-studio {
    padding: 50px 20px;
    &--content {
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
        &--explain {
          font-size: 18px;
          line-height: 30px;
        }
        &--btn {
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
  }
  .about-stay {
    padding: 50px 20px;
    &--content {
      display: flex;
      justify-content: space-between;
      margin-top: 20px;
      &--left {
        width: 40%;
        margin-right: 20px;
        &--explain {
          font-size: 18px;
          line-height: 30px;
        }
        &--btn {
          white-space: nowrap;
          background: #888;
          cursor: not-allowed;
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
  .all-view-link {
    display: block;
    text-decoration: none;
    margin: 0 auto;
    text-align: center;
    color: #333;
    font-size: 20px;
    font-weight: bold;
  }
}

</style>