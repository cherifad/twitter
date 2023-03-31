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
      <img class="w-full h-auto" :src="user.avatar ? user.avatar : '/src/assets/img/default-banner.jpg'" :alt="user.username">
      <div class="absolute bottom-0 px-4">
        <img class="w-24 h-24 rounded-full border-white dark:border-black border-4 p-0"
          :src="user.avatar ? user.avatar : '/src/assets/img/default-avatar.webp'" :alt="user.username">
      </div>
      <div class="px-4 pt-3">
        <div class="flex items-center justify-end">
          <button
            class="rounded-full dark:border-white border-zinc-200 dark:text-white border-[1px] dark:hover:bg-zinc-800 font-bold min-h-[36px] px-4 hover:bg-slate-100">
            {{ authStore.isAuthenticated && user.username == authStore.user.username ? "Edit profile" : "Follow" }}
          </button>
        </div>
      </div>
    </div>
    <div class=" px-4 my-4">
      <div class="mb-3">
        <span class="flex gap-2 items-center font-extrabold text-xl">{{ user.name }}
          <IconVerified v-if="user.premium" />
        </span>
        <span class="text-slate-700 dark:text-zinc-500">@{{ user.username }}</span>
      </div>
      <div class="mb-3">
        <span class="text-slate-700 dark:text-zinc-500 gap-2 flex items-center">
          <IconCalendar class=" w-[19px] h-[19px]" /> Joinded {{ monthNames[new Date(user.created_at).getMonth()] }} {{
            new Date(user.created_at).getFullYear() }}
        </span>
      </div>
      <div class="flex">
        <span class="mr-5 text-slate-700"><span class="font-bold text-black">{{ user.followers_aggregate.aggregate.count
        }}</span> Following</span>
        <span class="text-slate-700"><span class="font-bold text-black">{{ user.followers_aggregate.aggregate.count
        }}</span> Followers</span>
      </div>
    </div>
    <TabGroup>
      <TabList class="flex border-b-[1px] border-gray dark:border-zinc-800">
        <Tab v-slot="{ selected }" class="flex-1 outline-none">
          <div :class="['flex justify-center items-center px-4 h-[53px] min-w-[56px] flex-1 hover:bg-[rgb(15,20,25)]/10', selected ? 'text-black font-extrabold' : 'text-gray-light']">
            <div class=" w-fit flex flex-col">
              <span class="py-3">Likes</span>
              <div v-if="selected" class=" rounded-full bg-blue h-1 w-full"></div>
            </div>
          </div>
        </Tab>
        <Tab v-slot="{ selected }" class="flex-1 outline-none">
          <div :class="['flex justify-center items-center px-4 h-[53px] min-w-[56px] flex-1 hover:bg-[rgb(15,20,25)]/10', selected ? 'text-black font-extrabold' : 'text-gray-light']">
            <div class=" w-fit flex flex-col">
              <span class="py-3">Likes</span>
              <div v-if="selected" class=" rounded-full bg-blue h-1 w-full"></div>
            </div>
          </div>
        </Tab>
        <Tab v-slot="{ selected }" class="flex-1 outline-none">
          <div :class="['flex justify-center items-center px-4 h-[53px] min-w-[56px] flex-1 hover:bg-[rgb(15,20,25)]/10', selected ? 'text-black font-extrabold' : 'text-gray-light']">
            <div class=" w-fit flex flex-col">
              <span class="py-3">Likes</span>
              <div v-if="selected" class=" rounded-full bg-blue h-1 w-full"></div>
            </div>
          </div>
        </Tab>
      </TabList>
      <TabPanels class="px-4">
        <TabPanel class=" pt-3">Content 1</TabPanel>
        <TabPanel class=" pt-3">Content 2</TabPanel>
        <TabPanel class=" pt-3">Content 3</TabPanel>
      </TabPanels>
    </TabGroup>
  </div>
</template>

<script setup>
import { useAuthStore } from "../stores/authStore";
import IconLeft from "../components/icons/IconLeft.vue";
import IconVerified from "../components/icons/IconVerified.vue";
import IconCalendar from "../components/icons/IconCalendar.vue";
import { useRouter, useRoute } from "vue-router";
import { ref, onMounted } from "vue";
import { GET_USER_WITH_USERNAME } from "../api";
import { TabGroup, TabList, Tab, TabPanels, TabPanel } from '@headlessui/vue'

const monthNames = ["January", "February", "March", "April", "May", "June",
  "July", "August", "September", "October", "November", "December"
];

const authStore = useAuthStore();
const router = useRouter();
const route = useRoute();
const user = ref(null);

const username = ref(route.params.username);

onMounted(async () => {
    user.value = await GET_USER_WITH_USERNAME(username.value);
});
</script>
