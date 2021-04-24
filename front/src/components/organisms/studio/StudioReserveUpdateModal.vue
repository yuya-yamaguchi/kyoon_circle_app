<template>
  <div id="overlay">
    <div class="reserve-container">
      <LoadingCircle v-if="reserving"/>
      <div @click="closeModal()" class="close-button">×</div>
      <h1 class="main-title text-center">スタジオ予約変更</h1>
      <div class="error-messages">
        <ErrMsg/>
      </div>
      <StudioReserveForm
        :clickReserveProp="clickReserveProp"
        :studioProp="studio"
        @post-studio-reserve="postStudioReserve"
        @close-modal="closeModal"/>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import LoadingCircle from '@/components/organisms/common/LoadingCircle.vue';
import StudioReserveForm from '@/components/organisms/studio/StudioReserveForm.vue';
import ErrMsg from "@/components/organisms/common/ErrMsg.vue";
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [errorMethods],
  components: {
    LoadingCircle,
    StudioReserveForm,
    ErrMsg
  },
  props: {
    clickReserveProp: {}
  },
  data() {
    return {
      reserving: false,
      studioReserve: {},
      errMsg: "",
      studio: {}
    }
  },
  methods: {
    // モーダルウィンドウを閉じる
    closeModal: function() {
      this.$emit('close-modal');
    },
    // スタジオ予約の実行
    postStudioReserve: function(studioReserve){
      this.reserving = true;
      axios.put(
        `http://${g.hostName}/api/studios/1/reserves/${this.clickReserveProp.id}`,
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
          this.$emit('update-success', this.studioReserve);
          this.$store.dispatch(
            "flash/create",
            { message: "予約内容を変更しました",
              type:    1
            }
          );
        }, 1000)
      })
      .catch((error) => {
        this.reserving = false;
        this.apiErrors(error.response);
      })
    },
    getStudio: function(){
      axios.get(
        `http://${g.hostName}/api/studios/1`
      )
      .then((response) => {
        this.studio = response.data.studio;
      })
      .catch((error) => {
        this.apiErrors(error.response);
      });
    }
  },
  mounted() {
    this.getStudio();
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
        font-size: 0.9rem;
      }
      &--btn {
        display: block;
      }
    }
  }
}
</style>