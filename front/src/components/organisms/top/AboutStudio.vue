<template>
  <div class="about-studio">
    <img src="/studio/studio1.jpg"/>
    <div class="studio-info">
      <div>
        <h3 class="studio-info--title top-each-title">STUDIO</h3>
        <div class="studio-info--explain">
          <p>ライブやバンド練習にご利用できます</p>
          <p>24時間利用可能です</p>
          <p>ご予約は下記から</p>
        </div>
        <router-link to="/studios/1?week=0" class="studio-info--link gorgeous-button">
          <p>予約はこちら</p>
          <fa icon="play-circle"></fa>
        </router-link>
      </div>
    </div>
  </div>
</template>

<style scoped lang="scss">
.about-studio {
  position: relative;
  img {
    width: 100%;
    min-height: 400px;
    vertical-align: bottom;
    filter: blur(6px);
  }
  .studio-info {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.8);
    color: #FFF;
    display: flex;
    align-items: center;
    justify-content: center;
    &--explain {
      margin-top: 30px;
      margin-bottom: 60px;
      text-align: center;
      p {
        margin: 15px;
        font-weight: lighter;
      }
    }
    &--link {
      display: flex;
      align-items: center;
      justify-content: center;
      white-space: nowrap;
      text-align: center;
      width: 150px;
      svg {
        width: 20px;
        margin-left: 10px;
      }
    }
  }
  .top-each-title {
    font-size: 40px;
    font-weight: bold;
    text-align: center;
  }
}
</style>