<template>
  <div>
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
        </select>：
        <select v-model="selected.start_min" @change="changeDateTime()">
          <option v-for="min in mins" :key="min">{{ min }}</option>
        </select>〜
        <select v-model="selected.end_hour" @change="changeDateTime()">
          <option v-for="hour in hours" :key="hour">{{ hour }}</option>
        </select>：
        <select v-model="selected.end_min" @change="changeDateTime()">
          <option v-for="min in mins" :key="min">{{ min }}</option>
        </select>
      </div>
      <div class="reserve-form--users-num">
        利用人数：<input v-model="usersNum" type="number" @change="changeUsersNum()"> 人
      </div>
      <p class="form-item--err-msg">{{ errMsg.datetime }}</p>
      <p class="form-item--err-msg">{{ errMsg.usersNum }}</p>
      <div class="reserve-form--fee">
        <span>料金 : ¥{{ paymentFee }}</span>
        <span v-if="usersNum > 1">（1人あたり¥{{ paymentFee/usersNum }}）</span>
      </div>
      <div class="reserve-form--btn">
        <div @click="closeModal()" class="default-button back-btn">戻る</div>
        <button :disabled="disabledFlg" :class="{ 'reserve-disable': disabledFlg }" class="default-button reserve-btn">予約する</button>
      </div>
    </form>
  </div>
</template>

<script>
import { commonMethods } from '@/mixins/commonMethods';

export default {
  mixins: [commonMethods],
  props: {
    clickReserveProp: {},
    studioProp: {}
  },
  data() {
    return {
      months: [...Array(12).keys()].map(i => ++i),
      hours:  [...Array(25).keys()].map(i => i++),
      mins:   ['00', '30'],
      selected: {
        year:  this.clickReserveProp.date.substr(0, 4),
        month: Number(this.clickReserveProp.date.substr(5, 2)),
        day:   Number(this.clickReserveProp.date.substr(8, 2)),
        start_hour: this.clickReserveProp.hour,
        start_min:  this.zeroPadding(this.clickReserveProp.minutes, 2),
        end_hour: this.clickReserveProp.end_hour,
        end_min:  this.zeroPadding(this.clickReserveProp.end_minutes, 2)
      },
      errMsg: {},
      disabledFlg: false,
      reserving: false,
      studioReserve: {},
      usersNum: this.clickReserveProp.users_num
    }
  },
  computed: {
    selectYears() {
      let year = Number(this.selected.year);
      return [year, year+1];
    },
    selectDays() {
      var last_date = new Date(this.selected.year, this.selected.month, 0);
      var last_day = last_date.getDate();
      return [...Array(last_day).keys()].map(i => ++i)
    },
    setWeeks() {
      return this.calcWeek(this.selected.year + '-' +
                           this.zeroPadding(this.selected.month, 2) + '-' +
                           this.zeroPadding(this.selected.day, 2), 1);
    },
    paymentFee() {
      if (this.usersNum) {
        let sa = calcReserveTime(this.selected);
        let usersNum = this.usersNum;
        if (sa <= 0) sa = 0
        if (usersNum <= 0) usersNum = 0
        return sa * usersNum * this.studioProp.fee
      }
      return 0
    }
  },
  methods: {
    postStudioReserve: function() {
      let studioReserve = {}
      if (this.studioReserveValid()) {
        if(window.confirm('予約を確定します。よろしいですか？')) {
          studioReserve.date = this.selected.year + '-' + this.selected.month + '-' + this.selected.day;
          studioReserve.start_time = this.zeroPadding(this.selected.start_hour, 2) + ':' + this.zeroPadding(this.selected.start_min, 2)
          studioReserve.end_time = this.zeroPadding(this.selected.end_hour, 2) + ':' + this.zeroPadding(this.selected.end_min, 2)
          studioReserve.users_num = this.usersNum
          this.$emit('post-studio-reserve', studioReserve);
        }
      }
    },
    closeModal: function() {
      this.$emit('close-modal');
    },
    changeDateTime: function() {
      let today = new Date();
      let select_date = new Date(this.selected.year,
                                 this.selected.month-1,
                                 this.selected.day,
                                 23, 59, 59)
      let after_60date = new Date(today.getFullYear(),
                                  today.getMonth(),
                                  today.getDate()+60);
      if (select_date < today) {
        this.disabledFlg = true;
        this.errMsg.datetime = '予約日時が過ぎています';
        return
      }
      else if (select_date > after_60date) {
        this.disabledFlg = true;
        this.errMsg.datetime = '予約日は60日以内にしてください';
        return
      }
      let sa = calcReserveTime(this.selected);
      if (sa <= 0) {
        this.disabledFlg = true;
        this.errMsg.datetime = '終了時間は開始時間より後にしてください';
        return
      }
      if (this.selected.end_hour == 24 && this.selected.end_min == 30) {
        this.disabledFlg = true;
        this.errMsg.datetime = '終了時刻は24:00までを選択してください';
        return
      }
      this.disabledFlg = false;
      this.errMsg.datetime = "";
      return
    },
    changeUsersNum() {
      if (!this.usersNum) {
        this.errMsg.usersNum = '利用人数を入力してください';
        return false
      }
      else if (this.usersNum < 1) {
        this.errMsg.usersNum = '利用人数は0人以上で入力してください';
        return false
      }
      this.errMsg.usersNum = "";
      return true
    },
    studioReserveValid() {
      if (!this.changeUsersNum()) {
        return false
      }
      return true
    }
  }
}
// 予約時間の計算
function calcReserveTime(selected) {
  let start = Number(selected.start_hour) + (Number(selected.start_min) / 60);
  let end = Number(selected.end_hour) + (Number(selected.end_min) / 60);
  return end - start
}
</script>

<style scoped lang="scss">
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
  }
  &--date {
    margin: 10px;
  }
  &--time {
    margin: 10px;
  }
  &--users-num {
    margin: 10px;
    input {
      width: 50px;
      padding: 2px;
    }
  }
  &--fee {
    font-size: 1.1rem;
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

@media screen and (max-width: 700px) {
  .reserve-container {
    .reserve-form {
      select {
        // font-size: 16px;
      }
      &--btn {
        display: block;
      }
    }
  }
}
</style>