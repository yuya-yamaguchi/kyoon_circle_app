<template>
  <div>
    <BreadCrumbs :breadCrumbs="breadCrumbs"/>
    <div class="single-container">
      <EventContent @set-event-title="setEventTitle"/>
      <EventComments/>
    </div>
  </div>
</template>

<script>
import BreadCrumbs from "@/components/organisms/common/BreadCrumbs.vue";
import EventContent from "@/components/organisms/events/EventContent.vue";
import EventComments from "@/components/organisms/events/EventComments.vue";

export default {
  components: {
    BreadCrumbs,
    EventContent,
    EventComments
  },
  data() {
    return {
      eventTitle: ""
    }
  },
  computed: {
    breadCrumbs() {
      var breadCrumbsLists = [
        {
          name: 'トップ',
          path: '/'
        },
        {
          name: 'イベント一覧',
          path: '/events?page=1'
        },
        {
          name: this.eventTitle,
          path: ''
        }
      ]
      return breadCrumbsLists
    }
  },
  methods: {
    setEventTitle: function(title){
      this.eventTitle = title;
    }
  }
}
</script>
