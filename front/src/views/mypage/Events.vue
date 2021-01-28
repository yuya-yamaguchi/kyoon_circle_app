<template>
  <div class="double-container">
    <div class="double-container--left">
      <SideBar :select-menu-prop="4"/>
    </div>
    <div class="double-container--right">
      <EntryEvent/>
    </div>
  </div>
</template>

<script>
import SideBar from "@/components/organisms/common/SideBar.vue";
import EntryEvent from '@/components/organisms/mypage/EntryEvent.vue';
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [errorMethods],
  components: {
    SideBar,
    EntryEvent
  }
}
</script>
