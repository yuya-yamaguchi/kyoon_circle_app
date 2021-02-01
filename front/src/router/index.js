import { createRouter, createWebHistory } from 'vue-router'
import Top from '@/views/Top.vue'
import Signup from '@/views/auth/Signup.vue'
import Login from '@/views/auth/Login.vue'
import FirstIntroduction from '@/views/introduction/FirstIntroduction.vue'
import StudioShow from '@/views/studio/Show.vue'
import UserShow from '@/views/user/Show.vue'
import MypageTop from '@/views/mypage/Top.vue'
import MypageEdit from '@/views/mypage/Edit.vue'
import MypageStudioReserves from '@/views/mypage/StudioReserves.vue'
import MypageEvents from '@/views/mypage/Events.vue'
import EventNew from '@/views/event/New.vue'
import EventEdit from '@/views/event/Edit.vue'
import EventEditList from '@/views/event/EditList.vue'
import EventIndex from '@/views/event/Index.vue'
import EventShow from '@/views/event/Show.vue'
import UsersIndex from '@/views/admin/users/Index.vue'
import StudioEdit from '@/views/admin/studio/Edit.vue'
import StudioReserves from '@/views/admin/studio/Reserves.vue'
import NewsNew from '@/views/news/New.vue'
import NewsIndex from '@/views/news/Index.vue'
import NewsShow from '@/views/news/Show.vue'
import NewsEdit from '@/views/news/Edit.vue'
import NewsEditList from '@/views/news/EditList.vue'
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
  /***********************/
  /* 管理者用VIEW         */
  /***********************/
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
    !store.getters['user/secureToken'] ? next({ path: '/login' }) : next();
  }
  // 管理者権限が必要なページの場合
  else if (to.matched.some(record => record.meta.requiresAdmin)) {
    if (!store.getters['user/secureToken']) {
      next({ path: '/login' });
    }
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
      { status: 0 }
    );
  }
})

export default router
