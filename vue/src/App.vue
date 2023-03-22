<template>
  <div class="flex items-stretch justify-center min-h-screen dark:bg-black">
    <header class="select-none w-1/4 flex justify-end border-r-[1px] dark:border-zinc-800 border-zinc-200">
      <div class="w-72 dark:text-white flex flex-col justify-between items-end px-2">
        <div>
          <IconTwitter class="ml-10 mt-5" />
          <LeftBar class="mt-5"/>
        </div>
        <UserCard name="John" pseudo="doe" />
      </div>
    </header>
    <main class="flex-1">
      <div class="w-[990px] dark:text-white flex gap-3 justify-between">
        <RouterView class="flex-1 border-r-[1px] dark:border-zinc-800 border-zinc-200" />
        <div class="w-[350px] flex min-h-screen">
          <RightBarHome v-if="route.name == 'Home'" />
          <RightBarExplore v-if="route.name == 'Explore'" />
        </div>
        
      </div>
    </main>
  </div>
</template>

<script setup >
import LeftBar from './components/Nav/LeftNavBar.vue';
import UserCard from './components/UserCard.vue';
import IconTwitter from './components/icons/IconTwitter.vue';
import RightBarHome from './components/Nav/RightBarHome.vue';
import RightBarExplore from './components/Nav/RightBarExplore.vue';
import { useRoute } from 'vue-router';

const route = useRoute();
</script>