<template>
  <div class="user-instruments">
    <div v-for="(instrument, i) in userInstruments" :key="i">
      <label :for="instrument.id" class="instrument" :class="{'can-play': instrument_ids.includes(instrument.id)}">
        <input type="checkbox"
          :id="instrument.id"
          :value="instrument.id"
          v-model="instrument_ids"
          @change="changeInstruments(instrument)">
        {{ instrument.name }}
      </label>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    userInstrumentsProp: {}
  },
  data() {
    let instrument_ids = []
    this.userInstrumentsProp.forEach(function(instrument) {
      if (instrument.can_play) {
        instrument_ids.push(instrument.id)
      }
    });
    return {
      userInstruments: this.userInstrumentsProp,
      instrument_ids: instrument_ids
    }
  },
  methods: {
    changeInstruments: function(instrument) {
      instrument.can_play = !instrument.can_play
      this.$emit('change-Instruments', this.instrument_ids)
    }
  }
}
</script>

<style scoped lang="scss">
.user-instruments {
  display: flex;
  justify-content: flex-start;
  flex-wrap: wrap;
  .instrument {
    display: block;
    border: 1px solid;
    margin: 5px 20px 5px 0;
    padding: 2px 10px;
    border-radius: 10px;
    width: 80px;
    text-align: center;
    background: var(--accent-color);
    color: #FFF;
    font-weight: bold;
    opacity: 0.3;
    font-size: 0.8rem;
    cursor: pointer;
    input {
      display: none;
    }
  }
  .can-play {
    opacity: 1;
  }
}
</style>