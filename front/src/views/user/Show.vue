<template>
  <div>
    <BreadCrumbs :breadCrumbs="breadCrumbs"/>
    <div class="single-container">
      <UserInfo
        v-if="!loading"
        :user-prop="user"
        :user-instruments-prop="userInstruments"
        :is-followed-prop="isFollowed"
        :loading="loading"/>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import BreadCrumbs from "@/components/organisms/common/BreadCrumbs.vue";
import UserInfo from "@/components/organisms/user/UserInfo.vue";
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [errorMethods],
  components: {
    BreadCrumbs,
    UserInfo
  },
  computed: {
    breadCrumbs() {
      const breadCrumbsLists = [
        { name: 'トップ',
          path: '/'
        },
        { name: this.user.name,
          path: ''
        }
      ]
      return breadCrumbsLists
    }
  },
  data() {
    return {
      user: "",
      userInstruments: [],
      isFollowed: false,
      loading: true
    }
  },
  methods: {
    getUser: function() {
      axios.get(
        `http://${g.hostName}/api/users/${this.$route.params.id}`,
        {
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then((response) => {
        this.user = response.data.user
        this.userInstruments = response.data.user_instruments
        this.isFollowed = response.data.user_followed
      })
      .catch((error) => {
        this.apiErrors(error.response);
      })
      .finally(() => {
        this.loading = false;
      });
    }
  },
  mounted() {
    this.getUser();
  }
}
</script>