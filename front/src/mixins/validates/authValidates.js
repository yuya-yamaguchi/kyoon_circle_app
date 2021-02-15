export const authValidates = {
  methods: {
    // ログイン有無を確認
    isLogin: function() {
      return (this.$store.getters['user/id']) ? true : false
    },
    // ログインの導線に誘導
    displayLogin: function() {
      // ログインモーダルを表示
      this.$store.dispatch(
        "loginGuide/update", true
      );
      this.$store.dispatch(
        "flash/create",
        { message: "ログインまたは会員登録を行ってください。",
          type:    2
        }
      );
    }
  }
}