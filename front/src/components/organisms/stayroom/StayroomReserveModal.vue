<template>
  <div id="overlay">
    <div class="reserve-container">
      <LoadingCircle v-if="reserving"/>
      <div @click="closeModal()" class="close-button">×</div>
      <div v-if="!reserved">
        <h1 class="main-title text-center">宿泊予約</h1>
        <div>{{ errors }}</div>
        <div class="reserve-content">
          <table class="reserve-table">
            <tr>
              <td class="reserve-table--head">部屋</td>
              <td>{{ stayroomName(stayroomReserve.stayroom_id) }}</td>
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
        <h1 class="main-title text-center">予約が完了しました</h1>
        <table class="reserve-table">
          <tr>
            <td class="reserve-table--head">部屋</td>
            <td>{{ stayroomName(stayroomReserved.stayroom_id) }}</td>
          </tr>
          <tr>
            <td class="reserve-table--head">チェックイン</td>
            <td>
              {{ stayroomReserved.checkin_date }}
            </td>
          </tr>
          <tr>
            <td class="reserve-table--head">チェックアウト</td>
            <td>
              {{ stayroomReserved.checkout_date }}
            </td>
          </tr>
        </table>
        <button @click="closeModal()" class="default-button back-btn">閉じる</button>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import LoadingCircle from '@/components/organisms/common/LoadingCircle.vue';
import CommitBackBtns from '@/components/molecules/common/CommitBackBtns.vue';
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [errorMethods],
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
      stayroomReserved: {},
      reserveBtn: {
        name: "予約する",
        isDisabled: false
      },
      errors: ""
    }
  },
  methods: {
    postStayRoomReserves: function() {
      this.reserving = true;
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
      .then((response) => {
        setTimeout(() => {
          this.stayroomReserved = response.data.stayroom_reserve;
          this.reserving = false;
          this.reserved = true;
          this.$emit('reserve-complete');
        }, 1500)
      })
      .catch((error) => {
        this.errors = error.response.data
        this.apiErrors(error.response);
      });
    },
    stayroomName(stayroom_id) {
      let roomName = ""
      this.stayroomsProp.some(( v ) => {
        if (v.id == stayroom_id) {
          roomName = v.name
        }
      })
      return (roomName) ? roomName : "指定なし"
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
    .commit-back-btns {
      margin: 30px 0;
    }
  }
  .reserve-table {
    margin: 0 auto;
    &--head {
      min-width: 150px;
      height: 40px;
    }
  }
  .back-btn {
    background: #FFF;
    color: #333;
  }
}
</style>
