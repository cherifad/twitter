<script setup>
import { ref, watch, reactive } from "vue";
import {
  GET_USER_WITH_USERNAME,
  CREATE_CONVERSATION,
  FOLLOW_UNFOLLOW_USER,
  DOES_FOLLOW_USER,
} from "../api";
import { useAuthStore } from "../stores/authStore";

const props = defineProps({
  accountPictureAuthor: {
    type: String,
    default: "",
    required: false,
  },
  accountAuthor: {
    type: String,
    default: "",
    required: true,
  },
  accountUserAuthor: {
    type: String,
    default: "",
    required: true,
  },
  userId: {
    type: String,
    required: true,
  },
});

const authStore = useAuthStore();

const state = reactive({
  doesFollow: false,
});

const subscription = DOES_FOLLOW_USER(authStore.user.id, props.userId);

subscription.subscribe({
  next: ({ data }) => {
    state.doesFollow = data.follower.length > 0;
    textBtn.value = btnTextToDisplay();
  },
  error: (error) => {
    console.error(error);
  },
});

const btnTextToDisplay = (isHover = false) => {
  if (state.doesFollow) {
    return isHover ? "Unfollow" : "Following";
  } else {
    return "Follow";
  }
};

const textBtn = ref(btnTextToDisplay());

const followUnfollow = async () => {
  await FOLLOW_UNFOLLOW_USER(authStore.user.id, props.userId);
};
</script>

<template>
  <div class="flex justify-between items-center mt-5">
    <div class="flex items-center">
      <div class="ml-5">
        <img
          :src="
            accountPictureAuthor
              ? accountPictureAuthor
              : '/src/assets/img/default-avatar.webp'
          "
          :alt="accountUserAuthor"
          class="w-12 h-12 rounded-full"
        />
      </div>
      <div class="ml-4">
        <h1 class="text-sl font-black">{{ accountAuthor }}</h1>
        <h1 class="text-sl font-normal text-gray-light">
          @{{ accountUserAuthor }}
        </h1>
      </div>
    </div>
    <div class="flex items-center">
      <button
        @click="followUnfollow"
        @mouseover="textBtn = btnTextToDisplay(true)"
        @mouseleave="textBtn = btnTextToDisplay(false)"
        :class="
          state.doesFollow
            ? 'hover:text-red-500 hover:border-red-500'
            : ''
        "
        class="mr-7 rounded-full bg-black text-white font-black px-4 text-sm min-h-[32px] dark:bg-white dark:text-black"
      >
        {{ textBtn }}
      </button>
    </div>
  </div>
</template>
