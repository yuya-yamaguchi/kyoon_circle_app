const today = new Date();

export const commonMethods = {
  methods: {
    formatDate(date, format) {
      if (!date) return
      let formatAry = format.split(/([A-Z0-9]*)/);
      let year  = date.substr(0, 4);
      let month = date.substr(5, 2);
      let day   = date.substr(8, 2);
      let hour  = date.substr(11, 2);
      let min   = date.substr(14, 2);
      let sec   = date.substr(17, 2);
      let outDate = ""
      formatAry.forEach((v) => {
        switch (v) {
          case 'YYYY':
            outDate += year;
            break;
          case 'MM':
            outDate += this.zeroPadding(month, 2);
            break;
          case 'M':
            outDate += Number(month);
            break;
          case 'DD':
            outDate += this.zeroPadding(day, 2);
            break;
          case 'D':
            outDate += Number(day);
            break;
          case 'HH24':
            outDate += this.zeroPadding(hour, 2);
            break;
          case 'MI':
            outDate += this.zeroPadding(min, 2);
            break;
          case 'SS':
            outDate += this.zeroPadding(sec, 2);
            break;
          default:
            outDate += v;
            break;
        }
      })
      return outDate
    },
    /* 日付から曜日を算出 */
    calcWeek: function(date, type) {
      var dateJs = new Date(date.substr(0, 4),
                            Number(date.substr(5, 2))-1,
                            date.substr(8, 2));
      switch (type) {
        case 1:
          return ['日', '月', '火', '水', '木', '金', '土'][dateJs.getDay()];
        case 2:
          return ['Sun', 'Mon', 'Tue', 'Web', 'Thu', 'Fri', 'Sat'][dateJs.getDay()];
        default:
          return '-'
      }
    },
    /* 本日からどれくらい前かを算出 */
    /* datetime(string): YYYY-MM-DD HH24:MI:SS */
    howManyAgo: function(datetime) {
      var jsDatetime = new Date(`${datetime.substr(0, 4)}/${datetime.substr(5, 2)}/${datetime.substr(8, 2)} ${datetime.substr(11, 8)}`)
      var diff = today.getTime() - jsDatetime.getTime()
      var elapsed = new Date(diff);
      if (elapsed.getUTCFullYear() - 1970 < 0) {
        return 'たった今'
      } else if (elapsed.getUTCFullYear() - 1970) {
        return elapsed.getUTCFullYear() - 1970 + '年前';
      } else if (elapsed.getUTCMonth()) {
        return elapsed.getUTCMonth() + 'ヶ月前';
      } else if (elapsed.getUTCDate() - 1) {
        return elapsed.getUTCDate() - 1 + '日前';
      } else if (elapsed.getUTCHours()) {
        return elapsed.getUTCHours() + '時間前';
      } else if (elapsed.getUTCMinutes()) {
        return elapsed.getUTCMinutes() + '分前';
      } else {
        return elapsed.getUTCSeconds() + '秒前';
      }
    },
    /* n日後の日付を算出 */
    // [i]date(string): 形式（YYYY-MM-DD）
    // [i]n(int)
    // [o]n日後(string): 形式（YYYY-MM-DD）
    afterDays: function(date, n) {
      let calcDate = new Date(date.substr(0, 4), Number(date.substr(5, 2))-1, Number(date.substr(8, 2)) + n)
      return calcDate.getFullYear() + '-' + paddingZero(calcDate.getMonth()+1) + '-' + paddingZero(calcDate.getDate());
    },
    zeroPadding(value, n) {
      return (('0' * n) + String(value)).slice(-n)
    }
  }
}

function paddingZero(value) {
  return ('00' + value).slice(-2)
}