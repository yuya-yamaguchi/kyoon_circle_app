<template>
  <div class="single-container">
    <div class="studio-reserve-container">
      {{ studio.name }}
      <h3 class="sub-title">予約表</h3>
      <table>
        <tr>
          <th></th>
          <th v-for="(week, w) in weeks" :key="w">
            {{ week }}
          </th>
        </tr>
        <tr v-for="(reserve, i) in reserves" :key="i">
          <td class="reserve-time">
            <span>{{ Math.floor(i/2) }}：</span>
            <span v-if="i%2==0">00</span>
            <span v-else>30</span>
          </td>
          <template v-for="(r, j) in reserve" :key="j">
            <td v-if="r.reserved_flg" class="already-reserved">×</td>
            <td v-else @click="postStudioReserve(r)"  class="can-reserve"></td>
          </template>
        </tr>
      </table>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

const hostName = 'localhost:3000';

export default {
  data() {
    return {
      studio: "",
      reserves: [],
      weeks: []
    }
  },
  methods: {
    getStudioStatus: function(){
      axios.get(
        `http://${hostName}/api/studios/${this.$route.params.id}`
      )
      .then((response) => {
        this.studio = response.data.studio;
        this.reserves = response.data.reserves;
        this.weeks = response.data.weeks;
      })
      .catch((error) => {
        console.log(error);
      });
    },
    postStudioReserve: function(reserve){
      axios.post(
        `http://${hostName}/api/studios/${this.$route.params.id}/reserves`,
        {
          user_id: this.$store.getters["user/id"],
          studio_reserve: {
            date: reserve.date,
            hour: reserve.hour,
            minutes: reserve.minutes
          }
        }
      )
      .then((response) => {
        console.log(response.data);
      })
      .catch((error) => {
        console.log(error);
      });
    }
  },
  mounted: function() {
    this.getStudioStatus();
  }
}
</script>

<style scoped lang="scss">
table {
  border: 1px solid;
}

th {
  border: 1px solid;
}

tr {
  border: 1px dotted;
}

.reserve-time {
  width: 45px;
  height: 20px;
  text-align: right;
  padding-right: 5px;
}

.can-reserve {
  border: 1px dotted;
  width: 40px;
  height: 20px;
  cursor: pointer;
  &:hover{
    background: rgb(90, 197, 224);
  }
}

.already-reserved {
  background: lightgray;
  color: #888;
  text-align: center;
}
</style>