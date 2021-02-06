<template>
  <div>
    <BreadCrumbs :breadCrumbs="breadCrumbs"/>
    <div class="single-container">
      <EventContent
        v-if="event"
        :event-prop="event"
        :is-entry-prop="isEntry"
        :entry-users-prop="entryUsers"
        @update-entry-status="updateIsEntry"/>
      <div v-if="event.event_category_id==2">
        <EventSession
          :is-entry-prop="isEntry"
          @update-entry-status="updateIsEntry"/>
      </div>
      <EventComments/>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import BreadCrumbs from "@/components/organisms/common/BreadCrumbs.vue";
import EventContent from "@/components/organisms/events/EventContent.vue";
import EventSession from "@/components/organisms/events/EventSession.vue";
import EventComments from "@/components/organisms/events/EventComments.vue";
import { commonMethods } from '@/mixins/commonMethods';
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [commonMethods, errorMethods],
  components: {
    BreadCrumbs,
    EventContent,
    EventSession,
    EventComments
  },
  data() {
    return {
      event: "",
      isEntry: false,
      entryUsers: []
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
          name: this.event.title,
          path: ''
        }
      ]
      return breadCrumbsLists
    }
  },
  methods: {
    getEvent: function() {
      axios.get(
        `http://${g.hostName}/api/events/${this.$route.params.id}`,
        {
          params: {
            user_id: this.$store.getters['user/id']
          }
        }
      )
      .then((response) => {
        this.event = response.data.event;
        this.isEntry = response.data.is_entry;
        this.entryUsers = response.data.entry_users;
      })
      .catch((error) => {
        this.apiErrors(error.response.status);
      })
      .finally(() => {
        // this.loading = false;
      });
    },
    updateIsEntry: function(value) {
      console.log("google")
      this.isEntry = value;
    }
  },
  mounted() {
    this.getEvent();
  }
}
</script>
