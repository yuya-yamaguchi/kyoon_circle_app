<template>
  <div>
    <transition name="fade-default" appear>
      <ConfirmModal v-show="modalFlg"
        :modal-msg-prop="modalMsgProp"
        @process-confirm="postEvent"/>
    </transition>
    <form v-on:submit.prevent="displayConfirm()">
      <div class="form-item">
        <p class="form-item--name">イベントの種類</p>
        <select v-model="event.event_category_id" @change="eventTypeChk()">
          <option disabled value="">イベントの種類を選択して下さい</option>
          <option v-for="eventCategory in eventCategories" :value="eventCategory.id" :key="eventCategory.id">
            {{ eventCategory.name }}
          </option>
        </select>
        <div class="form-item--err-msg">{{errMsg.eventCategory}}</div>
      </div>
      <div class="form-item">
        <p class="form-item--name">イベント名</p>
        <input type="text" v-model="event.title" placeholder="イベント名" class="default-input" @blur="eventTitleChk()" @keyup="eventTitleChk()">
        <p class="form-item--err-msg">{{errMsg.title}}</p>
      </div>
      <div class="form-item">
        <p class="form-item--name">イベント内容</p>
        <textarea v-model="event.details" @blur="eventDetailsChk()" @keyup="eventDetailsChk()"></textarea>
        <div class="form-item--err-msg">{{errMsg.details}}</div>
      </div>
      <div class="form-item">
        <p class="form-item--name">開催日時</p>
        <input type="date" v-model="event.start_date" @change="eventDateChk()">
        <p class="form-item--err-msg">{{ errMsg.start_date }}</p>
        <div class="hold-time">
          <select v-model="event.start_hour">
            <option disabled value=""></option>
            <option v-for="hour in hours" :key="hour">{{ hour }}</option>
          </select>時
          <select v-model="event.start_min">
            <option disabled value=""></option>
            <option v-for="min in mins" :key="min">{{ ( '00' + min ).slice( -2 ) }}</option>
          </select>分 〜
          <select v-model="event.end_hour">
            <option value=""></option>
            <option v-for="hour in hours" :key="hour">{{ hour }}</option>
          </select>時
          <select v-model="event.end_min">
            <option value=""></option>
            <option v-for="min in mins" :key="min">{{ ( '00' + min ).slice( -2 ) }}</option>
          </select>分
        </div>
        <p class="form-item--err-msg">{{ errMsg.time }}</p>
      </div>
      <div class="form-item">
        <p class="form-item--name">場所</p>
        <input type="text" v-model="event.place" class="default-input" @blur="eventPlaceChk()" @keyup="eventPlaceChk()">
        <div class="form-item--err-msg">{{errMsg.place}}</div>
      </div>
      <div class="form-item">
        <p class="form-item--name">参加費</p>
        <input type="text" v-model="event.fee" class="default-input" @blur="eventFeeChk()" @keyup="eventFeeChk()">
        <div class="form-item--err-msg">{{errMsg.fee}}</div>
      </div>
      <div class="form-item">
        <p class="form-item--name">参加可能人数</p>
        <p class="form-item--addition">※0で登録した場合、参加可能人数は無制限になります</p>
        <input type="number" v-model="event.max_entry">
      </div>
      <div class="form-item" v-if="displayLinePush()">
        <p class="form-item--name">グループLINEへの通知</p>
        <p class="form-item--addition">※現在は開発用に作成したグループに通知されます</p>
        <input type="checkbox" id="lineMsgFlg" class="checkbox" v-model="event.line_msg_push">
        <label for="lineMsgFlg">通知する</label>
      </div>
      <button class="default-button">{{ modalMsgProp.btn }}</button>
    </form>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import ConfirmModal from "@/components/organisms/common/ConfirmModal.vue";
import { commonCheck } from '@/mixins/commonCheck';
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [commonCheck, errorMethods],
  components: {
    ConfirmModal
  },
  props: {
    eventProp: {},
    modalMsgProp: {}
  },
  data() {
    return {
      event: this.eventProp,
      modalFlg: false,
      errMsg: {},
      eventCategories: [],
      hours: [...Array(24).keys()].map(i => i++),
       mins: [...Array(6).keys()].map(i => i*=10),
    }
  },
  methods: {
    displayConfirm: function() {
      this.eventTypeChk();
      this.eventTitleChk();
      this.eventDetailsChk();
      this.eventDateChk();
      this.eventTimeChk();
      this.eventPlaceChk();
      this.eventFeeChk();
      // エラーがある場合、確認モーダルを表示しない
      for (var key in this.errMsg) {
        if (this.errMsg[key] != "") {
          return
        }
      }
      this.modalFlg = true
    },
    getEventCategories: function() {
      axios.get(
        `http://${g.hostName}/api/event_categories`
      )
      .then((response) => {
        this.eventCategories = response.data
      })
      .catch((error) => {
        this.apiErrors(error.response);
      });
    },
    postEvent: function(confirm) {
      this.modalFlg = false;
      // 確認モーダルで登録が押された場合、APIにデータをpost
      if (confirm) {
        this.$emit('post-event', this.event);
      }
    },
    displayLinePush: function() {
      return location.pathname == '/event/new' ? true : false
    },
    eventTypeChk: function() {
      let eventCategoryIds = []
      this.eventCategories.forEach(function(eventCategory) {
        eventCategoryIds.push(eventCategory.id)
      });
      if (!eventCategoryIds.includes(this.event.event_category_id)) {
        this.errMsg.eventCategory = "選択してください"
      }
      else {
        this.errMsg.eventCategory = ""
      }
    },
    eventTitleChk: function() {
      this.errMsg.title = this.formStrChk(this.event.title, 40);
    },
    eventDetailsChk: function() {
      this.errMsg.details = this.formStrChk(this.event.details, 1000);
    },
    eventDateChk: function() {
      this.errMsg.start_date = this.formStrChk(this.event.start_date, 0, "10");
      if (this.errMsg.start_date != "") return
      this.errMsg.start_date = this.isAfterToday(this.event.start_date);
    },
    eventTimeChk: function() {
      // 開始時刻チェック
      this.errMsg.time = this.formTimeChk(this.event.start_hour, this.event.start_min);
      if (this.errMsg.time != "") return
      // 時間か分の入力がある場合、終了時刻チェック
      if (this.event.end_hour != "" || this.event.end_min != "") {
        this.errMsg.time = this.formTimeChk(this.event.end_hour, this.event.end_min);
      }
      if (this.errMsg.time != "") return
      // 開始終了時刻の整合性チェック
      if (this.event.start_hour != "" && this.event.start_min != "" &&
          this.event.end_hour != ""   && this.event.end_min != "") {
        this.errMsg.time = this.startEndChk(this.event.start_hour, this.event.start_min,
                                            this.event.end_hour, this.event.end_min);
      }
    },
    eventPlaceChk: function() {
      this.errMsg.place = this.formStrChk(this.event.place, 100);
    },
    eventFeeChk: function() {
      this.errMsg.fee = this.formStrChk(this.event.fee, 10);
    }
  },
  mounted() {
    this.getEventCategories();
  }
}
</script>

<style scoped lang="scss">
.hold-time {
  margin-top: 10px;
}
</style>