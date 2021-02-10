<template>
  <div v-if="breadCrumbs" class="bread-crumbs">
    <div v-for="(breadCrumb, i) in breadCrumbs" :key="i" class="bread-crumbs--list">
      <router-link v-if="breadCrumb.path" :to="`${breadCrumb.path}`" class="bread-crumbs--list--link">
        {{ breadCrumb.name }}
      </router-link>
      <div v-else class="bread-crumbs--list--last">
        {{ breadCrumb.name }}
      </div>
      <div v-if="breadCrumbs.length-1!=i" class='bread-crumbs--list--arrow'>
        >
      </div>
    </div>
  </div>
</template>

<script>

export default {
  props: {
    breadCrumbs: {}
  }
}
</script>

<style scoped lang="scss">
.bread-crumbs {
  width: 100%;
  display: flex;
  justify-content: flex-start;
  padding: 10px;
  font-weight: bold;
  font-size: 15px;
  background: #333;
  border-top: 1px dotted #888;
  color: #FFF;
  position: fixed;
  box-sizing: border-box;
  z-index: 10;
  flex-wrap : wrap;
  &--list {
    display: flex;
    justify-content: flex-start;
    
    &--link {
      text-decoration: none;
      color: #FFF;
      white-space: nowrap;
      &:hover {
        color: var(--accent-color);
      }
    }
    &--last {
      white-space: nowrap;
    }
    &--arrow {
      margin: 0 10px;
    }
  }
}
</style>