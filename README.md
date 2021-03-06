<img src="https://www.ruby-lang.org/images/header-ruby-logo@2x.png" width="80" style="max-width:100%;"><img src="https://camo.githubusercontent.com/fb3c0ba1d4429fadfcc57570b9d09d6ccfa3485d/687474703a2f2f69322e77702e636f6d2f73616d616e6368612e636f6d2f77702d636f6e74656e742f75706c6f6164732f323031372f31322f7261696c732e706e673f6669743d363030253243363030" width="80" data-canonical-src="http://i2.wp.com/samancha.com/wp-content/uploads/2017/12/rails.png?fit=600%2C600"><img src="https://jp.vuejs.org//images/logo.png" width="80"><img src="https://a0.awsstatic.com/libra-css/images/site/touch-icon-iphone-114-smile.png" width="80"><img src="https://camo.githubusercontent.com/e0e3e4ad47134bff0f4d1f01c8e0882b2240c486/68747470733a2f2f7777772e6d7973716c2e636f6d2f636f6d6d6f6e2f6c6f676f732f6c6f676f2d6d7973716c2d313730783131352e706e67" width="80" data-canonical-src="https://www.mysql.com/common/logos/logo-mysql-170x115.png" style="max-width:100%;">
<img src="https://www.docker.com/sites/default/files/d8/styles/role_icon/public/2019-07/Docker-Logo-White-RGB_Vertical-BG_0.png?itok=8Tuac9I3" width="80">

# 使用技術
### フロントエンド
* Vue 3.0
* Vue/CLI 4.5
* <a href="https://github.com/yuya-yamaguchi/kyoon_circle_app/tree/master/front">使用プラグインはfrontのREADMEに記載</a>

### バックエンド
* Ruby 2.7.2
* Rails 6.0.3 (APIモードで使用)
* <a href="https://github.com/yuya-yamaguchi/kyoon_circle_app/tree/master/api">使用GemfileはapiのREADMEに記載</a>

### DB、インフラ
* MySQL 5.7
* Docker 19.03.4
* Docker-compose 3
* AWS (EC2, ALB, Route53)

# サイトURL
<a href="http://studio-hummingbird.com/" target="_blank" rel="noopener noreferrer">http://studio-hummingbird.com/</a>

# サイト概要
京都で活動している音楽サークルの専用サイト<br>
サークルの代表が所有しているスタジオの予約、イベントの開催などをWebにて取りまとめられるようにするため作成。

# 機能一覧
⚫︎はログイン時使用可能な機能
★は管理者が使用可能な機能
### 認証
* ・新規会員登録
* ・ログイン
* ⚫︎ログアウト
* ⚫︎パスワード変更
* ・パスワード失念時の再設定
### お知らせ
* ・お知らせ一覧表示
* ・お知らせ詳細表示
* ★お知らせ新規登録(LINE通知)
* ★お知らせ編集、削除
### イベント
* ・イベント一覧表示
* ・イベント詳細表示
* ⚫︎イベントへの参加、キャンセル
* ⚫︎参加したイベントの確認
* ⚫︎イベントへのコメント（編集、削除可）
* ★イベント新規登録(LINE通知)
* ★イベント編集、削除
### スタジオ
* ・スタジオ詳細表示
* ⚫︎スタジオ予約、キャンセル
* ⚫︎予約したスタジオの確認
* ★スタジオ情報の編集

# 初期セットアップ（環境構築）
### 前提
* 開発端末にDockerがインストールされていること

### 手順１
* 開発端末にgit cloneする
```
git clone https://github.com/yuya-yamaguchi/kyoon_circle_app.git
```
* クローンしたディレクトリに移動
```
cd kyoon_circle_app
```
* .sec_envファイルの作成
```
touch ./api/.sec_env
```
* Dockerコンテナをビルド
```
docker-compose build
```

### 手順２：バックエンド側（API側）
* DBの作成
```
docker-compose run web rails db:create
rm .//api/db/migrate/20210122213320_drop_table_user_reserves.rb
docker-compose run web rails db:migrate
```
* 初期データの設定
```
docker-compose run web rails db:seed
docker-compose run web rails r db/seeds/v1.1/instrument.rb
docker-compose run web rails r db/seeds/v1.2/part_categories.rb
docker-compose run web rails r db/seeds/v1.2/part_categories.rb
docker-compose run web rails r db/seeds/v1.3/stayroom.rb
```

### 手順3：フロント側
* フロントコンテナ内にアクセス
```
docker-compose run front sh
```
* vue-routerをインストール
```
npm install vue-router
```
* vue-vuexをインストール
```
npm install vuex
```
* vuex-persistedstateをインストール
```
npm install vuex-persistedstate
```
* axiosをインストール
```
npm install axios
```
* sass-loaderをインストール
```
npm install sass-loader node-sass --save-dev
```
* momentをインストール
```
npm install moment
```
* fontawesomeをインストール
```
npm i --save @fortawesome/fontawesome-svg-core
npm i --save @fortawesome/free-solid-svg-icons
npm i --save @fortawesome/free-brands-svg-icons
npm i --save @fortawesome/vue-fontawesome@3.0.0-1
```

### 手順4
* 初期セットアップの変更を対比（暫定）
```
git stash
```

### ゲストログインを有効にする場合
* 下記内容でユーザを新規登録する

|  email  |  password  |
| ------- | ---------- |
|  	normal@example.com  |  12345678  |
