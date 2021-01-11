<template>
  <div>
    <table>
      <tr v-for="(news, i) in newsProp" :key="i">
        <td>{{ formatDate(news.created_at) }}</td>
        <td>
          <router-link :to="`/news/${news.id}`" class="news-card">
            {{ news.title }}
          </router-link>
        </td>
      </tr>
    </table>
  </div>
</template>

<script>
export default {
  props: {
    newsProp: {}
  },
  methods: {
    formatDate: function(createdAt) {
      var date = Number(createdAt.substr(0, 4)) + '年' + Number(createdAt.substr(5, 2)) + '月' + Number(createdAt.substr(8, 2)) + '日'
      return date
    }
  }
}
</script>

<style scoped lang="scss">
table {
  width: 95%;
  margin: 10px auto;
  tr {
    display: block;
    border-bottom: 1px dotted #888;
    td {
      display: inline-block;
      margin: 5px 10px;
      a {
        text-decoration: none;
        color: #333;
      }
      a:hover {
        opacity: 0.7;
      }
    }
  }
  
}

</style>