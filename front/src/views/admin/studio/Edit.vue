<template>
  <div class="double-container">
    <div class="double-container--left">
      <SideBar :select-menu-prop="102"/>
    </div>
    <div class="double-container--right">
      <div class="studio-edit-container">
        <h1 class="main-title">スタジオ内容の変更</h1>
        <StudioForm/>
      </div>
    </div>
  </div>
</template>

<script>
import SideBar from "@/components/organisms/common/SideBar.vue";
import StudioForm from "@/components/organisms/studio/StudioForm.vue";

export default {
  components: {
    SideBar,
    StudioForm
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