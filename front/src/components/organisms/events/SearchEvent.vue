<template>
  <div class="seach-event-container">
    <select v-model="search.eventCategory" @change="searchEvents()" class="event-category">
      <option value="0">すべて</option>
      <option v-for="eventCategory in eventCategories" :value="eventCategory.id" :key="eventCategory.id">
        {{ eventCategory.name }}
      </option>
    </select>
    <div class="sort-menus">
      <label for="sort_date_desc" class="sort-menu" :class="{ 'select-sort-menu': search.order=='date_desc'}">
        <fa icon="sort" class="sort-menu--icon"/>
        <span>開催日順</span>
        <input type="radio" id="sort_date_desc"
          @change="searchEvents()"
          value="date_desc"
          v-model="search.order"
          class="session-part-radio">
      </label>
      <label for="sort_entry_cnt_desc" class="sort-menu" :class="{ 'select-sort-menu': search.order=='entry_cnt_desc'}">
        <fa icon="sort" class="sort-menu--icon"/>
        <span>参加人数順</span>
        <input type="radio" id="sort_entry_cnt_desc"
          @change="searchEvents()"
          value="entry_cnt_desc"
          v-model="search.order"
          class="session-part-radio">
      </label>
    </div>
    <div class="end-event">
      <label for="end-event-hide">
        <input type="checkbox"
          id="end-event-hide"
          class="checkbox"
          v-model="search.endEventHide"
          @change="searchEvents()">
        <span>終了したイベントを非表示</span>
      </label>
    </div>
  </div>

</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [errorMethods],
  props: {
    searchProp: {}
  },
  data() {
    return {
      search: this.searchProp,
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
        this.apiErrors(error.response);
      });
    },
    searchEvents: function() {
      this.$emit('search-events', this.search);
    }
  },
  mounted() {
    this.getEventCategories()
  }
}
</script>

<style scoped lang="scss">
.seach-event-container {
  display: flex;
  justify-content: flex-start;
  align-items: center;
  flex-wrap : wrap;
  .event-category {
    margin-right: 10px;
  }
  .sort-menus {
    display: flex;
    justify-content: flex-start;
    .sort-menu {
      margin-right: 10px;
      font-size: 15px;
      display: flex;
      align-items: center;
      color: #888;
      cursor: pointer;
      &--icon {
        width: 16px;
        height: 16px;
      }
      input {
        display: none;
      }
    }
    .select-sort-menu {
      font-weight: bold;
      color: var(--accent-color);
    }
  }
  .end-event {
    display: block;
    margin: 10px 0;
    font-size: 15px;
    span {
      margin-left: 5px;
    }
  }
}
</style>