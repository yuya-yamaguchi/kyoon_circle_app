<template>
  <div>
    <Loading v-if="loading"/>
    <div v-else>
      <StayroomReserveModal
        v-if="selectStayroomReserve.checkin_date"
        :selectStayroomReserveProp="selectStayroomReserve"
        :stayroomsProp="stayroomsProp"
        @reserve-complete="getStayRoomReserves()"
        @close-modal="closeModal()"/>
      <StayroomReserveShowModal
        v-if="selectStayroomReserveShow.id"
        :stayroom-reserve-prop="selectStayroomReserveShow"
        @update-stayroom-reserves="getStayRoomReserves()"
        @close-modal="closeModal()"/>
      <div>宿泊部屋を選択</div>
      <select v-model="selectStayRoomId" class="">
        <option value="0">指定しない</option>
        <option v-for="stayroom in stayroomsProp" :value="stayroom.id" :key="stayroom">
          {{ stayroom.name }}
        </option>
      </select>
      <div class="month-bar space-between">
        <div class="prev-month some-updown-center" @click="changeMonth(Number($route.query.month)-1)">
          <fa icon="chevron-left" class="small-icon"></fa>
          <p>前の月</p>
        </div>
        <div class="current-month" @click="changeMonth(0)">
          <p>現在の月へ</p>
        </div>
        <div class="next-month some-updown-center" @click="changeMonth(Number($route.query.month)+1)">
          <p>次の月</p>
          <fa icon="chevron-right" class="small-icon"></fa>
        </div>
      </div>
      <table class="calendar-table">
        <tr class="calendar-table--year-month">
          <td colspan="7">{{ currentDate.get('year') }}年{{ currentDate.get('month')+1 }}月</td>
        </tr>
        <tr class="calendar-table--head">
          <th v-for="week in weeks" :key="week" :class="{ 'saturday': week=='土', 'sunday': week=='日' }">
            {{ week }}
          </th>
        </tr>
        <tr v-for="(week, index) in calendars" :key="index" class="calendar-table--body">
          <td v-for="(day, index) in week" :key="index"
            class="calendar-date"
            :class="{ 'other-month': (currentDate.get('month')+1) != day.month, 'today': isToday(day) }">
            <div :class="{'saturday': index==6, 'sunday': index==0}">{{ day.date }}</div>
            <div v-if="isAdminPage">
              <div v-for="reserve in reserveUsers(day)" :key="reserve" class="reserve-user">
                <p @click="displayReserveShowModal(reserve)">{{ reserve.user_name }}</p>
              </div>
            </div>
            <div v-else>
              <span v-if="canReserve(day)" @click="displayReserveModal(day)" class="reserve-btn">予約する</span>
              <span v-else>×</span>
            </div>
          </td>
        </tr>
      </table>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import StayroomReserveModal from '@/components/organisms/stayroom/StayroomReserveModal.vue';
import StayroomReserveShowModal from '@/components/organisms/stayroom/StayroomReserveShowModal.vue';
import Loading from '@/components/organisms/common/Loading.vue';
import { commonMethods } from '@/mixins/commonMethods';
import { calendar } from '@/mixins/calendar';
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [commonMethods, calendar, errorMethods],
  props: {
    stayroomsProp: {}
  },
  components: {
    StayroomReserveModal,
    StayroomReserveShowModal,
    Loading
  },
  data() {
    return {
      stayroomReserves: [],
      selectStayRoomId: 0,
      selectStayroomReserve: {},
      selectStayroomReserveShow: {},
      loading: true
    }
  },
  watch: {
    '$route' (to) {
      if ( to.query.month !== undefined ) {
        this.getCalendar(to.query.month);
        this.getStayRoomReserves();
      }
    }
  },
  computed: {
    isAdminPage() {
      return (location.pathname.match(/admin/)) ? true : false
    }
  },
  methods: {
    getStayRoomReserves: function() {
      axios.get(
        `http://${g.hostName}/api/stayrooms/id/reserves`,
        {
          params: {
            calendar_start: fmtApiDate(this.getStartDate()),
            calendar_end:   fmtApiDate(this.getEndDate())
          }
        }
      )
      .then((response) => {
        this.stayrooms = response.data.stayrooms
        this.stayroomReserves = response.data.stayroom_reserves
      })
      .catch((error) => {
        this.apiErrors(error.response);
      })
      .finally(() => {
        this.loading = false;
      });
    },
    canReserve(date) {
      let reserveCnt = 0
      // 部屋を指定しない場合
      if (this.selectStayRoomId == 0) {
        this.stayroomReserves.some(( v ) => {
          if (v.date == fmtApiDate2(date)) {
            reserveCnt++;
          }
        })
        // 予約数が部屋数未満の場合
        if (reserveCnt < this.stayroomsProp.length) {
          return true
        }
        else {
          return false
        }
      }
      // 部屋を指定する場合
      else {
        this.stayroomReserves.some(( v ) => {
          if (v.date == fmtApiDate2(date) && v.stayroom_id == this.selectStayRoomId) {
            reserveCnt++;
          }
        })
        // 予約がない場合
        if (reserveCnt == 0) {
          return true
        }
        else {
          return false
        }
      }
    },
    reserveUsers(date) {
      let reserves = [];
      if (this.selectStayRoomId == 0) {
        this.stayroomReserves.some(( v ) => {
          if (v.date == fmtApiDate2(date)) {
            reserves.push(v)
          }
        })
      }
      else {
        this.stayroomReserves.some(( v ) => {
          if (v.date == fmtApiDate2(date) && v.stayroom_id == this.selectStayRoomId) {
            reserves.push(v)
          }
        })
      }
      return reserves
    },
    displayReserveModal(date) {
      this.selectStayroomReserve.checkin_date = fmtApiDate2(date)
      this.selectStayroomReserve.checkout_date = this.afterDays(fmtApiDate2(date), 1)
      this.selectStayroomReserve.stayroom_id = this.selectStayRoomId
    },
    displayReserveShowModal(reserve) {
      this.selectStayroomReserveShow = reserve;
    },
    changeMonth(month) {
      let componentName = (location.pathname.match(/admin/)) ? "StayroomReserves" : "StayroomIndex"
      this.$router.push({
        name: componentName,
        query: {
          month: month
        }
      })
    },
    closeModal: function() {
      this.selectStayroomReserve = {}
      this.selectStayroomReserveShow = {}
    }
  },
  mounted(){
    this.getCalendar(this.$route.query.month);
    this.getStayRoomReserves();
  }
}

function fmtApiDate(value) {
  return String(value.get("year")) + '-' + 
         ('00' + (value.get("month")+1)).slice( -2 ) + '-' + 
         ('00' + (value.get("date"))).slice( -2 )
}
function fmtApiDate2(value) {
  return String(value.year) + '-' + 
         ('00' + value.month).slice( -2 ) + '-' + 
         ('00' + value.date).slice( -2 )
}
</script>

<style scoped lang="scss">
.month-bar {
  .prev-month {
    cursor: pointer;
    p {
      margin-left: 5px;
      font-weight: bold;
    }
    &:hover {
      opacity: 0.7;
    }
  }
  .next-month {
    cursor: pointer;
    p {
      margin-right: 5px;
      font-weight: bold;
    }
    &:hover {
      opacity: 0.7;
    }
  }
  .current-month {
    cursor: pointer;
    p {
      font-weight: bold;
    }
    &:hover {
      opacity: 0.7;
    }
  }
}

.calendar-table {
  margin: 5px auto;
  background: #FFF;
  width: 100%;
  &--year-month {
    text-align: center;
    border: 1px solid #333;
    background: #333;
    color: #FFF;
    font-weight: bold;
  }
  &--head {
    th {
      border: 1px solid #333;
      text-align: center;
      font-weight: bold;
    }
  }
  &--body {
    td {
      width: 100px;
      height: 60px;
      border: 1px solid;
      vertical-align: top;
      .reserve-btn {
        font-size: 12px;
        font-weight: bold;
        text-decoration: underline;
        cursor: pointer;
        &:hover {
          color: var(--accent-color);
        }
      }
      .reserve-user {
        font-size: 12px;
        cursor: pointer;
      }
    }
    .other-month {
      background: lightgray;
    }
    .today {
      border: 2px solid orange;
      background: rgb(240, 217, 174);
      box-sizing: border-box;
    }
  }
  .saturday {
    color: var(--saturday-color);
  }
  .sunday {
    color: var(--sunday-color);
  }
}

</style>