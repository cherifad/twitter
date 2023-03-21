import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'Home',
      component: import('../views/HomeView.vue'),
    },
    {
      path: '/explore',
      name: 'Explore',
      component: import('../views/ExploreView.vue'),
    },
    {
      path: '/notifications',
      name: 'Notifications',
      component: import('../views/NotifsView.vue'),
    },
    {
      path: '/messages',
      name: 'Messages',
      component: import('../views/MessagesView.vue'),
    },
    {
      path: '/profile',
      name: 'Profile',
      component: import('../views/ProfileView.vue'),
    }
  ]
})

export default router
