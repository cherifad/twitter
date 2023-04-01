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
      <img
        class="w-full h-auto"
        :src="user.avatar ? user.avatar : '/src/assets/img/default-banner.jpg'"
        :alt="user.username"
      />
      <div class="absolute bottom-0 px-4">
        <img
          class="w-24 h-24 rounded-full border-white dark:border-black border-4 p-0"
          :src="
            user.profile_picture_url
              ? user.profile_picture_url
              : '/src/assets/img/default-avatar.webp'
          "
          :alt="user.username"
        />
      </div>
      <div class="px-4 pt-3">
        <div class="flex items-center justify-end gap-2">
          <button
            @click="createConversation"
            class="rounded-full flex items-center justify-center dark:border-[rgb(83,100,113)] border-zinc-200 dark:text-white border-[1px] dark:hover:bg-zinc-800 font-bold h-[34px] w-[34px] hover:bg-slate-100"
          >
            <IconMessage class="w-4 h-4" />
          </button>
          <button
            @click="followUnfollow"
            @mouseover="textBtn = btnTextToDisplay(true)"
            @mouseleave="textBtn = btnTextToDisplay(false)"
            :class="state.doesFollow ? 'hover:text-red-500 hover:border-red-500' : 'border-zinc-200 dark:border-[rgb(83,100,113)] hover:bg-slate-100 dark:hover:bg-zinc-800'"
            class="dark:text-white rounded-full border-[1px] font-bold min-h-[36px] px-4"
          >
            <!-- {{
              authStore.isAuthenticated &&
              user.username == authStore.user.username
                ? "Edit profile"
                : state.doesFollow
                ? "Following"
                : "Follow"
            }} -->
            {{ textBtn }}
          </button>
        </div>
      </div>
    </div>
    <div class="px-4 my-4">
      <div class="mb-3">
        <span class="flex gap-2 items-center font-extrabold text-xl"
          >{{ user.name }}
          <IconVerified v-if="user.premium" />
        </span>
        <span class="text-slate-700 dark:text-zinc-500"
          >@{{ user.username }}</span
        >
      </div>
      <div class="mb-3">
        <span class="text-slate-700 dark:text-zinc-500 gap-2 flex items-center">
          <IconCalendar class="w-[19px] h-[19px]" /> Joinded
          {{ monthNames[new Date(user.created_at).getMonth()] }}
          {{ new Date(user.created_at).getFullYear() }}
        </span>
      </div>
      <div class="flex">
        <span class="mr-5 text-slate-700 dark:text-zinc-500"
          ><span class="font-bold text-black dark:text-white">{{
            user.followers_aggregate.aggregate.count
          }}</span>
          Following</span
        >
        <span class="text-slate-700 dark:text-zinc-500"
          ><span class="font-bold text-black dark:text-white">{{
            user.following_aggregate.aggregate.count
          }}</span>
          Followers</span
        >
      </div>
    </div>
    <TabGroup>
      <TabList class="flex border-b-[1px] border-gray dark:border-zinc-800">
        <Tab v-slot="{ selected }" class="flex-1 outline-none">
          <div
            :class="[
              'flex justify-center items-center px-4 h-[53px] min-w-[56px] flex-1 hover:bg-[rgb(15,20,25)]/10',
              selected
                ? 'text-black dark:text-white font-extrabold'
                : 'text-gray-light',
            ]"
          >
            <div class="w-fit flex flex-col">
              <span class="py-3">Likes</span>
              <div
                v-if="selected"
                class="rounded-full bg-blue h-1 w-full"
              ></div>
            </div>
          </div>
        </Tab>
        <Tab v-slot="{ selected }" class="flex-1 outline-none">
          <div
            :class="[
              'flex justify-center items-center px-4 h-[53px] min-w-[56px] flex-1 hover:bg-[rgb(15,20,25)]/10',
              selected
                ? 'text-black dark:text-white font-extrabold'
                : 'text-gray-light',
            ]"
          >
            <div class="w-fit flex flex-col">
              <span class="py-3">Likes</span>
              <div
                v-if="selected"
                class="rounded-full bg-blue h-1 w-full"
              ></div>
            </div>
          </div>
        </Tab>
        <Tab v-slot="{ selected }" class="flex-1 outline-none">
          <div
            :class="[
              'flex justify-center items-center px-4 h-[53px] min-w-[56px] flex-1 hover:bg-[rgb(15,20,25)]/10',
              selected
                ? 'text-black dark:text-white font-extrabold'
                : 'text-gray-light dark:text-zinc-500',
            ]"
          >
            <div class="w-fit flex flex-col">
              <span class="py-3">Likes</span>
              <div
                v-if="selected"
                class="rounded-full bg-blue h-1 w-full"
              ></div>
            </div>
          </div>
        </Tab>
      </TabList>
      <TabPanels class="px-4">
        <TabPanel class="pt-3">Content 1</TabPanel>
        <TabPanel class="pt-3">Content 2</TabPanel>
        <TabPanel class="pt-3">Content 3</TabPanel>
      </TabPanels>
    </TabGroup>
  </div>
</template>

<script setup>
import { useAuthStore } from "../stores/authStore";
import IconLeft from "../components/icons/IconLeft.vue";
import IconVerified from "../components/icons/IconVerified.vue";
import IconCalendar from "../components/icons/IconCalendar.vue";
import IconMessage from "../components/icons/IconMessage.vue";
import { useRouter, useRoute } from "vue-router";
import { ref, onMounted, reactive } from "vue";
import {
  GET_USER_WITH_USERNAME,
  CREATE_CONVERSATION,
  FOLLOW_UNFOLLOW_USER,
  DOES_FOLLOW_USER,
} from "../api";
import { TabGroup, TabList, Tab, TabPanels, TabPanel } from "@headlessui/vue";

const monthNames = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December",
];

const authStore = useAuthStore();
const router = useRouter();
const route = useRoute();
const user = ref(null);
const textBtn = ref("Follow");

const state = reactive({
  doesFollow: false,
});

const username = ref(route.params.username);

onMounted(async () => {
  user.value = await GET_USER_WITH_USERNAME(username.value);
  const subscription = DOES_FOLLOW_USER(authStore.user.id, user.value.id);

  subscription.subscribe({
    next: ({ data }) => {
      state.doesFollow = data.follower.length > 0;
      textBtn.value = btnTextToDisplay();
    },
    error: (error) => {
      console.error(error);
    },
  });

  textBtn.value = btnTextToDisplay();
});

const followUnfollow = async () => {
  await FOLLOW_UNFOLLOW_USER(authStore.user.id, user.value.id);
};

const createConversation = async () => {
  await CREATE_CONVERSATION(authStore.user.id, user.value.id);
  router.push(`/messages`);
};

const btnTextToDisplay = (hover = false) => {
  if (user.value.id === authStore.user.id) {
    return "Edit Profile";
  } else if (state.doesFollow) {
    return hover ? "Unfollow" : "Following";
  } else {
    return "Follow";
  }
};
</script>
