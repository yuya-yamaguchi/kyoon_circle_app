<template>
  <div class="users-list-container">
    <h1 class="main-title">登録ユーザ一覧</h1>
    <div>
      <span>ユーザ数：</span>
      <span>{{ users.length }}</span>
    </div>
    <table class="users-table">
      <tr class="users-table--head">
        <th class="users-table--head--name">ユーザ名</th>
        <th class="users-table--head--email">メールアドレス</th>
        <th class="users-table--head--admin">管理権限</th>
      </tr>
      <tr v-for="(user, i) in users" :key="i">
        <td>
          <router-link :to="{name: 'UserShow', params: { id: user.id }}" class="user-link">
            {{ user.name }}
          </router-link>
        </td>
        <td>{{ user.email }}</td>
        <td>
          <span v-if="user.admin_type > 0">あり</span>
        </td>
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
  .users-table {
    &--head {
      th {
        padding: 10px 10px 10px 0;
        font-weight: bold;
        white-space: nowrap;
      }
      &--name {
        width: 30%;
      }
      &--email {
        width: 50%;
        overflow-wrap: break-all;
      }
      &--admin {
        width: 20%;
      }
    }
    td {
      padding: 10px;
      word-break : break-all;
    }
    .user-link {
      color: #2C3E50;
    }
  }
}
</style>