<template>
  <div class="single-container">
    <Loading v-if="loading"/>
    <div v-else class="auth-container">
      <div class="reset-password-container">
        <div v-if="resetPasswordStatus=='complete'">
          <ResetPasswordComplete/>
        </div>
        <div v-else-if="resetPasswordStatus=='changing'">
          <ResetPasswordForm @reset-password-complete="resetPasswordStatus='complete'"/>
        </div>
        <div v-else>
          <ResetPasswordInvalid/>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import Loading from '@/components/organisms/common/Loading.vue';
import ResetPasswordForm from '@/components/organisms/auth/ResetPasswordForm.vue';
import ResetPasswordComplete from '@/components/organisms/auth/ResetPasswordComplete.vue';
import ResetPasswordInvalid from '@/components/organisms/auth/ResetPasswordInvalid.vue';

export default {
  components: {
    Loading,
    ResetPasswordComplete,
    ResetPasswordForm,
    ResetPasswordInvalid
  },
  data() {
    return {
      loading: true,
      resetPasswordStatus: ''
    }
  },
  methods: {
    getResetPasswordTokenCheck: function() {
      axios.get(
        `http://${g.hostName}/api/users/reset_password_token_check`,
        {
          params: {
            token: this.$route.query.token
          }
        }
      )
      .then(() => {
        this.resetPasswordStatus = 'changing'
      })
      .catch(() => {
        this.resetPasswordStatus = 'invalid'
      })
      .finally(() => {
        this.loading = false
      })
    }
  },
  mounted() {
    this.getResetPasswordTokenCheck();
  }
}
</script>

<style scoped lang="scss">
.reset-password-container {
  max-width: 400px;
  margin: 0 auto;
}
</style>