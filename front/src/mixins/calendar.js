import moment from "moment";
let today = new Date();

export const calendar = {
  data() {
    return {
      currentDate: moment(),
      calendars: [],
      weeks: ['日', '月', '火', '水', '木', '金', '土']
    }
  },
  methods: {
    getCalendar(month) {
      this.currentDate = moment().add(month, "month");
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
      this.calendars = calendars;
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
    isToday(day) {
      if (today.getFullYear() === day.year &&
          today.getMonth()+1  === day.month &&
          today.getDate()     ===  day.date) {
        return true
      }
      else {
        return false
      }
    }
  }
}