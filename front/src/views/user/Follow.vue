<template>
  <div class="single-container">
    <div class="follows-container">
      <div class="user-name">{{ user.name }}</div>
      <FollowTabs
        :user="user"
        :current-tab="currentTab"/>
      <FollowList
        v-if="!loading"
        :follow-users-prop="followUsers"/>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import FollowList from "@/components/organisms/user/FollowList.vue";
import FollowTabs from "@/components/organisms/user/FollowTabs.vue";
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [errorMethods],
  components: {
    FollowList,
    FollowTabs
  },
  data() {
    return {
      user: {},
      followUsers: [],
      loading: true,
      currentTab: 0
    }
  },
  watch: {
    // パラメータのみの変更はコンポーネントが再描画されないため、
    // $routeが変更されたことをパラメータが変更されたことをwatchにて検知する
    '$route' (to) {
      if ( to.query.follow === 'following' ) {
        this.getFollowing();
      }
      else if ( to.query.follow === 'followers' ) {
        this.getFollowers();
      }
    }
  },
  methods: {
    getFollowing: function() {
      this.loading = true;
      axios.get(
        `http://${g.hostName}/api/users/${this.$route.params.id}/following`,
        {
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then((response) => {
        this.user = response.data.user;
        this.followUsers = response.data.following_users;
        this.currentTab = 1;
      })
      .catch((error) => {
        this.apiErrors(error.response.status);
      })
      .finally(() => {
        this.loading = false
      });
    },
    getFollowers: function() {
      this.loading = true;
      axios.get(
        `http://${g.hostName}/api/users/${this.$route.params.id}/followers`,
        {
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then((response) => {
        this.user = response.data.user;
        this.followUsers = response.data.followers;
        this.currentTab = 2;
      })
      .catch((error) => {
        this.apiErrors(error.response.status);
      })
      .finally(() => {
        this.loading = false
      });
    }
  },
  mounted() {
    if (this.$route.query.follow === 'following') {
      this.getFollowing();
    }
    else if (this.$route.query.follow === 'followers') {
      this.getFollowers();
    }
  }
}
</script>

<style scoped lang="scss">
.follows-container {
  max-width: 700px;
  background: var(--base-color);
  margin: 0 auto;
  .user-name {
    padding: 10px;
    border-bottom: 1px solid lightgray;
    text-align: center;
    font-weight: bold;
    font-size: 20px;
  }
}
</style>