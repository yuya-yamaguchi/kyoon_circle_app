<template>
  <div>
    <Loading v-if="loading"/>
    <div v-else class="studio-reserve-container">
      <transition name="fade-default" appear>
        <ReserveModal v-if="clickReserve!=''"
          :click-reserve-prop="clickReserve"
          :studio-prop="studio"
          @close-modal="closeModal()"
          @reserve-success="getStudioReserves($route.query.week)"/>
      </transition>
      <transition name="fade-default" appear>
        <StudioReserveShowModal v-if="selectReserve!=''"
          :studio-reserve-prop="selectReserve"
          @update-studio-reserves="getStudioReserves($route.query.week)"
          @close-modal="closeModal()"/>
      </transition>
      <div class="week-bar">
        <div class="prev-week some-updown-center" @click="changeWeek(Number($route.query.week) - 1)">
          <fa icon="chevron-left" class="small-icon"></fa>
          <p>前の1週間</p>
        </div>
        <div class="today-week" @click="changeWeek(0)">本日週へ</div>
        <div class="next-week some-updown-center" @click="changeWeek(Number($route.query.week) + 1)">
          <p>次の1週間</p>
          <fa icon="chevron-right" class="small-icon"></fa>
        </div>
      </div>
      <div class="studio-reserves-table-container">
        <table class="reserves-table">
          <tr class="reserves-table--header">
            <th class="reserve-times-head"></th>
            <th v-for="(day, w) in weeks" :key="w"
              :class="{'saturday': calcWeek(day, 1)=='土',
                      'sunday':   calcWeek(day, 1)=='日'}">
              {{ formatDate(day, 'M/D') }}<br>
              （{{ calcWeek(day, 1) }}）
            </th>
          </tr>
          <tr v-for="(reserve, i) in reserves" :key="i" class="reserves-table--content">
            <td class="reserve-time">
              <span>{{ Math.floor(i/2) }} : </span>
              <span v-if="i%2==0">00</span>
              <span v-else>30</span>
            </td>
            <template v-for="(r, j) in reserve" :key="j">
              <template v-if="adminProp==0">
                <td v-if="r.reserve_type==1"  class="already-reserved">×</td>
                <td v-else-if="r.reserve_type==2" class="can-not-reserve">-</td>
                <td v-else @click="displayReserveModal(r)"  class="can-reserve">{{formatDate(r.date, 'M/D')}} {{r.hour}}:{{ zeroPadding(r.minutes, 2) }}</td>
              </template>
              <template v-if="adminProp==1">
                <td v-if="r.reserve_type==1" class="reserved-user"
                  @click="showReserve(r)"
                  :class="{'hide-name': i!=0 && (reserves[i-1][j].studio_reserve_id==r.studio_reserve_id)}">
                  {{ r.username }}
                </td>
                <td v-else-if="r.reserve_type==2" class="can-not-reserve">-</td>
                <td v-else class="no-reserves-admin"></td>
              </template>
            </template>
          </tr>
        </table>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import ReserveModal from '@/components/organisms/studio/ReserveModal.vue';
import StudioReserveShowModal from '@/components/organisms/studio/StudioReserveShowModal.vue';
import Loading from '@/components/organisms/common/Loading.vue';
import { commonMethods } from '@/mixins/commonMethods';
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [commonMethods, errorMethods],
  props: {
    adminProp: {}
  },
  components: {
    ReserveModal,
    StudioReserveShowModal,
    Loading
  },
  data() {
    return {
      studio: "",
      reserves: [],
      weeks: [],
      // Modal関連
      clickReserve: "",
      loading: true,
      selectReserve: ""
    }
  },
  watch: {
    '$route' (to) {
      if ( to.query.week !== undefined ) {
        this.getStudioReserves(to.query.week)
      }
    }
  },
  methods: {
    getStudioReserves: function(week) {
      var firstHalfUrl = (location.pathname.match(/admin/)) ? "api/admin/studios" : "api/studios"
      axios.get(
        `http://${g.hostName}/${firstHalfUrl}/${this.$route.params.id}/reserves?week=${week}`,
        {
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then((response) => {
        this.studio = response.data.studio;
        this.reserves = response.data.reserves;
        this.weeks = response.data.weeks;
        this.loading = false;
      })
      .catch((error) => {
        this.apiErrors(error.response);
      });
    },
    changeWeek: function(week) {
      var componentName = (location.pathname.match(/admin/)) ? "StudioReserves" : "StudioShow"
      this.$router.push({
        name: componentName,
        query: {
          week: week
        }
      })
    },
    // スタジオ予約のモーダルを表示する
    displayReserveModal: function(reserve) {
      reserve["end_hour"] = reserve.hour + 1;
      if (reserve.hour == 23 && reserve.minutes == 30) {
        reserve["end_minutes"] = 0;
      }
      else {
        reserve["end_minutes"] = reserve.minutes
      }
      this.clickReserve = reserve;
    },
    closeModal: function() {
      this.clickReserve = ''
      this.selectReserve = ''
    },
    showReserve: function(reserve) {
      this.selectReserve = reserve
    }
  },
  mounted: function() {
    this.getStudioReserves(this.$route.query.week);
  }
}
</script>

<style scoped lang="scss">
.studio-reserve-container{
  max-width: 800px;
  margin: 0 auto;
  .week-bar {
    display: flex;
    justify-content: space-between;
    margin: 10px 0;
    .prev-week {
      font-weight: bold;
      cursor: pointer;
      p {
        margin-left: 10px;
      }
    }
    .today-week {
      font-weight: bold;
      cursor: pointer;
    }
    .next-week {
      font-weight: bold;
      cursor: pointer;
      p {
        margin-right: 10px;
      }
    }
  }
  .studio-reserves-table-container {
    max-height: calc(100vh - 300px);
    overflow: scroll;
    .reserves-table {
      width: 100%;
      height: 100%;
      border: 1px solid #333;
      margin: 0 auto;
      table-layout: fixed;
      &--header {
        th {
          border-bottom: 1px dotted;
          border-right: 1px dotted #FFF;
          text-align: center;
          background: #333;
          color: #FFF;
          font-weight: bold;
          position: sticky;
          top: 0;
          z-index: 1;
          &:before{
            content: "";
            position: absolute;
            top: -1px;
            left: -1px;
            width: 100%;
            height: 100%;
            border: 1px solid #FFF;
          }
        }
        .reserve-times-head {
          width: 60px;
        }
        .saturday {
          background: var(--saturday-color);
        }
        .sunday {
          background: var(--sunday-color);
        }
      }
      &--content {
        border: 1px dotted;
        background: #333;
        color: #FFF;
        .can-reserve {
          border: 1px dotted #333;
          height: 20px;
          background: #FFF;
          font-size: 12px;
          text-align: center;
          cursor: pointer;
          &:hover{
            background: rgb(231, 231, 231);
            color: #888;
            transition: .3s;
          }
        }
        .can-not-reserve {
          background: lightgray;
          color: #888;
          text-align: center;
          border: 1px dotted;
        }
        .already-reserved {
          background: lightgray;
          color: #888;
          text-align: center;
          border: 1px dotted;
        }
        .reserved-user {
          border: 1px dotted #333;
          background: #FFF;
          color: #333;
          font-size: 12px;
          text-align: center;
          cursor: pointer;
          &:hover {
            color: var(--accent-color);
          }
        }
        .no-reserves {
          border: 1px dotted #333;
          height: 20px;
          background: #FFF;
        }
        .no-reserves-admin {
          border: 1px dotted #333;
          height: 20px;
          background: lightgray;
        }
        .hide-name {
          font-size: 0px;
          color: #FFF;
          border-top: 1px solid #FFF;
        }
      }
      .reserve-time {
        width: 100px;
        height: 20px;
        text-align: right;
        padding-right: 5px;
        white-space: nowrap
      }
    }
  }
}
</style>