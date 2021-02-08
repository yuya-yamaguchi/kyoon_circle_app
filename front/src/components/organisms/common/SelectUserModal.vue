<template>
  <div id="overlay">
    <div class="select-user-modal-container">
      <button @click="closeModal()" class="close-button">×</button>
      <h1>ユーザを選択</h1>
      <div class="select-users">
        <select v-model="selectUser">
          <option disabled value="">ユーザを選択してください</option>
          <option v-for="user in usersProp" :value="user" :key="user">
            {{ user.name }}
          </option>
        </select>
        <div class="select-users--err-msg">{{ errMsg }}</div>
      </div>
      <div class="btn-area">
        <button @click="closeModal()" class="default-button back-btn">戻る</button>
        <button @click="postEntryPart()" class="default-button confirm-btn">登録</button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    usersProp: {}
  },
  data() {
    return {
      selectUser: "",
      errMsg: ""
    }
  },
  methods: {
    postEntryPart: function() {
      if (this.selectUser) {
        this.$emit('post-entry-part', this.selectUser)
        this.$emit('close-modal')
      }
      else {
        this.errMsg = "選択してください"
      }
    },
    closeModal: function() {
      this.$emit('close-modal')
    }
  }
}
</script>

<style scoped lang="scss">
#overlay {
  z-index: 99;
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0,0,0,0.5);
  display: flex;
}

.select-user-modal-container {
  z-index: 2;
  width: 70%;
  margin: 0 auto;
  background: #FFF;
  max-width: 700px;
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%,-50%);
  h1 {
    margin: 30px;
    font-weight: bold;
    font-size: 24px;
    text-align: center;
  }
  .select-users {
    margin: 20px auto;
    min-width: 200px;
    select {
      display: block;
      margin: 0 auto;
      border: none;
      outline: none;
      border-bottom: 1px solid;
    }
    &--err-msg {
      margin: 3px auto;
      font-size: 14px;
      color: red;
      text-align: center;
    }
  }
  .btn-area {
    display: flex;
    justify-content: space-between;
    margin-bottom: 30px;
    .confirm-btn {
      width: 140px;
    }
    .back-btn {
      width: 140px;
      color: #333;
      background: #FFF;
    }
  }
}
</style>