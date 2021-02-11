<template>
  <div class="flex-between some-updown-center">
    <fa icon="chevron-left" class="arrow-icon" @click="changePage(pagyProp.prev)"></fa>
    <div v-for="pageNo in pagyProp.series" :key="pageNo">
      <div v-if="pageNo=='gap'">...</div>
      <div v-else @click="changePage(pageNo)" class="page-no" :class="{ 'active-page': pageNo == pagyProp.page }">
        {{ pageNo }}
      </div>
    </div>
    <fa icon="chevron-right" class="arrow-icon" @click="changePage(pagyProp.next)"></fa>
  </div>
</template>

<script>
export default {
  props: {
    pagyProp: {}
  },
  methods: {
    changePage: function(pageNo) {
      this.$emit('chage-page', pageNo);
    }
  }
}
</script>

<style scoped lang="scss">
.flex-between {
  width: 100%;
  margin: 30px auto;
  display: flex;
  justify-content: space-between;
  .arrow-icon {
    width: 20px;
    cursor: pointer;
  }
  .page-no {
    font-size: 20px;
    font-weight: bold;
    width: 30px;
    height: 30px;
    line-height: 30px;
    border: 2px solid;
    text-align: center;
    border-radius: 30%;
    cursor: pointer;
  }
  .active-page {
    background: var(--accent-color);
    color: #FFF;
    border: 2px solid #333;
  }
}
</style>