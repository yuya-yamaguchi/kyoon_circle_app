<template>
  <div>
    <BreadCrumbs :breadCrumbs="breadCrumbs"/>
    <div class="double-container">
      <div class="double-container--left">
        <SideBar :select-menu-prop="101"/>
      </div>
      <div class="double-container--right">
        <UsersList/>
      </div>
    </div>
  </div>
</template>

<script>
import SideBar from "@/components/organisms/common/SideBar.vue";
import UsersList from "@/components/organisms/user/UsersList.vue";
import BreadCrumbs from "@/components/organisms/common/BreadCrumbs.vue";

export default {
  components: {
    SideBar,
    UsersList,
    BreadCrumbs
  },
  computed: {
    breadCrumbs() {
      const breadCrumbsLists = [
        { name: 'トップ',
          path: '/'
        },
        { name: '管理メニュー',
          path: '/admin'
        },
        { name: '登録ユーザ一覧',
          path: ''
        }
      ]
      return breadCrumbsLists
    }
  }
}
</script>
