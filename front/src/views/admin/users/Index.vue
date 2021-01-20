<template>
  <div class="double-container">
    <div class="double-container--left">
      <SideBar :select-menu-prop="101"/>
    </div>
    <div class="double-container--right">
      <div class="user-index-container">
        <h1 class="main-title">登録ユーザ一覧</h1>
        <table>
          <tr>
            <th>ユーザ名</th>
            <th>メールアドレス</th>
            <th>管理者権限</th>
          </tr>
          <tr v-for="(user, i) in users" :key="i">
            <td>{{ user.name }}</td>
            <td>{{ user.email }}</td>
            <td v-if="user.admin_type > 0">あり</td>
          </tr>
        </table>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import SideBar from "@/components/SideBar.vue";

export default {
  components: {
    SideBar
  },
  data() {
    return {
      users: []
    }
  },
  methods: {
    getUsers: function(){
      axios.get(`http://${g.hostName}/api/admin/users`)
      .then((response) => {
        this.users = response.data;
      })
      .catch(function(error) {
        console.log(error);
      });
    }
  },
  mounted: function() {
    this.getUsers();
  }
}
</script>

<style scoped lang="scss">
.user-index-container {
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
  }
}
</style>