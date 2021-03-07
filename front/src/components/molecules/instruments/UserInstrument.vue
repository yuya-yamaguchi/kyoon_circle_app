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
    margin: 5px 15px 5px 0;
    padding: 2px 10px;
    border-radius: 10px;
    min-width: 70px;
    text-align: center;
    background: var(--accent-color);
    color: #FFF;
    font-weight: bold;
    opacity: 0.3;
    font-size: 0.8rem;
  }
  .can-play {
    opacity: 1;
  }
}
</style>