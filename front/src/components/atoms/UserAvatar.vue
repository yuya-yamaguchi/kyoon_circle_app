<template>
  <div class="avatar-container">
    <img v-if="avatarProp" :src="avatarProp">
    <img v-else src="/person.png">
  </div>
</template>

<script>
export default {
  props: {
    avatarProp: {}
  }
}
</script>

<style scoped lang="scss">
.avatar-container {
  width: 100%;
  height: 100%;
  img {
    display: block;
    border: 1px solid #333;
    border-radius: 100%;
    width: 100%;
    height: 100%;
    object-fit: cover;
    background: rgb(223, 230, 240);
    box-sizing: border-box;
  }
}
</style>