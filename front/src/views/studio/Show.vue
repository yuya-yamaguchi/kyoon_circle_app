<template>
  <div class="single-container">
    <ReserveModal v-if="clickReserve!=''"
      :click-reserve-prop="clickReserve"
      :studio-prop="studio"
      @from-child="closeModal()"
      @reserve-success="getStudioStatus()"/>
    <div class="studio-introduction">
      <div class="studio-introduction--left">
        <p>{{ studio.name }}</p>
        <img src="@/assets/pictures/studio7.jpg">
      </div>
      <div class="studio-introduction--right">
        <div studio-introduction--right--explain>
          24時間利用可能なスタジオです。30分からご予約いただけます。
          バンド練習、個人練習などににご利用ください。
        </div>
        <table>
          <tr>
            <th>料金</th>
            <td>
              ¥{{ studio.fee }}（1 Hour）<br>
              （30分単位で予約可）
            </td>
          </tr>
          <tr>
            <th>機材</th>
            <td>
              <ul>
                <li>Marshall JCM2000</li>
                <li>Roland JC-120</li>
                <li>HARTKE HA2500+HX810</li>
                <li>CANOPUS Japanese Sword</li>
              </ul>
            </td>
          </tr>
        </table>
      </div>
    </div>
    <div class="studio-reserve-container">
      <table>
        <tr>
          <th></th>
          <th v-for="(week, w) in weeks" :key="w">
            {{ formatDate(week, 'MM月DD日') }}
            （{{ setWeek(week) }}）
          </th>
        </tr>
        <tr v-for="(reserve, i) in reserves" :key="i">
          <td class="reserve-time">
            <span>{{ Math.floor(i/2) }}：</span>
            <span v-if="i%2==0">00</span>
            <span v-else>30</span>
          </td>
          <template v-for="(r, j) in reserve" :key="j">
            <td v-if="r.reserved_flg" class="already-reserved">×</td>
            <td v-else @click="displayReserveModal(r)"  class="can-reserve"></td>
          </template>
        </tr>
      </table>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import moment from "moment";
import g from "@/variable/variable.js";
import ReserveModal from '@/components/ReserveModal.vue';

const WEEK = ['日', '月', '火', '水', '木', '金', '土'];

export default {
  components: {
    ReserveModal
  },
  data() {
    return {
      studio: "",
      reserves: [],
      weeks: [],
      // Modal関連
      clickReserve: ""
    }
  },
  methods: {
    getStudioStatus: function(){
      axios.get(
        `http://${g.hostName}/api/studios/${this.$route.params.id}`
      )
      .then((response) => {
        this.studio = response.data.studio;
        this.reserves = response.data.reserves;
        this.weeks = response.data.weeks;
      })
      .catch((error) => {
        console.log(error);
      });
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
    },
    formatDate(value, format) {
      return moment(value).format(format);
    },
    setWeek(date) {
      var show_date = new Date(date.substr(0, 4), date.substr(5, 2)-1, date.substr(8, 2));
      return WEEK[show_date.getDay()];
    }
  },
  mounted: function() {
    this.getStudioStatus();
  }
}
</script>

<style scoped lang="scss">
.studio-introduction {
  display: flex;
  justify-content: space-between;
  &--left {
    width: 60%;
    position: relative;
    p {
      position: absolute;
      bottom: 10px;
      right: 20px;
      font-size: 40px;
      font-weight: bold;
    }
    img {
      width: 100%;
      opacity: 0.6;
    }
  }
  &--right {
    width: 40%;
    margin-left: 10px;
    table {
      margin-top: 20px;
      border: 1px solid #333;
      th {
        border-bottom: 1px solid #FFF;
        padding: 10px;
        background: #333;
        color: #FFF;
      }
      td {
        border: 1px solid;
        padding: 10px;
        font-size: 16px;
        line-height: 24px;
      }
    }
  }
}

.studio-reserve-container{
  margin: 50px;
  table {
    border: 1px solid;
    margin: 0 auto;
  }

  th {
    border-bottom: 1px solid;
    text-align: center;
    width: 100px;
    background: #333;
    color: #FFF;
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
  }

  .can-reserve {
    border: 1px dotted #333;
    width: 40px;
    height: 20px;
    background: #FFF;
    cursor: pointer;
    &:hover{
      background: rgb(90, 197, 224);
    }
  }

  .already-reserved {
    background: lightgray;
    color: #888;
    text-align: center;
    border: 1px dotted;
  }
}
</style>