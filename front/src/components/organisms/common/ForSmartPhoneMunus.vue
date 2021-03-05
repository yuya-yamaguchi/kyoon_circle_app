<template>
  <div id="overlay" @click="closeMenu()">
    <div class="hide-menus-container">
      <div class="menu-cards">
        <div v-if="$store.getters['user/id']">
          <div class="menu-card">
            <router-link to="/mypage" class="menu-top menu-link">
              こんにちは、{{ $store.getters['user/name'] }} さん
            </router-link>
          </div>
          <div class="menu-card">
            <router-link :to="{ name: 'MypageTop' }" class="menu-link some-updown-center">
              <fa icon="user" class="menu-link--icon"></fa>
              <div class="menu-link--title">
                マイページ
              </div>
            </router-link>
          </div>
          <div v-if="$store.getters['user/adminType']" class="menu-card">
            <router-link :to="{ name: 'AdminMenus' }" class="menu-link some-updown-center">
              <fa icon="user-cog" class="menu-link--icon"></fa>
              <div class="menu-link--title">
                管理メニュー
              </div>
            </router-link>
          </div>
          <div class="menu-card">
            <div @click="logout()" class="menu-link some-updown-center">
              <fa icon="sign-out-alt" class="menu-link--icon"></fa>
              <div class="menu-link--title">ログアウト</div>
            </div>
          </div>
        </div>
        <div v-else>
          <div class="menu-card">
            <router-link to="/signup" class="menu-link some-updown-center">
              <fa icon="user-plus" class="menu-link--icon"></fa>
              <div class="menu-link--title">新規会員登録</div>
            </router-link>
          </div>
          <div class="menu-card">
            <router-link to="/login" class="menu-link some-updown-center">
              <fa icon="sign-in-alt" class="menu-link--icon"></fa>
              <div class="menu-link--title">ログイン</div>
            </router-link>
          </div>
        </div>
      </div>
      <div class="menu-cards">
        <div v-for="menu in basicMenues" :key="menu" class="menu-card">
          <router-link :to="menu.path" class="menu-link some-updown-center">
            <fa v-if="menu.icon" :icon="menu.icon" class="menu-link--icon"></fa>
            <div class="menu-link--title">
              {{ menu.name }}
            </div>
          </router-link>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  methods: {
    logout: function() {
      this.$emit('logout');
    },
    closeMenu: function() {
      this.$emit('close-hide-menu');
    }
  },
  computed: {
    basicMenues() {
      let menus = [
        { name: "トップ",
          path: "/",
          icon: "mountain"
        },
        { name: "スタジオ予約",
          path: "/studios/1?week=0",
          icon: "microphone-alt"
        },
        { name: "イベント",
          path: "/events",
          icon: "calendar-alt"
        },
        { name: "宿泊予約",
          path: "/stayrooms?month=0",
          icon: "bed"
        },
        { name: "お知らせ",
          path: "/news",
          icon: "bell"
        }
      ]
      return menus;
    }
  }
}
</script>

<style scoped lang="scss">
#overlay {
  z-index: 999;
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0,0,0,0.5);
  display: flex;
  .hide-menus-container{
    z-index: 1000;
    height: 100%;
    width: 70%;
    background: var(--base-color);
    color: #333;
    overflow: scroll;
    .menu-cards {
      padding-bottom: 20px;
      background: lightgray;
      .top-message {
        font-weight: bold;
        font-size: 18px;
      }
      .menu-card {
        width: 100%;
        border-bottom: 1px solid #888;
        background: var(--base-color);
        .menu-link {
          display: flex;
          justify-content: flex-start;
          text-decoration: none;
          color: #333;
          padding: 10px 0 10px 10px;
          cursor: pointer;
          &:hover {
            background: #333;
            color: #FFF;
            opacity: .8;
            transition: .3s;
          }
          &--icon {
            display: block;
            width: 16px;
            height: 16px;
            margin-right: 10px;
          }
        }
        .menu-top {
          font-weight: bold;
        }
      }
    }
  }
}
</style>