<template>
  <div class="single-container">
    <UserInfo
      :user-prop="user"
      :user-instruments-prop="userInstruments"
      :loading="loading"/>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import UserInfo from "@/components/organisms/user/UserInfo.vue";
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [errorMethods],
  components: {
    UserInfo
  },
  data() {
    return {
      user: "",
      userInstruments: [],
      loading: true
    }
  },
  methods: {
    getUser: function() {
      axios.get(
        `http://${g.hostName}/api/users/${this.$route.params.id}`
      )
      .then((response) => {
        this.user = response.data.user
        this.userInstruments = response.data.user_instruments
      })
      .catch((error) => {
        this.apiErrors(error.response.status);
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