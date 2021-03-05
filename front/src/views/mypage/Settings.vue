<template>
  <div>
    <BreadCrumbs :breadCrumbs="breadCrumbs"/>
    <div class="double-container">
      <div class="double-container--left">
        <SideBar :select-menu-prop="7"/>
      </div>
      <div class="double-container--right">
        <div class="settings-container">
          <h1 class="main-title text-center">設定</h1>
          <div class="menu-cards">
            <Menus :menus="settingMenues"/>
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
    settingMenues() {
      const menus = [
        {
          name: 'メールアドレス変更',
          path: '/mypage/change_email',
          icon: 'envelope'
        },
        {
          name: 'パスワード変更',
          path: '/mypage/change_password',
          icon: 'key'
        }
      ]
      return menus
    },
    breadCrumbs() {
      const breadCrumbsLists = [
        { name: 'トップ',
          path: '/'
        },
        { name: 'マイページ',
          path: '/mypage'
        },
        { name: '設定',
          path: ''
        }
      ]
      return breadCrumbsLists
    }
  }
}
</script>

<style scoped lang="scss">
.settings-container {
  max-width: 700px;
  padding: 0 10px;
  .menu-cards {
    margin: 20px;
    border-radius: 10px;
    border: 1px solid lightgray;
    background: #FFF;
    .menu-card {
      width: 100%;
      .menu-link {
        display: flex;
        justify-content: flex-start;
        text-decoration: none;
        color: #333;
        padding: 10px 0 10px 10px;
        cursor: pointer;
        &:hover {
          opacity: .8;
          transition: .3s;
        }
        &--icon {
          display: block;
          width: 16px;
          height: 16px;
          margin-right: 10px;
        }
      }
      .menu-top {
        font-weight: bold;
      }
    }
    .border-line {
      border-bottom: 1px solid lightgray;
    }
  }
}
</style>