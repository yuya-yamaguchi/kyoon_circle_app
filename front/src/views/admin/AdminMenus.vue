<template>
  <div>
    <BreadCrumbs :breadCrumbs="breadCrumbs"/>
    <div class="double-container">
      <div class="double-container--left">
        <SideBar :select-menu-prop="100"/>
      </div>
      <div class="double-container--right">
        <div class="admin-menus-container">
          <div class="admin-menus">
            <h3 class="admin-menu-title">ユーザ</h3>
            <Menus :menus="userMenues"/>
          </div>
          <div class="admin-menus">
            <h3 class="admin-menu-title">スタジオ</h3>
            <Menus :menus="studioMenues"/>
          </div>
          <div class="admin-menus">
            <h3 class="admin-menu-title">宿泊</h3>
            <Menus :menus="stayroomMenues"/>
          </div>
          <div class="admin-menus">
            <h3 class="admin-menu-title">イベント</h3>
            <Menus :menus="eventMenues"/>
          </div>
          <div class="admin-menus">
            <h3 class="admin-menu-title">お知らせ</h3>
            <Menus :menus="newsMenues"/>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import SideBar from "@/components/organisms/common/SideBar.vue";
import Menus from "@/components/molecules/common/Menus.vue";
import BreadCrumbs from "@/components/organisms/common/BreadCrumbs.vue";

export default {
  components: {
    SideBar,
    Menus,
    BreadCrumbs
  },
  computed: {
    userMenues() {
      const menus = [
        {
          name: '登録ユーザ一覧',
          path: '/users'
        }
      ]
      return menus
    },
    studioMenues() {
      const menus = [
        {
          name: 'スタジオ情報編集',
          path: '/studio/1/edit'
        },
        {
          name: 'スタジオ予約確認',
          path: '/admin/studio/1/reserves?week=0'
        }
      ]
      return menus
    },
    stayroomMenues() {
      const menus = [
        {
          name: '宿泊予約確認',
          path: '/admin/stayrooms?month=0'
        }
      ]
      return menus
    },
    eventMenues() {
      const menus = [
        {
          name: 'イベント登録',
          path: '/event/new'
        },
        {
          name: 'イベント編集',
          path: '/events/editlist?page=1'
        }
      ]
      return menus
    },
    newsMenues() {
      const menus = [
        {
          name: 'お知らせ登録',
          path: '/news/new'
        },
        {
          name: 'お知らせ編集',
          path: '/news/editlist'
        }
      ]
      return menus
    },
    breadCrumbs() {
      const breadCrumbsLists = [
        { name: 'トップ',
          path: '/'
        },
        { name: '管理メニュー',
          path: ''
        }
      ]
      return breadCrumbsLists
    }
  }
}
</script>

<style scoped lang="scss">
.admin-menus-container {
  margin: 0 20px;
  .admin-menu-title {
    font-size: 1.1rem;
    font-weight: bold;
  }
  .admin-menus {
    margin: 0 auto;
    margin-bottom: 20px;
    max-width: 500px;
  }
}
</style>