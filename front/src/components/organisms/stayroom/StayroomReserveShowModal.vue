<template>
  <div id="overlay">
    <div class="reserve-show-container">
      <div @click="closeModal()" class="close-button">×</div>
      <h1 class="main-title text-center">予約内容</h1>
      <div class="error-messages">
        <ErrMsg/>
      </div>
      <table class="reserve-info">
        <tr>
          <th>予約者</th>
          <td>
            <router-link :to="{name: 'UserShow', params: { id: stayroomReserve.user_id }}" class="link-return">
              {{stayroomReserve.user_name}}
            </router-link>
          </td>
        </tr>
        <tr>
          <th>部屋名</th>
          <td>
            {{ stayroomReserve.room_name }}
          </td>
        </tr>
        <tr>
          <th>チェックイン</th>
          <td>
            {{ formatDate(stayroomReserve.checkin_date,  'YYYY年M月D日') }}
          </td>
        </tr>
        <tr>
          <th>チェックアウト</th>
          <td>
            {{ formatDate(stayroomReserve.checkout_date, 'YYYY年M月D日') }}
          </td>
        </tr>
        <tr>
          <th>料金</th>
          <td>{{ stayroomReserve.fee}}円</td>
        </tr>
      </table>
      <div class="btns">
        <div @click="deleteStayroomReserve(stayroomReserve)" class="default-button delete-button">
          取消
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import ErrMsg from "@/components/organisms/common/ErrMsg.vue";
import { commonMethods } from '@/mixins/commonMethods';
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [commonMethods, errorMethods],
  components: {
    ErrMsg
  },
  props: {
    stayroomReserveProp: {}
  },
  data() {
    return {
      stayroomReserve: {}
    }
  },
  methods: {
    getStayroomReserve: function() {
      axios.get(
        `http://${g.hostName}/api/stayrooms/${this.stayroomReserveProp.stayroom_id}/reserves/${this.stayroomReserveProp.id}`,
        {
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then((response) => {
        this.stayroomReserve = response.data.stayroom_reserve
      })
      .catch((error) => {
        this.apiErrors(error.response);
      });
    },
    deleteStayroomReserve: function(stayroomReserve) {
      if(window.confirm('この宿泊予約を取り消します。よろしいですか？')) {
        axios.delete(
          `http://${g.hostName}/api/stayrooms/${stayroomReserve.stayroom_id}/reserves/${stayroomReserve.id}`,
          {
            headers: {
              Authorization: this.$store.getters['user/secureToken']
            }
          }
        )
        .then(() => {
          this.$store.dispatch(
            "flash/create",
            { message: "取消が完了しました",
              type:    1
            }
          );
          this.$emit('update-stayroom-reserves');
          this.$emit('close-modal');
        })
        .catch((error) => {
          this.apiErrors(error.response);
        });
      }
    },
    // モーダルウィンドウを閉じる
    closeModal: function() {
      this.$emit('close-modal');
    }
  },
  mounted() {
    this.getStayroomReserve();
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
.reserve-show-container {
  z-index: 2;
  width: 90%;
  max-width: 700px;
  margin: 0 auto;
  background: #FFF;
  position: relative;
  .reserve-info {
    margin: 20px auto;
    tr {
      display: block;
      margin: 5px;
      th {
        min-width: 120px;
      }
    }
  }
  .btns {
    margin: 0 auto;
    .delete-button {
      max-width: 200px;
    }
  }
}
.err-msg {
  width: 90%;
  margin: 0 auto;
}

@media screen and (max-width: 600px) {
  .reserve-show-container {
    .reserve-form {
      select {
        font-size: 16px;
      }
      &--btn {
        display: block;
      }
    }
  }
}
</style>