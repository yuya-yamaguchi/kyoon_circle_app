<template>
  <div>
    <BreadCrumbs :breadCrumbs="breadCrumbs"/>
    <div class="double-container">
      <div class="double-container--left">
        <SideBar :select-menu-prop="2"/>
      </div>
      <div class="double-container--right">
        <div class="user-profile-container">
          <h1 class="main-title">プロフィール変更</h1>
          <UserForm/>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import SideBar from "@/components/organisms/common/SideBar.vue";
import UserForm from "@/components/organisms/user/UserForm.vue";
import BreadCrumbs from "@/components/organisms/common/BreadCrumbs.vue";

export default {
  components: {
    SideBar,
    UserForm,
    BreadCrumbs
  },
  computed: {
    breadCrumbs() {
      const breadCrumbsLists = [
        { name: 'トップ',
          path: '/'
        },
        { name: 'マイページ',
          path: '/mypage'
        },
        { name: 'プロフィール変更',
          path: ''
        }
      ]
      return breadCrumbsLists
    }
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

@media screen and (max-width: 600px) {
  .user-profile-container {
    padding: 0;
    background: var(--base-color);
  }
}
</style>