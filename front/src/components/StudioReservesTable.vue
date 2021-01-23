<template>
  <div>
    <Loading v-if="loading"/>
    <div v-else class="studio-reserve-container">
      <transition name="fade-default" appear>
        <ReserveModal v-if="clickReserve!=''"
          :click-reserve-prop="clickReserve"
          :studio-prop="studio"
          @from-child="closeModal()"
          @reserve-success="getStudioReserves($route.query.week)"/>
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
      <table>
        <tr>
          <th></th>
          <th v-for="(day, w) in weeks" :key="w"
            :class="{'saturday': calcWeek(day, 1)=='土',
                      'sunday':  calcWeek(day, 1)=='日'}">
            {{ fmtDate(day, 3) }}<br>
            （{{ calcWeek(day, 1) }}）
          </th>
        </tr>
        <tr v-for="(reserve, i) in reserves" :key="i">
          <td class="reserve-time">
            <span>{{ Math.floor(i/2) }}：</span>
            <span v-if="i%2==0">00</span>
            <span v-else>30</span>
          </td>
          <template v-for="(r, j) in reserve" :key="j">
            <template v-if="adminProp==0">
              <td v-if="r.reserve_type==1"  class="already-reserved">×</td>
              <td v-else-if="r.reserve_type==2" class="can-not-reserve">-</td>
              <td v-else @click="displayReserveModal(r)"  class="can-reserve"></td>
            </template>
            <template v-if="adminProp==1">
              <td v-if="r.reserve_type==1" class="reserved-user"
                :class="{'hide-name': i!=0 && (reserves[i-1][j].studio_reserve_id==r.studio_reserve_id)}">{{ r.username }}</td>
              <td v-else-if="r.reserve_type==2" class="can-not-reserve">-</td>
              <td v-else class="no-reserves-admin"></td>
            </template>
          </template>
        </tr>
      </table>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import ReserveModal from '@/components/ReserveModal.vue';
import Loading from '@/components/Loading.vue';
import { commonMethods } from '@/mixins/commonMethods';
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [commonMethods, errorMethods],
  props: {
    adminProp: {}
  },
  components: {
    ReserveModal,
    Loading
  },
  data() {
    return {
      studio: "",
      reserves: [],
      weeks: [],
      // Modal関連
      clickReserve: "",
      loading: true
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
        `http://${g.hostName}/${firstHalfUrl}/${this.$route.params.id}/reserves?week=${week}`
      )
      .then((response) => {
        this.studio = response.data.studio;
        this.reserves = response.data.reserves;
        this.weeks = response.data.weeks;
        this.loading = false;
      })
      .catch((error) => {
        this.apiErrors(error.response.status);
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
    }
  },
  mounted: function() {
    this.getStudioReserves(this.$route.query.week);
  }
}
</script>

<style scoped lang="scss">
.studio-reserve-container{
  margin: 50px;
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
  table {
    width: 100%;
    border: 1px solid;
    margin: 0 auto;
  }
  th {
    border-bottom: 1px dotted;
    border-right: 1px dotted #FFF;
    text-align: center;
    width: 100px;
    background: #333;
    color: #FFF;
    font-weight: bold;
  }
  .saturday {
    background: rgb(129, 129, 236);
  }
  .sunday {
    background: rgb(235, 143, 107);
  }
  tr {
    border: 1px dotted;
    background: #333;
    color: #FFF;
  }
  .reserve-time {
    width: 45px;
    height: 20px;
    text-align: right;
    padding-right: 5px;
    white-space: nowrap
  }
  .can-reserve {
    border: 1px dotted #333;
    width: 40px;
    height: 20px;
    background: #FFF;
    cursor: pointer;
    &:hover{
      background: var(--accent-color);
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
  }
  .no-reserves {
    border: 1px dotted #333;
    width: 40px;
    height: 20px;
    background: #FFF;
  }
  .no-reserves-admin {
    border: 1px dotted #333;
    width: 40px;
    height: 20px;
    background: lightgray;
  }
  .hide-name {
    font-size: 0px;
    color: #FFF;
    border-top: 1px solid #FFF;
  }
}
</style>