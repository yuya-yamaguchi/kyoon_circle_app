const EMPTY_MSG          = "入力してください"
const CHARS_OVER_MSG     = "文字以内で入力してください"
const NO_CONSISTECY_MSG  = "正しく入力してください"
const AFTER_TODAY_MSG    = "本日日付以降を選択してください"
const AFTER_TIME_MSG     = "終了時刻は開始時刻以降にしてください"

export const commonCheck = {
  methods: {
    /* フォームの文字入力値チェック  */
    /* value:   チェックする値    */
    /* maxNum:  許容する最大桁数  */
    /* chkType: どのチェックをするか(デフォルトは全チェック) */
    formStrChk: function(value, maxNum, chkType="11") {
      var chkTypeAry = chkType.split('');
      // [0]必須入力チェック
      if (chkTypeAry[0] == "1") {
        if (!value) return EMPTY_MSG
      }
      // [1]最大文字数チェック
      if (chkTypeAry[1] == "1") {
        if (value && value.length > maxNum) return `${maxNum}${CHARS_OVER_MSG}`
      }
      return ""
    },
    /* 時分の入力チェック */
    formTimeChk: function(hour, min) {
      if (hour.length == 0 && min.length == 0) return EMPTY_MSG
      if (hour.length == 0 || min.length == 0) return NO_CONSISTECY_MSG
      return ""
    },
    /* 開始終了時刻の整合性チェック */
    startEndChk: function(startHour, startMin, endHour, endMin) {
      if (Number(startHour) > Number(endHour)) {
        return AFTER_TIME_MSG
      }
      else if (Number(startHour) == Number(endHour)) {
        if (startMin >= endMin) {
          return AFTER_TIME_MSG
        }
      }
      return ""
    },
    /* 本日日付以降であるかのチェック */
    isAfterToday: function(date) {
      var today = new Date();
      var targetDate = new Date(date.substr(0, 4),
                                Number(date.substr(5, 2))-1,
                                date.substr(8, 2), 23, 59, 59);
      if (targetDate < today) return AFTER_TODAY_MSG
      return ""
    }
  }
}