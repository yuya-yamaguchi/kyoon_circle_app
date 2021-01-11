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
import NewsNew from '@/views/admin/news/New.vue'
import NewsIndex from '@/views/admin/news/Index.vue'

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
    path: '/event/editlist',
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
    path: '/studio/1/edit',
    name: 'StudioEdit',
    component: StudioEdit
  },
  // お知らせ新規作成
  {
    path: '/news/new',
    name: 'NewsNew',
    component: NewsNew
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router
