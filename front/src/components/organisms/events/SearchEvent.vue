<template>
  <div>
    <select v-model="selectEventCategory" @change="searchEvents(value)">
      <option value="0">すべて</option>
      <option v-for="eventCategory in eventCategories" :value="eventCategory.id" :key="eventCategory.id">
        {{ eventCategory.name }}
      </option>
    </select>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";

export default {
  props: {
    selectEventCategoryProp: {}
  },
  data() {
    return {
      selectEventCategory: this.selectEventCategoryProp,
      eventCategories: []
    }
  },
  methods: {
    getEventCategories: function() {
      axios.get(
        `http://${g.hostName}/api/event_categories`
      )
      .then((response) => {
        this.eventCategories = response.data
      })
      .catch((error) => {
        console.log(error);
      });
    },
    searchEvents: function() {
      this.$emit('search-events', this.selectEventCategory);
    }
  },
  mounted() {
    this.getEventCategories()
  }
}
</script>

<style scoped lang="scss">
select {
  margin-left: 20px;
}
</style>