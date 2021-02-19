<template>
  <div>
    <StayroomReserveModal
      v-if="selectStayroomReserve.start_date"
      :selectStayroomReserveProp="selectStayroomReserve"
      :stayroomsProp="stayroomsProp"
      @reserve-complete="getStayRoomReserves()"
      @close-modal="closeModal()"/>
    <div>部屋</div>
    <select v-model="selectStayRoomId" class="">
      <option value="0">指定しない</option>
      <option v-for="stayroom in stayroomsProp" :value="stayroom.id" :key="stayroom">
        {{ stayroom.name }}
      </option>
    </select>
    <div>
      <button @click="prevMonth">前の月</button>
      <button @click="nextMonth">次の月</button>
    </div>
    <table class="calendar-table">
      <tr class="calendar-table--year-month">
        <td colspan="7">{{ currentDate.get('year') }}年{{ currentDate.get('month')+1 }}月</td>
      </tr>
      <tr class="calendar-table--head">
        <th v-for="week in weeks" :key="week">
          {{ week }}
        </th>
      </tr>
      <tr v-for="(week, index) in calendars" :key="index" class="calendar-table--body">
        <td v-for="(day, index) in week" :key="index" class="calendar-date" :class="{ 'already-reserved': !canReserve(day) }">
          <div @click="postStayRoomReserves(day)">{{ day.date }}</div>
          <span v-if="canReserve(day)" @click="displayReserveModal(day)" class="reserve-btn">予約する</span>
        </td>
      </tr>
    </table>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import StayroomReserveModal from '@/components/organisms/stayroom/StayroomReserveModal.vue';
import { commonMethods } from '@/mixins/commonMethods';
import { calendar } from '@/mixins/calendar';

export default {
  mixins: [commonMethods, calendar],
  props: {
    stayroomsProp: {}
  },
  components: {
    StayroomReserveModal
  },
  data() {
    return {
      stayroomReserves: [],
      selectStayRoomId: 0,
      selectStayroomReserve: {},
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
        console.log(error)
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
    displayReserveModal(date) {
      this.selectStayroomReserve.start_date = fmtApiDate2(date)
      this.selectStayroomReserve.end_date = this.afterDays(fmtApiDate2(date), 1)
      this.selectStayroomReserve.stayroom_id = this.selectStayRoomId
    },
    closeModal: function() {
      this.selectStayroomReserve = {}
    }
  },
  mounted(){
    this.getCalendar();
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
.calendar-table {
  margin: 10px 0;
  background: #FFF;
  &--year-month {
    text-align: center;
    border: 1px solid;
  }
  &--head {
    th {
      border: 1px solid;
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
    }
    .already-reserved {
      background: lightgray;
    }
  }
}

</style>