<template>
  <div class="menus-container">
    <div v-for="(menu, i) in menus" :key="i" class="menu-card">
      <router-link
        :to="menu.path"
        :class="{ 'border-line': menus.length!=(i+1) }"
        class="menu-link some-updown-center">
        <fa v-if="menu.icon" :icon="menu.icon" class="menu-link--icon"></fa>
        <div class="menu-link--title">
          {{ menu.name }}
        </div>
      </router-link>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    menus: {}
  }
}
</script>

<style scoped lang="scss">
.menus-container {
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
    .border-line {
      border-bottom: 1px solid lightgray;
    }
  }
}
</style>