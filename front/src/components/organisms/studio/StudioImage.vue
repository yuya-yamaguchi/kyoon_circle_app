<template>
  <div class="studio-top">
    <img src="/studio/studio7.jpg">
    <div class="studio-info">
      <div>
        <h1>STUDIO</h1>
        <div class="studio-info--introduce">
          <p>24時間利用可能なスタジオです。30分からご予約いただけます。</p>
          <p>バンド練習、個人練習などににご利用ください。</p>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped lang="scss">
.studio-top {
  position: relative;
  padding-top: 40px;
  max-width: 1200px;
  margin: 0 auto;
  img {
    width: 100%;
    min-height: 350px;
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
</style>