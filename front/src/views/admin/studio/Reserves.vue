<template>
  <div>
    <BreadCrumbs :breadCrumbs="breadCrumbs"/>
    <div class="double-container">
      <div class="double-container--left">
        <SideBar :select-menu-prop="107"/>
      </div>
      <div class="double-container--right">
        <div class="studio-reserves-container">
          <StudioReservesTable :admin-prop="1"/>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import SideBar from "@/components/organisms/common/SideBar.vue";
import StudioReservesTable from "@/components/organisms/studio/StudioReservesTable.vue";
import BreadCrumbs from "@/components/organisms/common/BreadCrumbs.vue";

export default {
  components: {
    SideBar,
    StudioReservesTable,
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
        { name: 'スタジオ予約確認',
          path: ''
        }
      ]
      return breadCrumbsLists
    }
  }
}
</script>

<style lang="scss" scoped>
.studio-reserves-container {
  width: 100%;
  margin: 0 auto;
}
</style>