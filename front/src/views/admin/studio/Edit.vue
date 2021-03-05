<template>
  <div>
    <BreadCrumbs :breadCrumbs="breadCrumbs"/>
    <div class="double-container">
      <div class="double-container--left">
        <SideBar :select-menu-prop="102"/>
      </div>
      <div class="double-container--right">
        <div class="studio-edit-container">
          <h1 class="main-title">スタジオ情報編集</h1>
          <StudioForm/>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import SideBar from "@/components/organisms/common/SideBar.vue";
import StudioForm from "@/components/organisms/studio/StudioForm.vue";
import BreadCrumbs from "@/components/organisms/common/BreadCrumbs.vue";

export default {
  components: {
    SideBar,
    StudioForm,
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
        { name: 'スタジオ情報編集',
          path: ''
        }
      ]
      return breadCrumbsLists
    }
  }
}
</script>

<style lang="scss" scoped>
.studio-edit-container {
  width: 100%;
  margin: 0 auto;
  padding: 20px 0;
  background: #FFF;
  h1 {
    margin: 0 0 20px 20px;
  }
}

@media screen and (max-width: 600px) {
  .studio-edit-container {
    background: var(--base-color);
  }
}
</style>