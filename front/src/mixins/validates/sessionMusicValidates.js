import {notEmptyValid,
        maxLengthValid}
from '@/modules/commonValidates.js';

export const sessionMusicValidates = {
  methods: {
    sessionMusicTitleValid: function(value) {
      let message = ""
      // 必須チェック
      message = notEmptyValid(value)
      if (message) return message 
      // 桁数チェック
      message = maxLengthValid(value, 40)
      return message
    },
    sessionMusicArtistValid: function(value) {
      let message = ""
      // 必須チェック
      message = notEmptyValid(value)
      if (message) return message 
      // 桁数チェック
      message = maxLengthValid(value, 40)
      return message
    }
  }
}