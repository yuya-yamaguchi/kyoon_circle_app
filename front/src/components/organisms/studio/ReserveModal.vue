<template>
  <div id="overlay">
    <div class="reserve-container">
      <LoadingCircle v-if="reserving"/>
      <div @click="closeModal()" class="close-button">×</div>
      <template v-if="!isReserved">
        <h1 class="main-title text-center">スタジオ予約</h1>
        <div class="error-messages">
          <ErrMsg/>
        </div>
        <StudioReserveForm
          :clickReserveProp="clickReserveProp"
          :studioProp="studioProp"
          @post-studio-reserve="postStudioReserve"
          @close-modal="closeModal"/>
      </template>
      <template v-else>
        <StudioReserveComplete
          :studioReserve="studioReserve"
          @close-modal="closeModal"/>
      </template>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import LoadingCircle from '@/components/organisms/common/LoadingCircle.vue';
import StudioReserveForm from '@/components/organisms/studio/StudioReserveForm.vue';
import StudioReserveComplete from '@/components/organisms/studio/StudioReserveComplete.vue';
import ErrMsg from "@/components/organisms/common/ErrMsg.vue";
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [errorMethods],
  components: {
    LoadingCircle,
    StudioReserveForm,
    StudioReserveComplete,
    ErrMsg
  },
  props: {
    clickReserveProp: {},
    studioProp: {}
  },
  data() {
    return {
      isReserved: false,
      reserving: false,
      studioReserve: {},
      errMsg: ""
    }
  },
  methods: {
    // モーダルウィンドウを閉じる
    closeModal: function() {
      this.isReserved = false;
      this.$emit('close-modal');
    },
    // スタジオ予約の実行
    postStudioReserve: function(studioReserve){
      this.reserving = true;
      axios.post(
        `http://${g.hostName}/api/studios/${this.$route.params.id}/reserves`,
        {
          user_id: this.$store.getters["user/id"],
          studio_reserve: studioReserve
        },
        {
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then((response) => {
        this.studioReserve = response.data.studio_reserve;
        setTimeout(() => {
          this.reserving = false;
          this.isReserved = true;
          this.$emit('reserve-success');
        }, 1500)
      })
      .catch((error) => {
        this.reserving = false;
        console.log(error.response.data)
        this.apiErrors(error.response);
      })
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
}
.err-msg {
  width: 90%;
  margin: 0 auto;
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