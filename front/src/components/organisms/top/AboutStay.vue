<template>
  <div class="about-stay">
    <img src="/studio/studio5.jpg"/>
    <div class="stay-info">
      <div>
        <h3 class="stay-info--title top-each-title">STAY</h3>
        <div class="stay-info--explain">
          <p>宿泊可能なお部屋をご用意しております</p>
          <p>ご予約は下記から</p>
        </div>
        <router-link to="/stayrooms/?month=0" class="stay-info--link gorgeous-button">
          <p>予約はこちら</p>
          <fa icon="play-circle"></fa>
        </router-link>
      </div>
    </div>
  </div>
</template>

<style scoped lang="scss">
.about-stay {
  position: relative;
  img {
    width: 100%;
    min-height: 400px;
    vertical-align: bottom;
    filter: blur(3px);
  }
  .stay-info {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(160, 156, 156, 0.8);
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