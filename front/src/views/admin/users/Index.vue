<template>
  <div class="double-container">
    <div class="double-container--left">
      <SideBar :select-menu-prop="101"/>
    </div>
    <div class="double-container--right">
      <UsersList/>
    </div>
  </div>
</template>

<script>
import SideBar from "@/components/organisms/common/SideBar.vue";
import UsersList from "@/components/organisms/user/UsersList.vue";

export default {
  components: {
    SideBar,
    UsersList
  }
}
</script>
