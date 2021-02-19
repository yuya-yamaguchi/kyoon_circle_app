<template>
  <div class="btns">
    <div @click="back()" class="default-button back-btn">
      戻る
    </div>
    <div
      @click="commit()"
      :disabled="commitBtn.isDisabled"
      :class="{ 'btn-disable': commitBtn.isDisabled }"
      class="default-button commit-btn">
      {{ commitBtn.name }}
    </div>
  </div>
</template>

<script>
export default {
  props: {
    commitBtn: {}
  },
  methods: {
    back() {
      this.$emit('back');
    },
    commit() {
      this.$emit('commit');
    }
  }
}
</script>

<style scoped lang="scss">
.btns {
  display: flex;
  justify-content: space-between;
  text-align: center;
  .commit-btn {
    width: 150px;
    box-sizing: border-box;
  }
  .back-btn {
    width: 150px;
    color: #333;
    background: #FFF;
    box-sizing: border-box;
    border: 2px solid;
  }
  .btn-disable {
    cursor: not-allowed;
    background: #888;
  }
}

@media screen and (max-width: 600px) {
  .btns {
    display: block;
  }
  .commit-btn {
    min-width: 80%;
  }
  .back-btn {
    min-width: 80%;
  }
}

</style>