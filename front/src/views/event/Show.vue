<template>
  <div>
    <BreadCrumbs :breadCrumbs="breadCrumbs"/>
    <div class="single-container">
      <EventContent
        v-if="event"
        :event-prop="event"
        :is-entry-prop="isEntry"
        :entry-users-prop="entryUsers"
        @update-entry-status="updateEntryStatus"
        @update-event-session="updateEventSession"/>
      <div v-if="event.event_category_id==2">
        <EventSession
          :key="key"
          :is-entry-prop="isEntry"
          @update-entry-status="updateEntryStatus"/>
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
      entryUsers: [],
      key: true // EventSessionの再描画用
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
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then((response) => {
        this.event = response.data.event;
        this.isEntry = response.data.is_entry;
        this.entryUsers = response.data.entry_users;
      })
      .catch((error) => {
        this.apiErrors(error.response);
      })
    },
    updateEntryStatus: function(entryStatus, entryUsersUp) {
      this.isEntry = entryStatus;
      this.entryUsers = entryUsersUp;
    },
    updateEventSession: function() {
      this.key = !this.key
    }
  },
  mounted() {
    this.getEvent();
  }
}
</script>
