import { createRouter, createWebHistory } from 'vue-router'
import Top from '@/views/Top.vue'
import Signup from '@/views/auth/Signup.vue'
import Login from '@/views/auth/Login.vue'
import StudioShow from '@/views/studio/Show.vue'
import MypageTop from '@/views/mypage/Top.vue'
import MypageProfile from '@/views/mypage/Profile.vue'
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
  // スタジオ詳細
  {
    path: '/studios/:id',
    name: 'StudioShow',
    component: StudioShow
  },
  // マイページ
  {
    path: '/mypage',
    name: 'MypageTop',
    component: MypageTop
  },
  // プロフィール編集
  {
    path: '/mypage/profile',
    name: 'MypageProfile',
    component: MypageProfile
  },
  // スタジオ予約一覧
  {
    path: '/mypage/studio/reserves',
    name: 'MypageStudioReserves',
    component: MypageStudioReserves
  },
  // 参加イベント一覧
  {
    path: '/mypage/events',
    name: 'MypageEvents',
    component: MypageEvents
  },
  // イベント登録
  {
    path: '/event/new',
    name: 'EventNew',
    component: EventNew
  },
  // イベント編集
  {
    path: '/event/:id/edit',
    name: 'EventEdit',
    component: EventEdit
  },
  // イベント編集一覧
  {
    path: '/events/editlist',
    name: 'EventEditList',
    component: EventEditList
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
  // お知らせ編集
  {
    path: '/news/:id/edit',
    name: 'NewsEdit',
    component: NewsEdit
  },
  // お知らせ編集一覧
  {
    path: '/news/editlist',
    name: 'NewsEditList',
    component: NewsEditList
  },
  /***********************/
  /* 管理者用VIEW         */
  /***********************/
  // ユーザ一覧表示
  {
    path: '/users',
    name: 'UsersIndex',
    component: UsersIndex
  },
  // スタジオ内容編集
  {
    path: '/studio/:id/edit',
    name: 'StudioEdit',
    component: StudioEdit
  },
  // スタジオ予約一覧
  {
    path: '/admin/studio/:id/reserves',
    name: 'StudioReserves',
    component: StudioReserves
  },
  // お知らせ新規作成
  {
    path: '/news/new',
    name: 'NewsNew',
    component: NewsNew
  },
  /***********************/
  /* エラーVIEW           */
  /***********************/
  // NOTFOUND画面
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
