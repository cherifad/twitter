<template>
  <div class="flex items-stretch justify-center min-h-screen dark:bg-black">
    <header class="select-none w-1/4 flex justify-end border-r-zinc-800 border-r-2">
      <div class="w-72 flex flex-col justify-between items-end px-2">
        <div>
          <IconTwitter class="my-1 mx-8" />
          <LeftBar />
        </div>
        <UserCard name="John" pseudo="doe" />
      </div>
    </header>
    <main class="flex-1">
      <div class="w-[990px] dark:text-white flex justify-between">
        <RouterView class="flex-1" />
        <div class="w-[350px] bg-red-500 h-screen">

        </div>
      </div>
    </main>
  </div>
</template>

<script setup >
import LeftBar from './components/Nav/LeftNavBar.vue';
import UserCard from './components/UserCard.vue';
import IconTwitter from './components/icons/IconTwitter.vue';
</script>