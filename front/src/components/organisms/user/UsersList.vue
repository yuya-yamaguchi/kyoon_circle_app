<template>
  <div class="users-list-container">
    <h1 class="main-title">登録ユーザ一覧</h1>
    <table>
      <tr>
        <th>ユーザ名</th>
        <th>メールアドレス</th>
        <th>管理権限</th>
      </tr>
      <tr v-for="(user, i) in users" :key="i">
        <td>
          <router-link :to="{name: 'UserShow', params: { id: user.id }}" class="user-link">
            {{ user.name }}
          </router-link>
        </td>
        <td>{{ user.email }}</td>
        <td v-if="user.admin_type > 0">あり</td>
      </tr>
    </table>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [errorMethods],
  data() {
    return {
      users: []
    }
  },
  methods: {
    getUsers: function(){
      axios.get(
        `http://${g.hostName}/api/admin/users`
      )
      .then((response) => {
        this.users = response.data;
      })
      .catch((error) => {
        this.apiErrors(error.response);
      });
    }
  },
  mounted: function() {
    this.getUsers();
  }
}
</script>

<style scoped lang="scss">
.users-list-container {
  width: 100%;
  margin: 0 auto;
  padding: 20px 0;
  background: #FFF;
  h1 {
    margin: 0 0 20px 20px;
  }
  table {
    margin: 10px 0 30px 30px;
    th {
      padding: 10px 30px 10px 0;
      font-weight: bold;
    }
    td {
      padding: 10px 30px 10px 0;
    }
    .user-link {
      color: #2C3E50;
    }
  }
}

@media screen and (max-width: 600px) {
  .users-list-container {
    background: var(--base-color);
  }
}
</style>