export const errorMethods = {
  methods: {
    // statusにはAPIから返却されたのhttpステータスを設定する
    apiErrors: function(status) {
      this.$store.dispatch(
        "response/update",
        { status: status }
      );
    }
  }
}