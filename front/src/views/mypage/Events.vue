<template>
  <div>
    <BreadCrumbs :breadCrumbs="breadCrumbs"/>
    <div class="double-container">
      <div class="double-container--left">
        <SideBar :select-menu-prop="4"/>
      </div>
      <div class="double-container--right">
        <EntryEvent/>
      </div>
    </div>
  </div>
</template>

<script>
import SideBar from "@/components/organisms/common/SideBar.vue";
import EntryEvent from '@/components/organisms/mypage/EntryEvent.vue';
import BreadCrumbs from "@/components/organisms/common/BreadCrumbs.vue";

export default {
  components: {
    SideBar,
    EntryEvent,
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
        { name: '参加イベント一覧',
          path: ''
        }
      ]
      return breadCrumbsLists
    }
  }
}
</script>
