<template>
  <div>
    <BreadCrumbs :breadCrumbs="breadCrumbs"/>
    <div class="studio-top">
      <img src="/studio/studio7.jpg">
      <div class="studio-info">
        <div>
          <h1>{{ studio.name }}</h1>
          <div class="studio-info--introduce">
            <p>24時間利用可能なスタジオです。30分からご予約いただけます。</p>
            <p>バンド練習、個人練習などににご利用ください。</p>
          </div>
        </div>
      </div>
    </div>
    <Loading v-if="loading"/>
    <div v-else class="studio-container">
      <div class="studio-explain">
        <table>
          <tr>
            <th>料金</th>
            <td>
              ¥{{ studio.fee }}（1 Hour）<br>
              （30分単位で予約可）
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
        <div class="studio-explain--caution">
          ※ 本日から60日後までご予約いただけます<br>
          ※ キャンセルは「マイページ > スタジオ予約一覧」から可能です（開始日時を過ぎた場合、取消できません）<br>
          ※ お支払いは現地にてお願いします。予約時点でのお支払いは不要です
        </div>
      </div>
      <StudioReservesTable :admin-prop="0"/>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import Loading from '@/components/Loading.vue';
import BreadCrumbs from "@/components/BreadCrumbs.vue";
import StudioReservesTable from "@/components/StudioReservesTable.vue";
import { commonMethods } from '@/mixins/commonMethods';
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [commonMethods, errorMethods],
  components: {
    // ReserveModal,
    Loading,
    BreadCrumbs,
    StudioReservesTable
  },
  data() {
    return {
      studio: "",
      loading: true
    }
  },
  computed: {
    breadCrumbs() {
      var breadCrumbsLists = [
        {
          name: 'トップ',
          path: '/'
        },
        {
          name: 'スタジオ',
          path: ''
        }
      ]
      return breadCrumbsLists
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
        this.apiErrors(error.response.status);
      });
    }
  },
  mounted: function() {
    this.getStudio();
  }
}
</script>

<style scoped lang="scss">
.studio-top {
  position: relative;
  padding-top: 40px;
  img {
    width: 100%;
    vertical-align: bottom;
    filter: blur(2px);
  }
  .studio-info {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.3);
    color: #FFF;
    display: flex;
    align-items: center;
    justify-content: center;
    h1 {
      text-align: center;
      font-size: 50px;
      font-weight: bold;
    }
    &--introduce {
      margin-top: 30px;
      text-align: center;
      p {
        margin: 15px;
        font-weight: lighter;
      }
    }
  }
}
.studio-container {
  margin: 40px 10px 0 10px;
  .studio-explain {
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
        font-size: 16px;
        line-height: 24px;
      }
    }
    &--caution {
      background: rgb(247, 234, 234);
      border-radius: 10px;
      padding: 10px;
      margin-left: 20px;
      font-size: .8rem;
    }
  }
}
</style>