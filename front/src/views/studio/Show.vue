<template>
  <div>
    <BreadCrumbs :breadCrumbs="breadCrumbs"/>
    <StudioImage/>
    <div class="studio-container">
      <StudioContent/>
      <StudioReservesTable :admin-prop="0"/>
    </div>
  </div>
</template>

<script>
import BreadCrumbs from "@/components/organisms/common/BreadCrumbs.vue";
import StudioImage from "@/components/organisms/studio/StudioImage.vue";
import StudioContent from "@/components/organisms/studio/StudioContent.vue";
import StudioReservesTable from "@/components/organisms/studio/StudioReservesTable.vue";
import { commonMethods } from '@/mixins/commonMethods';
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [commonMethods, errorMethods],
  components: {
    BreadCrumbs,
    StudioImage,
    StudioContent,
    StudioReservesTable
  },
  computed: {
    breadCrumbs() {
      var breadCrumbsLists = [
        {
          name: 'トップ',
          path: '/'
        },
        {
          name: 'スタジオ',
          path: ''
        }
      ]
      return breadCrumbsLists
    }
  }
}
</script>

<style scoped>
.studio-container {
  margin: 40px 10px 0 10px;
}
</style>
