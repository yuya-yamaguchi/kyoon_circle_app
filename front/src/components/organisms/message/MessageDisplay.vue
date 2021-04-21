<template>
  <div>
    <div v-for="message in messagesProp" :key="message" class="message-block">
      <div v-if="message.user_id == $store.getters['user/id']" class="own-message">
        <div>
          <div class="block-right">
            <p class="own-message--text">
              {{ message.text }}
            </p>
          </div>
          <p class="own-message--datetime">
            {{ formatDate(message.created_at, 'YYYY年M月D日 HH24:MI:SS') }}
          </p>
        </div>
      </div>
      <div v-else class="other-message">
        <div class="other-message--avatar">
          <UserAvatar :avatarProp="dmUserProp.avatar"/>
        </div>
        <div class="other-message--body">
          <p class="other-message--body--text">
            {{ message.text }}
          </p>
          <p class="other-message--body--datetime">
            {{ formatDate(message.created_at, 'YYYY年M月D日 HH24:MI:SS') }}
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import UserAvatar from "@/components/atoms/UserAvatar.vue";
import { commonMethods } from '@/mixins/commonMethods';

export default {
  mixins: [commonMethods],
  components: {
    UserAvatar
  },
  props: {
    messagesProp: {},
    dmUserProp: {}
  }

}
</script>

<style scoped lang="scss">
.message-block {
  width: 100%;
  .own-message {
    margin: 20px;
    margin-left: auto;
    max-width: 60%;
    &--text {
      display: inline-block;
      padding: 10px;
      border-radius: 10px;
      background: #FFF;
      white-space: pre-wrap;
    }
    &--datetime {
      font-size: 0.8rem;
      color: #888;
      text-align: right;
    }
  }
  .other-message {
    margin: 20px;
    display: flex;
    justify-content: flex-start;
    &--avatar {
      width: 45px;
      height: 45px;
    }
    &--body {
      margin-left: 5px;
      &--text {
        padding: 10px;
        border-radius: 10px;
        background: #FFF;
      }
      &--datetime {
        font-size: 0.8rem;
        color: #888;
      }
    }
  }
}
.block-right {
  display: flex;
  justify-content: flex-end;
}
</style>