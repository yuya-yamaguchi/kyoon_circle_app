<template>
  <div>
    <Loading v-if="loading"/>
    <div v-else class="studio-content">
      <table>
        <tr>
          <th>料金</th>
          <td>
            ¥{{ studio.fee }}（1時間1人あたり）<br>
            <p class="addition-message">※30分から予約可</p>
          </td>
        </tr>
        <tr>
          <th>機材</th>
          <td>
            <ul>
              <li>Marshall JCM2000</li>
              <li>Roland JC-120</li>
              <li>HARTKE HA2500+HX810</li>
              <li>CANOPUS Japanese Sword</li>
            </ul>
          </td>
        </tr>
      </table>
      <div class="studio-content--caution">
        ※ 本日から60日後までご予約いただけます<br>
        ※ キャンセルは「マイページ > スタジオ予約確認」から可能です（開始日時を過ぎた場合、取消できません）<br>
        ※ お支払いは現地にてお願いします。予約時点でのお支払いは不要です
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import Loading from '@/components/organisms/common/Loading.vue';
import { commonMethods } from '@/mixins/commonMethods';
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [commonMethods, errorMethods],
  components: {
    Loading
  },
  data() {
    return {
      studio: "",
      loading: true
    }
  },
  methods: {
    getStudio: function(){
      axios.get(
        `http://${g.hostName}/api/studios/${this.$route.params.id}`
      )
      .then((response) => {
        this.studio = response.data.studio;
        this.loading = false;
      })
      .catch((error) => {
        this.apiErrors(error.response);
      });
    }
  },
  mounted: function() {
    this.getStudio();
  }
}
</script>

<style scoped lang="scss">
.studio-content {
  display: flex;
  justify-content: space-between;
  table {
    width: 50%;
    border: 1px solid #333;
    th {
      border-bottom: 1px solid #FFF;
      padding: 10px;
      background: #333;
      color: #FFF;
    }
    td {
      border: 1px solid;
      padding: 10px;
      font-size: 0.9rem;
      line-height: 24px;
    }
  }
  &--caution {
    background: rgb(247, 234, 234);
    border-radius: 10px;
    padding: 10px;
    margin-left: 20px;
    font-size: 0.8rem;
  }
}

@media screen and (max-width: 600px) {
  .studio-content {
    display: block;
    table {
      width: 100%;
    }
    &--caution {
      margin: 20px 0 0 0;
    }
  }
}
</style>