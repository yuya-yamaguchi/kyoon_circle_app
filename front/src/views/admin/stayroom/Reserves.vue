<template>
  <div>
    <BreadCrumbs :breadCrumbs="breadCrumbs"/>
    <div class="double-container">
      <div class="double-container--left">
        <SideBar :select-menu-prop="108"/>
      </div>
      <div class="double-container--right">
        <div class="studio-reserves-container">
          <StayroomCalendar :stayrooms-prop="stayrooms"/>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import SideBar from "@/components/organisms/common/SideBar.vue";
import StayroomCalendar from '@/components/organisms/stayroom/StayroomCalendar.vue';
import BreadCrumbs from "@/components/organisms/common/BreadCrumbs.vue";

export default {
  components: {
    SideBar,
    StayroomCalendar,
    BreadCrumbs
  },
  computed: {
    breadCrumbs() {
      const breadCrumbsLists = [
        { name: 'トップ',
          path: '/'
        },
        { name: '管理メニュー',
          path: '/admin'
        },
        { name: '宿泊予約確認',
          path: ''
        }
      ]
      return breadCrumbsLists
    }
  },
  data() {
    return {
      stayrooms: []
    }
  },
  methods: {
    getStayRooms: function() {
      axios.get(
        `http://${g.hostName}/api/stayrooms`
      )
      .then((response) => {
        this.stayrooms = response.data.stayrooms
      })
      .catch((error) => {
        this.apiErrors(error.response);
      });
    },
  },
  mounted() {
    this.getStayRooms();
  }
}
</script>

<style lang="scss" scoped>
.studio-reserves-container {
  width: 100%;
  margin: 0 auto;
}
</style>