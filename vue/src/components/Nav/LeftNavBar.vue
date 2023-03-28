<template>
  <div>
    <ul class="px-8">
      <li class="">
        <RouterLink to="/" class="p-3 w-fit flex rounded-full items-center hover:bg-gray dark:hover:bg-gray-hover">
          <IconHome :selected="route.name == 'Home'" />
          <h1 class="mr-4 ml-5 text-xl dark:text-white" :class="route.name == 'Home' ? 'font-bold' : null" >Home</h1>
        </RouterLink>
      </li>
      <li class="">
        <RouterLink to="/explore" class="p-3 w-fit flex rounded-full items-center hover:bg-gray dark:hover:bg-gray-hover">
          <IconHashtag :selected="route.name == 'Explore'" />
          <h1 class="mr-4 ml-5 text-xl dark:text-white" :class="route.name == 'Explore' ? 'font-bold' : null" >Explore</h1>
        </RouterLink>
      </li>
      <li class="">
        <RouterLink to="/notifications" class="p-3 w-fit flex rounded-full items-center hover:bg-gray dark:hover:bg-gray-hover">
          <IconNotification :selected="route.name == 'Notifications'" />
          <h1 class="mr-4 ml-5 text-xl dark:text-white" :class="route.name == 'Notifications' ? 'font-bold' : null" >Notifications</h1>
        </RouterLink>
      </li>
      <li class="">
        <RouterLink to="/messages" class="p-3 w-fit flex rounded-full items-center hover:bg-gray dark:hover:bg-gray-hover">
          <IconMessage :selected="route.name == 'Messages'" />
          <h1 class="mr-4 ml-5 text-xl dark:text-white" :class="route.name == 'Messages' ? 'font-bold' : null" >Messages</h1>
        </RouterLink>
        <button @click="authStore.logout">sign out</button>
      </li>
      <li class="">
        <RouterLink to="" class="p-3 w-fit flex rounded-full items-center hover:bg-gray dark:hover:bg-gray-hover">
          <IconBlue :selected="route.name == 'TwitterBlue'" />
          <h1 class="mr-4 ml-5 text-xl dark:text-white" :class="route.name == 'TwitterBlue' ? 'font-bold' : null" >Twitter Blue</h1>
        </RouterLink>
      </li>
      <li class="">
        <RouterLink :to="authStore.isAuthenticated ? `/profile/${authStore.user.username}` : '/'" class="p-3 w-fit flex rounded-full items-center hover:bg-gray dark:hover:bg-gray-hover">
          <IconProfile :selected="route.name == 'Profile'" />
          <h1 class="mr-4 ml-5 text-xl dark:text-white" :class="route.name == 'Profile' ? 'font-bold' : null" >Profile</h1>
        </RouterLink>
      </li>
      <li class="">
        <RouterLink to="" class="p-3 w-fit flex rounded-full items-center hover:bg-gray dark:hover:bg-gray-hover">
          <IconMore :selected="route.name == 'More'" />
          <h1 class="mr-4 ml-5 text-xl dark:text-white" :class="route.name == 'More' ? 'font-bold' : null" >More</h1>
        </RouterLink>
      </li>
    </ul>
    <div class="flex justify-center">
      <Button class="mt-10 px-8 w-4/5 text-lg font-bold" text="Tweet" />
    </div>
  </div>
</template>

<script setup>
import IconHome from "../icons/IconHome.vue";
import IconHashtag from "../icons/IconHashtag.vue";
import IconNotification from "../icons/IconNotification.vue";
import IconMessage from "../icons/IconMessage.vue";
import IconBlue from "../icons/IconBlue.vue";
import IconProfile from "../icons/IconProfile.vue";
import IconMore from "../icons/IconMore.vue";
import Button from "../Button.vue";
import { useRoute, RouterLink } from "vue-router";
import { useAuthStore } from "../../stores/authStore";

const route = useRoute();
const authStore = useAuthStore();

</script>

<style scoped>

</style>
