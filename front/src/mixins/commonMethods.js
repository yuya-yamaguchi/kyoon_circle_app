export const commonMethods = {
  methods: {
    // 日付のフォーマット変換
    fmtDate: function(date, type) {
      if (!date) return
      switch (type) {
        // mm/dd(0トリム)
        case 1:
          return Number(date.substr(5, 2)) + '/' + Number(date.substr(8, 2))
        // yyyy/mm/dd HH24:MI:SS
        case 2:
          return date.substr(0, 4) + '/' +
                 date.substr(5, 2) + '/' +
                 date.substr(8, 2) + ' ' +
                 date.substr(11, 5)
        case 3:
          return Number(date.substr(5, 2)) + '月' + Number(date.substr(8, 2)) + '日'
        default:
          return date
      }
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
    }
  }
}