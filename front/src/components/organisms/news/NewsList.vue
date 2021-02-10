<template>
  <div>
    <table>
      <tr v-for="(news, i) in newsProp" :key="i">
        <td class="post-date">{{ formatDate(news.created_at) }}</td>
        <td>
          <router-link :to="transLinks(news.id)" class="news-card">
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
    },
    transLinks: function(newsId) {
      return (location.pathname == '/news/editlist') ? `/news/${newsId}/edit` : `/news/${newsId}`
    }
  }
}
</script>

<style scoped lang="scss">
table {
  width: 95%;
  margin: 10px auto;
  tr {
    display: flex;
    justify-content: flex-start;
    border-bottom: 1px dotted #888;
    .post-date {
      white-space: nowrap;
    }
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