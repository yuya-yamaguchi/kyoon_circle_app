<template>
  <div class="single-container">
    <div class="auth-container releative-container">
      <LoadingCircle v-if="sendingEmailStatus"/>
      <div v-if="!sendEmailStatus">
        <ForgetPasswordForm
          @sent-email="sentEmail"
          @sending-email="sendingEmail"/>
      </div>
      <div v-else>
        <h1 class="main-title text-center">メールを送信しました</h1>
        <div class="sent-email-message">
          <p>
            {{ email }}へメールを送信しました。<br>
            メールに記載されたURLをクリックして、パスワードの変更を完了してください。<br>
            メールが届かない場合、再度送信してください。
          </p>
          <a @click="sendEmailAgain" class="forget-password-link">再度送信する</a>
        </div>
        <div>
          <router-link :to="{name: 'Top'}" class="top-page-link">トップページへ</router-link>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import ForgetPasswordForm from '@/components/organisms/auth/ForgetPasswordForm.vue';
import LoadingCircle from '@/components/organisms/common/LoadingCircle.vue';

export default {
  components: {
    ForgetPasswordForm,
    LoadingCircle
  },
  data() {
    return {
      sendEmailStatus: false,
      sendingEmailStatus: false,
      email: ''
    }
  },
  methods: {
    sentEmail: function(email) {
      this.sendEmailStatus = true;
      this.email = email;
    },
    sendingEmail: function(status) {
      this.sendingEmailStatus = status;
    },
    sendEmailAgain: function() {
      this.sendEmailStatus = false;
      this.email = '';
    }
  }
}
</script>

<style scoped lang="scss">
.releative-container {
  position: relative;
}
.sent-email-message {
  margin: 30px 50px;
  .forget-password-link {
    display: inline-block;
    text-decoration: underline;
    margin-top: 10px;
    cursor: pointer;
  }
}
.top-page-link {
  color: #2C3E50;
  display: flex;
  margin: 0 auto;
  justify-content: center;
}
</style>