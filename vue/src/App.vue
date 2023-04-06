<template>
  <div class="flex items-stretch justify-center min-h-screen dark:bg-black">
    <header
      class="select-none w-1/4 flex justify-end border-r-[1px] dark:border-zinc-800 border-zinc-200 h-screen sticky top-0"
    >
      <div
        class="w-72 dark:text-white flex flex-col justify-between items-end px-2"
      >
        <div>
          <IconTwitter class="ml-10 mt-5" />
          <LeftBar class="w-full" />
        </div>
        <UserCard
          class="w-full"
          v-if="authStore.isAuthenticated"
          :name="authStore.user.name"
          :pseudo="authStore.user.username"
          :avatar="authStore.user.profile_picture_url"
          :verified="authStore.isPremium"
        />
      </div>
    </header>
    <main class="flex-1 flex flex-col">
      <div class="w-[990px] dark:text-white flex gap-3 justify-between flex-1">
        <RouterView
          :class="
            route.name != 'Messages'
              ? 'border-r-[1px] dark:border-zinc-800 border-zinc-200'
              : ''
          "
          class="flex-1 flex flex-col"
        />
        <div
          v-if="route.name != 'Messages'"
          class="outline-none w-[350px] flex h-screen sticky top-0"
        >
          <RightBarHome v-if="route.name == 'Home'" />
          <RightBarExplore v-if="route.name == 'Explore'" />
          <RightBarHome v-if="route.name == 'Notifications'" />
        </div>
      </div>
    </main>
    <authBanner v-if="!authStore.isAuthenticated" />
    <AuthPopup />
  </div>
</template>

<script setup>
import LeftBar from './components/Nav/LeftNavBar.vue';
import UserCard from './components/UserCard.vue';
import IconTwitter from './components/icons/IconTwitter.vue';
import RightBarHome from './components/Nav/RightBarHome.vue';
import RightBarExplore from './components/Nav/RightBarExplore.vue';
import { useRoute } from 'vue-router';
import authBanner from './components/Auth/authBanner.vue';
import { useAuthStore } from './stores/authStore';
import AuthPopup from './components/Auth/AuthPopup.vue';
import { LISTEN_TO_NOTIFICATIONS } from './api';
import { ref, reactive, watch } from 'vue';
import { useNotificationStore } from './stores/notifications';

const route = useRoute();
const authStore = useAuthStore();
const notificationStore = useNotificationStore();

const subscribeToNotifications = () => {
  if (authStore.isAuthenticated) {
    const subscription = LISTEN_TO_NOTIFICATIONS(authStore.user.id);

    subscription.subscribe({
      next: ({ data }) => {
        notificationStore.setNotifications(data.notification);
      },
      error: (error) => {
        console.error(error);
      },
    });
  }
};

subscribeToNotifications();

watch(
  () => authStore.isAuthenticated,
  () => {
    subscribeToNotifications();
  }
);

</script>
