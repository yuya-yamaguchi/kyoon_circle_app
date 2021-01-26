<template>
  <transition name="fade-slow" appear>
    <div class="top-image-container">
      <img src="/studio/studio7.jpg">
      <h1 class="top-page-title">Kyo-ON</h1>
    </div>
  </transition>
</template>

<style scoped lang="scss">
.top-image-container {
  position: relative;
  img {
    width: 100%;
    opacity: 0.6;
    vertical-align: bottom;
    filter: drop-shadow(2px 2px 2px rgba(0,0,0,0.6));
  }
  .top-page-title {
    font-size: 50px;
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%,-50%);
    opacity: 0.8;
  }
}
</style>