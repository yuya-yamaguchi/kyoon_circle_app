<template>
  <div id="overlay">
    <div class="reserve-container">
      <LoadingCircle v-if="reserving"/>
      <div @click="closeModal()" class="close-button">×</div>
      <div v-if="!reserved">
        <h1 class="main-title text-center">宿泊予約</h1>
        <div class="reserve-content">
          <table class="reserve-table">
            <tr>
              <td class="reserve-table--head">部屋</td>
              <td>{{ stayroomName }}</td>
            </tr>
            <tr>
              <td class="reserve-table--head">チェックイン</td>
              <td>
                <input type="date" v-model="stayroomReserve.checkin_date">
              </td>
            </tr>
            <tr>
              <td class="reserve-table--head">チェックアウト</td>
              <td>
                <input type="date" v-model="stayroomReserve.checkout_date">
              </td>
            </tr>
          </table>
          <div class="commit-back-btns">
            <CommitBackBtns
              @commit="postStayRoomReserves()"
              @back="closeModal()"
              :commitBtn="reserveBtn"/>
          </div>
        </div>
      </div>
      <div v-else>
        予約完了しました
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import LoadingCircle from '@/components/organisms/common/LoadingCircle.vue';
import CommitBackBtns from '@/components/molecules/common/CommitBackBtns.vue';

export default {
  props: {
    selectStayroomReserveProp: {},
    stayroomsProp: {}
  },
  components: {
    LoadingCircle,
    CommitBackBtns
  },
  data() {
    return {
      reserving: false,
      reserved: false,
      stayroomReserve: this.selectStayroomReserveProp,
      reserveBtn: {
        name: "予約する",
        isDisabled: false
      }
    }
  },
  computed: {
    stayroomName() {
      let roomName = ""
      this.stayroomsProp.some(( v ) => {
        if (v.id == this.stayroomReserve.stayroom_id) {
          roomName = v.name
        }
      })
      return (roomName) ? roomName : "指定なし"
    }
  },
  methods: {
    postStayRoomReserves: function() {
      axios.post(
        `http://${g.hostName}/api/stayrooms/${this.stayroomReserve.stayroom_id}/reserves`,
        {
          stayroom_reserve: this.stayroomReserve
        },
        {
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then(() => {
        this.reserved = true;
        this.$emit('reserve-complete');
      })
      .catch((error) => {
        console.log(error.response.data)
      });
    },
    // モーダルウィンドウを閉じる
    closeModal: function() {
      this.$emit('close-modal');
    }
  }
}
</script>

<style scoped lang="scss">
#overlay {
  z-index: 99;
  position:fixed;
  top:0;
  left:0;
  width:100%;
  height:100%;
  background-color:rgba(0,0,0,0.5);
  display: flex;
  align-items: center;
  justify-content: center;
}

.reserve-container {
  z-index: 2;
  width: 90%;
  max-width: 700px;
  margin: 0 auto;
  background: #FFF;
  position: relative;
  h1 {
    margin-bottom: 30px;
  }
  .reserve-content {
    margin: 0 auto;
    width: 70%;
    .reserve-table {
      margin: 0 auto;
      &--head {
        min-width: 150px;
        height: 40px;
      }
    }
    .commit-back-btns {
      margin: 30px 0;
    }
  }
}
</style>
