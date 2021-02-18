<template>
  <div>
    <h2>カレンダー{{ currentDate.get('year') }}</h2>
    <button @click="prevMonth">前の月</button>
    <button @click="nextMonth">次の月</button>
    <div>{{selectStayRoomId}}</div>
    <select v-model="selectStayRoomId" class="">
      <option value="0">すべて</option>
      <option v-for="stayroom in stayroomsProp" :value="stayroom.id" :key="stayroom">
        {{ stayroom.name }}
      </option>
    </select>
    <table class="calendar-table">
      <tr v-for="(week, index) in calendars" :key="index" class="calendar-week">
        <td v-for="(day, index) in week" :key="index" class="calendar-date">
          <span v-if="isReserved(day)">予約する</span>
          <span @click="postStayRoomReserves(day)">{{ day.date }}</span>
        </td>
      </tr>
    </table>
    <div v-for="stayroomReserve in stayroomReserves" :key="stayroomReserve">{{stayroomReserve.date}}</div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import moment from "moment";

export default {
  props: {
    stayroomsProp: {}
  },
  data() {
    return {
      stayroomReserves: [],
      selectStayRoomId: 0,
      currentDate: moment()
    }
  },
  computed: {
    calendars() {
      return this.getCalendar();
    },
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
    postStayRoomReserves: function(date) {
      axios.post(
        `http://${g.hostName}/api/stayrooms/1/reserves`,
        {
          stayroom_reserve: {
            date: fmtApiDate2(date),
            stayroom_id: this.stayroom
          }
        },
        {
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then(() => {
        // this.stayroomReserves = response.data.stayroom_reserves
      })
      .catch((error) => {
        console.log(error)
      });
    },
    getCalendar() {
      let startDate = this.getStartDate();
      const endDate = this.getEndDate();
      const weekNumber = Math.ceil(endDate.diff(startDate, "days") / 7);
      let calendars = [];
      for (let week = 0; week < weekNumber; week++) {
        let weekRow = [];
        for (let day = 0;  day < 7; day++) {
          weekRow.push({
            year:  startDate.get("year"),
            month: startDate.get("month")+1,
            date:  startDate.get("date"),
            day:   startDate.get("day")
          });
          startDate.add(1, "days");
        }
        calendars.push(weekRow);
      }
      return calendars;
    },
    getStartDate: function() {
      let date = moment(this.currentDate);
      date.startOf("month"); // 月初を取得
      const youbiNum = date.day(); // 月初の曜日を取得
      // カレンダの始まりの日を計算（曜日のnumを減算して取得）
      return date.subtract(youbiNum, "days");
    },
    getEndDate() {
      let date = moment(this.currentDate);
      date.endOf("month");
      const youbiNum = date.day();
      return date.add(6 - youbiNum, "days");
    },
    nextMonth() {
      this.currentDate = moment(this.currentDate).add(1, "month");
    },
    prevMonth() {
      this.currentDate = moment(this.currentDate).subtract(1, "month");
    },
    isReserved(date) {
      let reserveCnt = 0
      if (this.selectStayRoomId == 0) {
        this.stayroomReserves.some(( v ) => {
          if (v.date == fmtApiDate2(date)) {
            reserveCnt++;
          }
        })
        if (reserveCnt < this.stayroomsProp.length) {
          return true
        }
        else {
          return false
        }
      }
      else {
        this.stayroomReserves.some(( v ) => {
          if (v.date == fmtApiDate2(date) && v.stayroom_id == this.selectStayRoomId) {
            reserveCnt++;
          }
        })
        if (reserveCnt > 0) {
          return false
        }
        else {
          return true
        }
      }
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
  .calendar-week {
    
    .calendar-date {
      width: 100px;
      border: 1px solid;
      cursor: pointer;
      &:hover {
        background: #888;
      }
    }
  }
}

</style>