<template>
  <div>
    <select v-model="searchSelect.eventType" @change="searchEvents(value)">
      <option value="0">すべて</option>
      <option v-for="option in options" :value="option.event_type" :key="option.event_type">
        {{ option.name }}
      </option>
    </select>
  </div>
</template>

<script>
export default {
  props: {
    searchSelectProp: {}
  },
  data() {
    return {
      searchSelect: this.searchSelectProp,
      options: [
        { event_type: 1, name: 'セッション' },
        { event_type: 2, name: '飲み会・懇親会' },
        { event_type: 3, name: '合宿' },
        { event_type: 4, name: 'その他' }
      ]
    }
  },
  methods: {
    searchEvents: function() {
      this.$emit('search-events', this.searchSelect);
    }
  }
}
</script>

<style scoped lang="scss">
select {
  margin-left: 20px;
}
</style>