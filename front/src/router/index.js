import { createRouter, createWebHistory } from 'vue-router'
import Top from '@/views/Top.vue'
import Signup from '@/views/auth/Signup.vue'
import Login from '@/views/auth/Login.vue'
import ForgetPassword from '@/views/auth/ForgetPassword.vue'
import ResetPassword from '@/views/auth/ResetPassword.vue'
import FirstIntroduction from '@/views/introduction/FirstIntroduction.vue'
import StudioShow from '@/views/studio/Show.vue'
import UserShow from '@/views/user/Show.vue'
import MypageTop from '@/views/mypage/MypageTop.vue'
import MypageEdit from '@/views/mypage/Edit.vue'
import MypageStudioReserves from '@/views/mypage/StudioReserves.vue'
import MypageEvents from '@/views/mypage/Events.vue'
import MypageStayrooms from '@/views/mypage/Stayrooms.vue'
import MypageMessages from '@/views/mypage/Messages.vue'
import Settings from '@/views/mypage/Settings.vue'
import ChangeEmail from '@/views/mypage/ChangeEmail.vue'
import ChangePassword from '@/views/mypage/ChangePassword.vue'
import Follow from '@/views/user/Follow.vue'
import MessageShow from '@/views/user/message/Show.vue'
import EventNew from '@/views/event/New.vue'
import AdminMenus from '@/views/admin/AdminMenus.vue'
import EventEdit from '@/views/event/Edit.vue'
import EventEditList from '@/views/event/EditList.vue'
import EventIndex from '@/views/event/Index.vue'
import EventShow from '@/views/event/Show.vue'
import StayroomIndex from '@/views/stayroom/Index.vue'
import SessionMusicShow from '@/views/event/session/music/Show.vue'
import UsersIndex from '@/views/admin/users/Index.vue'
import StudioEdit from '@/views/admin/studio/Edit.vue'
import StudioReserves from '@/views/admin/studio/Reserves.vue'
import StayroomReserves from '@/views/admin/stayroom/Reserves.vue'
import NewsNew from '@/views/news/New.vue'
import NewsIndex from '@/views/news/Index.vue'
import NewsShow from '@/views/news/Show.vue'
import NewsEdit from '@/views/news/Edit.vue'
import NewsEditList from '@/views/news/EditList.vue'
// import Musics from '@/views/Musics.vue'
import NotFound from "@/views/errors/NotFound.vue";

import store from '@/store'

const routes = [
  // トップページ
  {
    path: '/',
    name: 'Top',
    component: Top
  },
  // 新規会員登録
  {
    path: '/signup',
    name: 'Signup',
    component: Signup
  },
  // ログイン
  {
    path: '/login',
    name: 'Login',
    component: Login
  },
  // ログインパスワードを忘れた場合の再発行画面
  {
    path: '/password/forget',
    name: 'ForgetPassword',
    component: ForgetPassword
  },
  // ログインパスワードのリセット画面
  {
    path: '/password/reset',
    name: 'ResetPassword',
    component: ResetPassword
  },
  // 新規会員登録後の導入画面
  {
    path: '/first_introduction',
    name: 'FirstIntroduction',
    component: FirstIntroduction
  },
  // スタジオ詳細
  {
    path: '/studios/:id',
    name: 'StudioShow',
    component: StudioShow
  },
  // イベント一覧
  {
    path: '/events',
    name: 'EventIndex',
    component: EventIndex
  },
  // イベント詳細
  {
    path: '/event/:id',
    name: 'EventShow',
    component: EventShow
  },
  // セッション曲詳細
  {
    path: '/event/:event_id/music/:session_music_id',
    name: 'SessionMusicShow',
    component: SessionMusicShow
  },
  // お知らせ一覧
  {
    path: '/news',
    name: 'NewsIndex',
    component: NewsIndex
  },
  // お知らせ詳細
  {
    path: '/news/:id',
    name: 'NewsShow',
    component: NewsShow
  },
  // 宿泊
  {
    path: '/stayrooms',
    name: 'StayroomIndex',
    component: StayroomIndex
  },
  // ユーザページ
  {
    path: '/users/:id',
    name: 'UserShow',
    component: UserShow
  },
  // マイページ
  {
    path: '/mypage',
    name: 'MypageTop',
    component: MypageTop,
    meta: { requiresAuth: true }
  },
  // ユーザ情報変更
  {
    path: '/mypage/edit',
    name: 'MypageEdit',
    component: MypageEdit,
    meta: { requiresAuth: true }
  },
  // スタジオ予約一覧
  {
    path: '/mypage/studio/reserves',
    name: 'MypageStudioReserves',
    component: MypageStudioReserves,
    meta: { requiresAuth: true }
  },
  // 参加イベント一覧
  {
    path: '/mypage/events',
    name: 'MypageEvents',
    component: MypageEvents,
    meta: { requiresAuth: true }
  },
  // 参加イベント一覧
  {
    path: '/mypage/stayrooms',
    name: 'MypageStayrooms',
    component: MypageStayrooms,
    meta: { requiresAuth: true }
  },
  // メッセージ一覧
  {
    path: '/mypage/messages',
    name: 'MypageMessages',
    component: MypageMessages,
    meta: { requiresAuth: true }
  },
  // 設定
  {
    path: '/mypage/settings',
    name: 'Settings',
    component: Settings,
    meta: { requiresAuth: true }
  },
  // メールアドレス変更
  {
    path: '/mypage/change_email',
    name: 'ChangeEmail',
    component: ChangeEmail,
    meta: { requiresAuth: true }
  },
  // パスワード変更
  {
    path: '/mypage/change_password',
    name: 'ChangePassword',
    component: ChangePassword,
    meta: { requiresAuth: true }
  },
  // フォロー一覧
  {
    path: '/users/:id/follow',
    name: 'Follow',
    component: Follow,
    meta: { requiresAuth: true }
  },
  // メッセージ
  {
    path: '/users/:id/messages',
    name: 'MessageShow',
    component: MessageShow,
    meta: { requiresAuth: true }
  },
  /***********************/
  /* 管理者用VIEW         */
  /***********************/
  // 管理メニュー
  {
    path: '/admin',
    name: 'AdminMenus',
    component: AdminMenus,
    meta: { requiresAdmin: true }
  },
  // イベント登録
  {
    path: '/event/new',
    name: 'EventNew',
    component: EventNew,
    meta: { requiresAdmin: true }
  },
  // イベント編集
  {
    path: '/event/:id/edit',
    name: 'EventEdit',
    component: EventEdit,
    meta: { requiresAdmin: true }
  },
  // イベント編集一覧
  {
    path: '/events/editlist',
    name: 'EventEditList',
    component: EventEditList,
    meta: { requiresAdmin: true }
  },
  // お知らせ新規作成
  {
    path: '/news/new',
    name: 'NewsNew',
    component: NewsNew,
    meta: { requiresAdmin: true }
  },
  // ユーザ一覧表示
  {
    path: '/users',
    name: 'UsersIndex',
    component: UsersIndex,
    meta: { requiresAdmin: true }
  },
  // お知らせ編集
  {
    path: '/news/:id/edit',
    name: 'NewsEdit',
    component: NewsEdit,
    meta: { requiresAdmin: true }
  },
  // お知らせ編集一覧
  {
    path: '/news/editlist',
    name: 'NewsEditList',
    component: NewsEditList,
    meta: { requiresAdmin: true }
  },
  // スタジオ内容編集
  {
    path: '/studio/:id/edit',
    name: 'StudioEdit',
    component: StudioEdit,
    meta: { requiresAdmin: true }
  },
  // スタジオ予約確認
  {
    path: '/admin/studio/:id/reserves',
    name: 'StudioReserves',
    component: StudioReserves,
    meta: { requiresAdmin: true }
  },
  // 宿泊予約確認
  {
    path: '/admin/stayrooms',
    name: 'StayroomReserves',
    component: StayroomReserves,
    meta: { requiresAdmin: true }
  },
  // 成立曲表示
  // {
  //   path: '/musics',
  //   name: 'Musics',
  //   component: Musics
  // },
  // NOTFOUND画面(該当のURLが存在しない場合)
  {
    path: '/:pathMatch(.*)*',
    name: 'NotFound',
    component: NotFound
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

router.beforeEach((to, from, next) => {
  // ログイン（トークン認証）が必要なページの場合
  if (to.matched.some(record => record.meta.requiresAuth)) {
    if (store.getters['user/secureToken']) {
      next()
    }
    else {
      store.dispatch(
        "loginGuide/update", true
      );
      store.dispatch(
        "flash/create",
        { message: "ログインまたは会員登録を行ってください。",
          type:    2
        }
      );
    }
  }
  // 管理者権限が必要なページの場合
  else if (to.matched.some(record => record.meta.requiresAdmin)) {
    // 未ログイン時
    if (!store.getters['user/secureToken']) {
      next({ path: '/login' });
    }
    // 操作権限がない場合
    else if (store.getters['user/adminType'] == 0) {
      store.dispatch(
        "response/update",
        { status: 403 }
      );
    }
    else {
      next();
    }
  } else {
    next();
  }
});

router.afterEach(() => {
  // NotFound画面から別画面に切り替えるための対応
  // 他、上手くいく方法があれば変更する
  if (store.getters["response/update"] != 0) {
    store.dispatch(
      "response/update",
      { status: 0,
        messages: '' }
    );
  }
})

export default router
