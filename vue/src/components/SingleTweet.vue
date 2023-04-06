<template>
  <div
    class="flex pt-3 px-4 border-b-[1px] dark:border-zinc-800 border-zinc-200"
  >
    <div class="p-2">
      <img
        class="w-12 h-12 rounded-full"
        :src="
          tweetAuthorAvatar
            ? tweetAuthorAvatar
            : '/src/assets/img/default-avatar.webp'
        "
        :alt="tweetAuthor"
      />
    </div>
    <div class="pt-2 mb-3 flex-1">
      <div class="flex items-center justify-between w-full">
        <div class="flex items-center text-base">
          <RouterLink :to="'/' + tweetAuthorUsername" class="font-bold flex items-center underline-offset-2 hover:underline"
            >{{ tweetAuthor }}
            <IconVerified class="ml-1 w-4 h-4" v-if="tweetAuthorVerified"
          /></RouterLink>
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
        <p class="break-all" v-html="formatTweetContent(tweetContent)">
        </p>
      </div>
      <div v-if="tweetMediaCount > 0">
        <div class="flex mt-3 rounded-lg">
          <div class="w-full h-full overflow-hidden rounded-lg flex flex-wrap">
            <div
              v-for="media in tweetMedia"
              :key="media.id"
              class="h-32 pl-1 pb-1 rounded-lg"
              :class="
                tweetMediaCount == 1
                  ? 'w-full'
                  : !(tweetMediaCount % 2) && tweetMediaCount == media.id
                  ? 'w-full'
                  : 'w-1/2'
              "
            >
              <img
                class="w-full h-full object-cover"
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
          v-if="withResponse"
          @click="toShow = true"
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
          @click="retweetTweet"
          :class="userId ? usersRetweeted.includes(userId) ? 'text-[#00BA7C]' : 'text-gray-light' : 'text-gray-light'"
          class=" flex items-center gap-2 hover:text-[#00BA7C] cursor-pointer"
        >
          <div class="rounded-full w-9 h-9 flex items-center justify-center active:scale-75 transition-transform">
            <IconRetweet />
          </div>
          {{ formatCount(tweetRetweets) }}
        </div>
        <div
          @click="likeDislikeTweet"
          id="like"
          :class="userId ? usersLiked.includes(userId) ? 'text-[#F91880]' : 'text-gray-light' : 'text-gray-light'"
          class=" flex items-center gap-2 hover:text-[#F91880] cursor-pointer"
        >
          <div
            class="rounded-full w-9 h-9 flex items-center justify-center hover:bg-[rgba(224, 36, 94, 0.1)] active:scale-75 transition-transform"
          >
            <IconLike :liked="userId ? usersLiked.includes(userId) : false" />
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
    <AddReply @close="toShow=false" :original-tweet-id="tweetId" :to-show="toShow" v-bind:original-tweet-content="tweetContent" :original-tweet-author-picture="tweetAuthorAvatar" :original-tweet-author="tweetAuthor" :original-tweet-author-username="tweetAuthorUsername" :original-tweet-date="tweetDate" />
  </div>
</template>

<script setup>
import IconLike from "./icons/IconLike.vue";
import IconRetweet from "./icons/IconRetweet.vue";
import IconReply from "./icons/IconReply.vue";
import IconVerified from "./icons/IconVerified.vue";
import IconViewsCount from "./icons/IconViewsCount.vue";
import { formatCount, timeSince } from "../utils/helpers.js";
import { CREATE_NEW_LIKE, CREATE_NEW_RETWEET } from "../api";
import { useAuthStore } from "../stores/authStore";
import { ref, computed } from "vue";
import { RouterLink } from "vue-router";
import AddReply from "./AddReply.vue";

const auth = useAuthStore();

const toShow = ref(false);

const props = defineProps({
  tweetAuthor: {
    type: String,
    default: "",
    required: true,
  },
  withResponse: {
    type: Boolean,
    default: true,
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
  userLiked: {
    type: Boolean,
    default: false,
  },
  userRetweeted: {
    type: Boolean,
    default: false,
  },
  userReplied: {
    type: Boolean,
    default: false,
  },
  userId: {
    type: String,
    required: false,
  },
  usersLiked: {
    type: Array,
    default: [],
  },
  usersRetweeted: {
    type: Array,
    default: [],
  },
});

const time = ref(timeSince(props.tweetDate));

const likeDislikeTweet = async () => {
  await CREATE_NEW_LIKE(props.tweetId, auth.user.id);
};

const retweetTweet = async () => {
  await CREATE_NEW_RETWEET(props.tweetId, auth.user.id);
};

const affectToTime = () => {
  time.value = timeSince(props.tweetDate);
};

function formatTweetContent(tweetContent) {
  // Find all hashtags and wrap them in a span with a CSS class
  tweetContent = tweetContent.replace(/#([\p{L}\p{Mn}\p{Pc}]+)/ug, '<a href="/search?q=%23$1" class="text-blue cursor-pointer hover:underline">#$1</a>');
  // Find all mentions and wrap them in a span with a CSS class
  tweetContent = tweetContent.replace(/@([\p{L}\p{Mn}\p{Pc}-]+)/ug, '<a href="/$1" class="text-blue cursor-pointer hover:underline">@$1</a>');
  // Find all URLs and wrap them in a span with a CSS class
  tweetContent = tweetContent.replace(/(https?:\/\/[^\s]+)/ug, '<a href="$1" class="text-blue cursor-pointer hover:underline">$1</a>');

  return tweetContent;
}

setInterval(affectToTime, 10000);
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
