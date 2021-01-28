<template>
  <div class="double-container">
    <div class="double-container--left">
      <SideBar :select-menu-prop="2"/>
    </div>
    <div class="double-container--right">
      <div class="user-profile-container">
        <h1 class="main-title">ユーザ情報変更</h1>
        <UserEditForm/>
      </div>
    </div>
  </div>
</template>

<script>
import SideBar from "@/components/organisms/common/SideBar.vue";
import UserEditForm from "@/components/organisms/user/UserEditForm.vue";

export default {
  components: {
    SideBar,
    UserEditForm
  }
}
</script>

<style lang="scss" scoped>
.user-profile-container {
  width: 100%;
  margin: 0 auto;
  padding: 20px 0;
  background: #FFF;
  h1 {
    margin: 0 0 20px 20px;
  }
}
</style>