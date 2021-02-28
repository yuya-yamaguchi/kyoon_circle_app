<template>
  <div>
    <h1 class="main-title text-center">予約が完了しました</h1>
    <table class="reserve-result">
      <tr>
        <th>予約日時：</th>
        <td>
          {{ formatDate(studioReserve.date, 'YYYY年M月D日') }}
          ({{ calcWeek(studioReserve.date, 1) }})
        </td>
      </tr>
      <tr>
        <th></th>
        <td>
          {{ studioReserve.start_time.substr(11, 5) }} 〜
          {{ studioReserve.end_time.substr(11, 5) }}
        </td>
      </tr>
      <tr>
        <th>料金：</th>
        <td>¥{{ studioReserve.fee }}</td>
      </tr>
    </table>
    <div class="assist-message">
      ※キャンセルは「マイページ > スタジオ予約一覧」から可能です
    </div>
    <button @click="closeModal()" class="default-button back-btn">閉じる</button>
  </div>
</template>

<script>
import { commonMethods } from '@/mixins/commonMethods';

export default {
  mixins: [commonMethods],
  props: {
    studioReserve: {}
  },
  methods: {
    closeModal() {
      this.$emit('close-modal');
    },
  }
}
</script>

<style scoped lang="scss">
h1 {
    margin-bottom: 30px;
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
.back-btn {
  width: 150px;
  color: #333;
  background: #FFF;
  box-sizing: border-box;
  border: 2px solid;
}
.assist-message {
  text-align: center;
  color: red;
  margin: 20px;
  font-size:  14px;
}
</style>