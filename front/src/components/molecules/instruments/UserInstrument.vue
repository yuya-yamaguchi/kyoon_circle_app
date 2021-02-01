<template>
  <div class="user-instruments">
    <div v-for="instrument in userInstrumentsProp" :key="instrument"
      class="instrument"
      :class="{'can-play': instrument.can_play}">
      <span>{{ instrument.name }}</span>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    userInstrumentsProp: {}
  }
}
</script>

<style scoped lang="scss">
.user-instruments {
  display: flex;
  justify-content: flex-start;
  flex-wrap: wrap;
  .instrument {
    border: 1px solid;
    margin: 5px 15px;
    padding: 2px 10px;
    border-radius: 10px;
    width: 80px;
    text-align: center;
    background: var(--accent-color);
    color: #FFF;
    font-weight: bold;
    opacity: 0.3;
    font-size: 14px;
  }
  .can-play {
    opacity: 1;
  }
}
</style>