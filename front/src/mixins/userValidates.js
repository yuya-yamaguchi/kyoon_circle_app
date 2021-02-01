import {notEmptyValid,
        maxLengthValid,
        rangeLengthValid,
        emailFormatValid,
        matchValid} from '@/modules/commonValidates.js';

export const userValidates = {
  methods: {
    userNameValid: function(value) {
      let message = ""
      // 必須チェック
      message = notEmptyValid(value)
      if (message) return message 
      // 桁数チェック
      message = maxLengthValid(value, 20)
      return message
    },
    userEmailValid: function(value) {
      let message = ""
      // 必須チェック
      message = notEmptyValid(value)
      if (message) return message 
      // メールフォーマットチェック
      message = emailFormatValid(value)
      return message
    },
    userPasswordValid: function(password, passwordConfirmation=null) {
      let message = ""
      // 必須チェック
      message = notEmptyValid(password)
      if (message) return message 
      // 最大最小桁数チェック
      message = rangeLengthValid(password, 6, 32)
      if (message) return message 
      // 一致チェック
      if (passwordConfirmation != null) {
        message = matchValid(password, passwordConfirmation)
      }
      return message
    }
  }
}