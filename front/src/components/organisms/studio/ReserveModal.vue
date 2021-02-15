<template>
  <div id="overlay">
    <div class="reserve-container">
      <div @click="closeModal()" class="close-button">×</div>
      <template v-if="!reserveCompleteFlg">
        <h1 class="main-title text-center">スタジオ予約</h1>
        <ul class="error-messages">
          <li v-for="(error, i) in errorMessages.date" :key="i">
            {{ error }}
          </li>
          <li v-for="(error, j) in errorMessages.time" :key="j">
            {{ error }}
          </li>
          <li v-show="errorMessages.api!=''">{{errorMessages.api}}</li>
        </ul>
        <form v-on:submit.prevent="postStudioReserve()" class="reserve-form">
          <div class="reserve-form--date">
            <select v-model="selected.year" @change="changeDateTime()">
              <option v-for="year in selectYears" :key="year">{{ year }}</option>
            </select>
            年
            <select v-model="selected.month" @change="changeDateTime()">
              <option v-for="month in months" :key="month">{{ month }}</option>
            </select>
            月
            <select v-model="selected.day" @change="changeDateTime()">
              <option v-for="day in selectDays" :key="day">{{ day }}</option>
            </select>
            日
            <span>（{{ setWeeks }}）</span>
          </div>
          <div class="reserve-form--date">
            <select v-model="selected.start_hour" @change="changeDateTime()">
              <option v-for="hour in hours" :key="hour">{{ hour }}</option>
            </select>時
            <select v-model="selected.start_min" @change="changeDateTime()">
              <option v-for="min in mins" :key="min">{{ min }}</option>
            </select>分〜
            <select v-model="selected.end_hour" @change="changeDateTime()">
              <option v-for="hour in hours" :key="hour">{{ hour }}</option>
            </select>時
            <select v-model="selected.end_min" @change="changeDateTime()">
              <option v-for="min in mins" :key="min">{{ min }}</option>
            </select>分
          </div>
          <div class="reserve-form--fee">
            料金 : ¥{{ paymentFee }}
          </div>
          <div class="reserve-form--btn">
            <div @click="closeModal()" class="default-button back-btn">戻る</div>
            <button :disabled="disabledFlg" :class="{ 'reserve-disable': disabledFlg }" class="default-button reserve-btn">予約する</button>
          </div>
        </form>
      </template>
      <template v-else>
        <h1 class="main-title text-center">予約が完了しました</h1>
        <table class="reserve-result">
          <tr>
            <th>予約日時：</th>
            <td>
              {{ selected.year }} 年
              {{ selected.month }} 月 
              {{ selected.day }} 日 
              ({{ setWeeks }})
            </td>
          </tr>
          <tr>
            <th></th>
            <td>
              {{ selected.start_hour }} 時
              {{ ( '00' + selected.start_min ).slice( -2 ) }} 分 〜
              {{ selected.end_hour }} 時
              {{ ( '00' + selected.end_min ).slice( -2 ) }} 分
            </td>
          </tr>
          <tr>
            <th>料金：</th>
            <td>¥{{ paymentFee }}</td>
          </tr>
        </table>
        <div class="assist-message">
          ※キャンセルは「マイページ > スタジオ予約一覧」から可能です
        </div>
        <button @click="closeModal()" class="default-button back-btn">閉じる</button>
      </template>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import { commonMethods } from '@/mixins/commonMethods';
import { errorMethods } from '@/mixins/errorMethods';

var today = new Date();

export default {
  mixins: [commonMethods, errorMethods],
  props: {
    clickReserveProp: {},
    studioProp: {},
  },
  data() {
    return {
      reserveCompleteFlg: false,
      studioReserve: {
        data: "",
        hour: "",
        minutes: ""
      },
      months: [...Array(12).keys()].map(i => ++i),
      hours:  [...Array(25).keys()].map(i => i++),
      mins:   [0, 30],
      selected: {
        year:  this.clickReserveProp.date.substr(0, 4),
        month: Number(this.clickReserveProp.date.substr(5, 2)),
        day:   Number(this.clickReserveProp.date.substr(8, 2)),
        start_hour: this.clickReserveProp.hour,
        start_min:  this.clickReserveProp.minutes,
        end_hour: this.clickReserveProp.end_hour,
        end_min:  this.clickReserveProp.end_minutes
      },
      errorMessages: {
        date: [],
        time: [],
        api: ""
      },
      disabledFlg: false
    }
  },
  computed: {
    selectYears() {
      var year = Number(this.clickReserveProp.date.substr(0, 4));
      return [year, year+1];
    },
    selectDays() {
      var last_date = new Date(this.selected.year, this.selected.month, 0);
      var last_day = last_date.getDate();
      return [...Array(last_day).keys()].map(i => ++i)
    },
    setWeeks() {
      return this.calcWeek(this.selected.year + '-' +
                           ('00' + this.selected.month).slice( -2 ) + '-' +
                           ('00' + this.selected.day).slice( -2 ), 1);
    },
    paymentFee() {
      var sa = calcReserveTime(this.selected);
      if (sa <= 0) {
        sa = 0
      }
      return sa * this.studioProp.fee
    }
  },
  methods: {
    // モーダルウィンドウを閉じる
    closeModal: function() {
      this.reserveCompleteFlg = false;
      this.$emit('close-modal');
    },
    // スタジオ予約の実行
    postStudioReserve: function(){
      axios.post(
        `http://${g.hostName}/api/studios/${this.$route.params.id}/reserves`,
        {
          user_id: this.$store.getters["user/id"],
          studio_reserve: {
            date: this.selected.year + '-' + this.selected.month + '-' + this.selected.day,
            start_time: ('00' + this.selected.start_hour).slice( -2 ) + ':' + ('00' + this.selected.start_min).slice( -2 ),
            end_time:   ('00' + this.selected.end_hour).slice( -2 ) + ':' + ('00' + this.selected.end_min).slice( -2 )
          }
        },
        {
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then(() => {
        this.reserveCompleteFlg = true;
        this.$emit('reserve-success');
      })
      .catch((error) => {
        this.apiErrors(error.response.status);
        if (error.response.status === 401) {
          this.$store.dispatch(
            "flash/create",
            { message: error.response.data.error_message,
              type:    2
            }
          );
          this.$store.dispatch(
            "loginGuide/update", true
          );
        }
        else {
          this.errorMessages.api = error.response.data.error_message;
        }
      });
    },
    changeDateTime: function() {
      this.errorMessages.date = [];
      this.errorMessages.time = [];
      this.disabledFlg = false;
      var select_date = new Date(this.selected.year,
                                 this.selected.month-1,
                                 this.selected.day,
                                 23, 59, 59)
      var after_60date = new Date(today.getFullYear(),
                                  today.getMonth(),
                                  today.getDate()+60);
      if (select_date < today) {
        this.disabledFlg = true;
        this.errorMessages.date.push('予約日時が過ぎています');
      }
      else if (select_date > after_60date) {
        this.disabledFlg = true;
        this.errorMessages.date.push('予約日は60日以内にしてください');
      }
      var sa = calcReserveTime(this.selected);
      if (sa <= 0) {
        this.disabledFlg = true;
        this.errorMessages.time.push('終了時間は開始時間より後にしてください');
      }
      if (this.selected.end_hour == 24 && this.selected.end_min == 30) {
        this.disabledFlg = true;
        this.errorMessages.time.push('終了時刻は24:00までを選択してください');
      }
    }
  }
}
// 予約時間の計算
function calcReserveTime(selected) {
  var start = Number(selected.start_hour) + (Number(selected.start_min) / 60);
  var end = Number(selected.end_hour) + (Number(selected.end_min) / 60);
  return end - start
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
  h1 {
    margin-bottom: 30px;
  }
  .reserve-form {
    margin: 0 auto;
    width: 90%;
    text-align: center;
    select {
      border: none;
      outline: none;
      border-bottom: 2px solid;
      font-size: 20px;
    }
    &--date {
      margin: 10px;
    }
    &--time {
      margin: 10px;
    }
    &--fee {
      font-size: 20px;
      margin: 20px;
    }
    &--btn {
      display: flex;
      justify-content: space-between;
      margin-bottom: 30px;
      .reserve-btn {
        width: 150px;
      }
      .back-btn {
        width: 150px;
        color: #333;
        background: #FFF;
        box-sizing: border-box;
        border: 2px solid;
      }
      .reserve-disable {
        cursor: not-allowed;
        background: #888;
      }
    }
  }
  .reserve-result {
    margin: 0 auto;
    text-align: center;
    font-size: 18px;
    th {
      text-align: right;
    }
    td {
      text-align: left;
      padding: 1px;
    }
  }
  .assist-message {
    text-align: center;
    color: red;
    margin: 20px;
    font-size:  14px;
  }
}

@media screen and (max-width: 600px) {
  .reserve-container {
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