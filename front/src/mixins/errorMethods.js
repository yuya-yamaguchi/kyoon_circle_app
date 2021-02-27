export const errorMethods = {
  methods: {
    // statusにはAPIから返却されたのhttpステータスを設定する
    apiErrors: function(status) {
      this.$store.dispatch(
        "response/update",
        { status: status }
      );
      if (status === 401) {
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
}