export const errorMethods = {
  methods: {
    // statusにはAPIから返却されたのhttpステータスを設定する
    apiErrors: function(response) {
      this.$store.dispatch(
        "response/update",
        { status:   response.status,
          messages: response.data }
      );
      if (response.status === 401) {
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