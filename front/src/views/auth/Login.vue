<template>
  <div class="single-container">
    <div class="auth-container">
      <div class="text-center some-updown-center">
        <span class="main-title">ログイン</span>
        <fa icon="sign-in-alt" class="default-icon"></fa>
      </div>
      <LoginForm/>
      <div class="other-sign-links">
        <SignLinks/>
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
  }
}
</script>

<style scoped lang="scss">
.other-sign-links {
  border-top: 1px solid #888;
  margin: 20px 50px;
}
</style>