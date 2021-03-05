<template>
  <div>
    <BreadCrumbs :breadCrumbs="breadCrumbs"/>
    <div class="single-container">
      <div class="auth-container">
        <div class="text-center some-updown-center">
          <h1 class="main-title text-center">新規会員登録</h1>
          <fa icon="user" class="default-icon"></fa>
        </div>
        <SignUpForm/>
        <div class="other-sign-links">
          <SignLinks/>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import SignLinks from "@/components/organisms/auth/SignLinks.vue";
import SignUpForm from "@/components/organisms/auth/SignUpForm.vue";
import BreadCrumbs from "@/components/organisms/common/BreadCrumbs.vue";

export default {
  components: {
    SignLinks,
    SignUpForm,
    BreadCrumbs
  },
  computed: {
    breadCrumbs() {
      const breadCrumbsLists = [
        { name: 'トップ',
          path: '/'
        },
        { name: '新規会員登録',
          path: ''
        }
      ]
      return breadCrumbsLists
    }
  },
  mounted() {
    this.$store.dispatch(
      "loginGuide/update", false
    );
  }
}
</script>

<style scoped lang="scss">
svg {
  margin-left: 10px;
}
.other-sign-links {
  border-top: 1px solid #888;
  margin: 20px 50px;
}
</style>