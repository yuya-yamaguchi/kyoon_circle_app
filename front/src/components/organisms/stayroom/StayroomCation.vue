<template>
  <div class="stayroom-cation-container">
    <h1>使用上の注意</h1>
    <div class="stayroom-cations">
      <h3 class="stayroom-cations--title">使用後の掃除のお願い</h3>
      <ul class="stayroom-cations--contents">
        <li>・床をクイックルワイパーにて清掃をお願いします。</li>
        <li>・お風呂を使用した場合、排水溝の掃除をお願いします。</li>
        <li>・布団を整えてください。</li>
        <li>・ゴミは各自お持ち帰りください。</li>
        <li>・トイレの清掃をお願いします。</li>
        <li>・洗面所の清掃をお願いします。</li>
        <li>・清掃用具は宿泊部屋前の棚に入っています。（使用後は元の場所に戻すようお願いします。）</li>
      </ul>
    </div>
    <div class="stayroom-cations">
      <h3 class="stayroom-cations--title">鍵の管理について</h3>
      <ul class="stayroom-cations--contents">
        <li>・会長がいる場合は直接鍵を受け取ってください。</li>
        <li>・会長がいない場合は管理人室ポストから鍵を受け取ってください。</li>
        <li>・帰宅時、鍵は管理人ポストに入れてください。</li>
      </ul>
    </div>
  </div>
</template>

<style scoped lang="scss">
.stayroom-cation-container {
  background: rgb(247, 234, 234);
  color: #888;
  border-radius: 10px;
  padding: 10px;
  .stayroom-cations {
    margin: 10px 0 0 10px;
    &--title {
      font-size: 0.8rem;
      text-decoration: underline;
    }
    &--contents {
      font-size: 0.7rem;
    }
  }
}
</style>