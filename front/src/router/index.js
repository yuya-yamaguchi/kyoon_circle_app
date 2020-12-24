import { createRouter, createWebHistory } from 'vue-router'
import Top from '@/views/Top.vue'
import Signup from '@/views/auth/Signup.vue'
import Login from '@/views/auth/Login.vue'
import StudioShow from '@/views/studio/Show.vue'
import MypageTop from '@/views/mypage/Top.vue'
import MypageProfile from '@/views/mypage/Profile.vue'

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
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router
