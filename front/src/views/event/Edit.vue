<template>
  <div>
    <BreadCrumbs :breadCrumbs="breadCrumbs"/>
    <div class="double-container">
      <div class="double-container--left">
        <SideBar :select-menu-prop="104"/>
      </div>
      <div class="double-container--right">
        <div class="event-edit-container">
          <h1 class="main-title text-center">イベント編集</h1>
          <div class="error-messages">
            <ErrMsg/>
          </div>
          <EventForm v-if="event"
            :event-prop="event"
            :modal-msg-prop="modalMsg"
            @post-event="updateEvent"/>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import SideBar from "@/components/organisms/common/SideBar.vue";
import EventForm from "@/components/organisms/events/EventForm.vue";
import ErrMsg from "@/components/organisms/common/ErrMsg.vue";
import BreadCrumbs from "@/components/organisms/common/BreadCrumbs.vue";
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [errorMethods],
  components: {
    SideBar,
    EventForm,
    ErrMsg,
    BreadCrumbs
  },
  computed: {
    breadCrumbs() {
      const breadCrumbsLists = [
        { name: 'トップ',
          path: '/'
        },
        { name: '管理メニュー',
          path: '/admin'
        },
        { name: `${this.event.title}`,
          path: `/event/${this.event.id}`
        },
        { name: '編集',
          path: ''
        }
      ]
      return breadCrumbsLists
    }
  },
  data() {
    return {
      event: '',
      modalMsg: {
        title: "イベント変更",
        message: 'イベントの内容を変更します。よろしいですか？',
        btn: "変更"
      }
    }
  },
  methods: {
    getEvent: function() {
      axios.get(
        `http://${g.hostName}/api/events/${this.$route.params.id}/edit`,
        {
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then((response) => {
        this.event = response.data
      })
      .catch((error) => {
        this.apiErrors(error.response);
      });
    },
    updateEvent: function(event) {
      axios.put(
        `http://${g.hostName}/api/events/${event.id}`,
        {
          user_id: this.$store.getters['user/id'],
          event: event
        },
        {
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then(() => {
        this.apiErrorMessages = []
        this.$router.push({
          name: "EventShow"
        })
      })
      .catch((error) => {
        this.apiErrors(error.response);
      });
    }
  },
  mounted() {
    this.getEvent();
  }
}
</script>

<style scoped lang="scss">
.event-edit-container {
  width: 100%;
  margin: 0 auto;
  padding: 20px 0;
  background: #FFF;
}
</style>