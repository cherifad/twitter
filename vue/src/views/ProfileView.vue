<template>
  <div class="flex flex-col min-h-screen" v-if="user">
    <div class="px-4 sticky top-0 items-center h-14 flex bg-white/10">
      <div class="flex items-center">
        <button @click="router.go(-1)">
          <IconLeft />
        </button>
      </div>
      <span class="text-xl font-bold ml-3">{{ user.username }}</span>
    </div>
    <div class="relative">
        <img class="w-full h-auto" src="/src/assets/img/default-banner.jpg" :alt="user.username">
        <div class="absolute bottom-0 px-4">
            <img class="w-24 h-24 rounded-full border-white dark:border-black border-4 p-0" :src="user.avatar ? user.avatar : '/src/assets/img/default-avatar.webp'" :alt="user.username">
        </div>
        <div class="px-4 pt-3">
            <div class="flex items-center justify-end">
                <button
                    class="rounded-full dark:border-white border-zinc-200 dark:text-white border-[1px] dark:hover:bg-zinc-800 font-bold min-h-[36px] px-4 hover:bg-slate-100"
                  >
                    {{ authStore.isAuthenticated && user.username == username ? "Edit profile" : "Follow" }}
                  </button>
            </div>
        </div>
    </div>
  </div>
</template>

<script setup>
import { useAuthStore } from "../stores/authStore";
import IconLeft from "../components/icons/IconLeft.vue";
import { useRouter, useRoute } from "vue-router";
import { ref, onMounted } from "vue";
import { GET_USER_WITH_USERNAME } from "../api";

const authStore = useAuthStore();
const router = useRouter();
const route = useRoute();
const user = ref(null);

const username = ref(route.params.username);

onMounted(async () => {
  if (!authStore.isAuthenticated) {
    user.value = await GET_USER_WITH_USERNAME(username.value);
  } else {
    if (authStore.user.username == username.value) {
      user.value = authStore.user;
    } else {
      user.value = await GET_USER_WITH_USERNAME(username.value);
    }
  }
});
</script>
