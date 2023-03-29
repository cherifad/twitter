<template>
  <div class="flex pt-3 px-4 border-b-[1px] dark:border-zinc-800 border-zinc-200">
    <div class="p-2">
      <img
        class="w-12 h-12 rounded-full"
        :src="tweetAuthorAvatar ? tweetAuthorAvatar : '/src/assets/img/default-avatar.webp'"
        :alt="tweetAuthor"
      />
    </div>
    <div class="pt-2 mb-3 flex-1">
      <div class="flex items-center justify-between w-full">
        <div class="flex items-center text-base">
          <span class="font-bold flex items-center">{{ tweetAuthor }} <IconVerified class="ml-1" v-if="tweetAuthorVerified" /></span>
          <span class="ml-1 text-gray-light font-normal"
            >@{{ tweetAuthorUsername }}</span
          >
          <span class="px-1 text-gray-light font-normal">·</span>
          <span class="ml-1 text-gray-light">{{ time }}</span>
        </div>
        <div class="ml-2">
          <svg
            class="w-4 h-4 text-gray-light"
            viewBox="0 0 24 24"
            fill="currentColor"
            stroke="currentColor"
            stroke-width="2"
            stroke-linecap="round"
            stroke-linejoin="round"
          >
            <circle cx="12" cy="12" r="1"></circle>
            <circle cx="19" cy="12" r="1"></circle>
            <circle cx="5" cy="12" r="1"></circle>
          </svg>
        </div>
      </div>
      <div class="text-base dark:text-slate-200 text-black">
        <p>{{ tweetContent }}</p>
      </div>
      <div v-if="tweetMediaCount > 0">
        <div class="flex mt-3 rounded-lg">
          <div class="w-full h-full overflow-hidden rounded-lg flex flex-wrap">
            <div
              v-for="media in tweetMedia"
              :key="media.id"
              class="h-32 pl-1 pb-1 rounded-lg"
              :class="tweetMediaCount == 1 ? 'w-full' : !(tweetMediaCount % 2) &&  tweetMediaCount == media.id ? 'w-full' : 'w-1/2'"
            >
              <img
                class="w-full h-full object-cover "
                :src="media.url"
                :alt="media.alt"
              />
            </div>
          </div>
        </div>
      </div>
      <div class="flex mt-3 text-sm font-normal w-10/12 justify-between">
        <div
          id="reply"
          class="text-gray-light flex items-center gap-2 hover:text-blue cursor-pointer"
        >
          <div
            class="rounded-full w-9 h-9 flex items-center justify-center hover:bg-[rgba(29, 155, 240, 0.1)]"
          >
            <IconReply />
          </div>
          {{ formatCount(tweetReplies) }}
        </div>
        <div
          id="retweet"
          class="text-gray-light flex items-center gap-2 hover:text-[#00BA7C] cursor-pointer"
        >
          <div
            class="rounded-full w-9 h-9 flex items-center justify-center"
          >
            <IconRetweet />
          </div>
          {{ formatCount(tweetRetweets) }}
        </div>
        <div
          @click="likeDislikeTweet"
          id="like"
          class="text-gray-light flex items-center gap-2 hover:text-[#F91880] cursor-pointer"
        >
          <div
            class="rounded-full w-9 h-9 flex items-center justify-center hover:bg-[rgba(224, 36, 94, 0.1)]"
          >
            <IconLike />
          </div>
          {{ formatCount(tweetLikes) }}
        </div>
        <div
          id="views"
          class="text-gray-light flex items-center gap-2 hover:text-blue cursor-pointer"
        >
          <div
            class="rounded-full w-9 h-9 flex items-center justify-center hover:bg-[rgba(255, 209, 102, 0.1)]"
          >
            <IconViewsCount />
          </div>
          0
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import IconLike from "./icons/IconLike.vue";
import IconRetweet from "./icons/IconRetweet.vue";
import IconReply from "./icons/IconReply.vue";
import IconVerified from "./icons/IconVerified.vue";
import IconViewsCount from "./icons/IconViewsCount.vue";
import { formatCount, timeSince } from "../utils/helpers.js";
import { CREATE_NEW_LIKE } from "../api";
import { useAuthStore } from "../stores/authStore";
import { ref } from "vue";

const auth = useAuthStore();
const time = ref("");

const props = defineProps({
  tweetAuthor: {
    type: String,
    default: "",
    required: true,
  },
  tweetAuthorId: {
    type: String,
    default: "",
  },
  tweetAuthorAvatar: {
    type: String,    
  },
  tweetAuthorUsername: {
    type: String,
    default: "",
  },
  tweetAuthorVerified: {
    type: Boolean,
    default: false,
  },
  tweetContent: {
    type: String,
    default: "",
  },
  tweetDate: {
    type: String,
    default: "",
  },
  tweetLikes: {
    type: Number,
    default: 0,
  },
  tweetRetweets: {
    type: Number,
    default: 0,
  },
  tweetReplies: {
    type: Number,
    default: 0,
  },
  tweetBookmarked: {
    type: Boolean,
    default: false,
  },
  tweetLiked: {
    type: Boolean,
    default: false,
  },
  tweetRetweeted: {
    type: Boolean,
    default: false,
  },
  tweetReplied: {
    type: Boolean,
    default: false,
  },
  tweetMedia: {
    type: Array,
    default: [],
  },
  tweetMediaCount: {
    type: Number,
    default: 0,
  },
  tweetViews: {
    type: Number,
    default: 0,
  },
  tweetId: {
    type: String,
    default: "",
  },
  tweetThread: {
    type: Boolean,
    default: false,
  },
  tweetChild: {
    type: Object,
  },
  userLiked : {
    type: Boolean,
    default: false,
  },
  userRetweeted : {
    type: Boolean,
    default: false,
  },
  userReplied : {
    type: Boolean,
    default: false,
  },
});

const likeDislikeTweet = async () => {
  const response = await CREATE_NEW_LIKE(props.tweetId, auth.user.id);
  const data = await response;
  console.log(data);
};

const affectToTime = () => {
  time.value = timeSince(props.tweetDate);
};

setInterval(affectToTime, 1000);

</script>

<style scoped>
#reply:hover > div {
  background-color: rgba(29, 155, 240, 0.1);
}

#retweet:hover > div {
  background-color: rgba(0, 186, 124, 0.1);
}

#like:hover > div {
  background-color: rgba(249, 24, 128, 0.1);
}

#views:hover > div {
  background-color: rgba(29, 155, 240, 0.1);
}
</style>
