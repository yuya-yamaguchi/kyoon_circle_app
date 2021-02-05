<template>
  <div v-if="breadCrumbs!=[]" class="bread-crumbs">
    <div v-for="(breadCrumb, i) in breadCrumbs" :key="i" class="bread-crumbs--list">
      <router-link v-if="breadCrumb.path!=''" :to="`${breadCrumb.path}`">
        {{ breadCrumb.name }}
      </router-link>
      <span v-else>
        {{ breadCrumb.name }}
      </span>
      <span v-if="breadCrumbs.length-1!=i" class='bread-crumbs--list--arrow'>
        >
      </span>
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
  padding: 10px 20px;
  font-weight: bold;
  font-size: 15px;
  background: #333;
  border-top: 1px dotted #888;
  color: #FFF;
  position: fixed;
  z-index: 10;
  &--list {
    a {
      text-decoration: none;
      color: #FFF;
      &:hover {
        color: var(--accent-color);
      }
    }
    &--arrow {
      margin: 0 10px;
    }
  }
}
</style>