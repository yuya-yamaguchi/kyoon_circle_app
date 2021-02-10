<template>
  <div id="overlay">
    <div class="login-container">
      <button @click="closeModal()" class="close-button">×</button>
      <div class="login-inner-container">
        <div class="text-center some-updown-center">
          <span class="main-title">ログイン</span>
          <fa icon="sign-in-alt" class="default-icon"></fa>
        </div>
        <div class="login-form">
          <LoginForm/>
        </div>
        <div class="other-sign-links">
          <SignLinks/>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import SignLinks from "@/components/organisms/auth/SignLinks.vue";
import LoginForm from "@/components/organisms/auth/LoginForm.vue";

export default {
  components: {
    SignLinks,
    LoginForm
  },
  methods: {
    closeModal: function() {
      this.$store.dispatch(
        "loginGuide/update", false
      );
    },
  }
}
</script>

<style scoped lang="scss">
#overlay {
  z-index: 100;
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0,0,0,0.5);
  display: flex;
}
.login-container {
  width: 90%;
  max-width: 500px;
  margin: 0 auto;
  background: #FFF;
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%,-50%);
  .login-inner-container {
    margin: 0 40px;
  }
}
.login-form {
  margin: 30px 0;
}
.other-sign-links {
  border-top: 1px solid #888;
  margin: 20px 0;
}
</style>