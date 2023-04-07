<template>
  <div class="flex flex-col min-h-screen">
    <div class="px-4 sticky top-0 items-center h-14 flex">
      <span class="text-xl font-bold">Home</span>
    </div>
    <NewTweet v-if="auths.isAuthenticated" :author_id="auths.user.id" :avatar="auths.user.profile_picture_url" />
    <div :class="['flex-1', state.tweets.length <= 0 ? 'flex justify-center items-center' : '']">
      <div v-for="tweet in state.tweets" v-if="state.tweets.length > 0">
        <SingleTweet
          v-if="tweet.parent_tweet_id == null"
          :tweet-author="tweet.tweet_user.name"
          :tweet-media="null"
          :tweet-media-count="0"
          :tweet-author-avatar="tweet.tweet_user.profile_picture_url"
          :tweet-author-username="tweet.tweet_user.username"
          :tweet-author-verified="tweet.tweet_user.premium"
          :tweet-content="tweet.content"
          :tweet-date="tweet.created_at"
          :tweet-likes="tweet.tweet_likes_aggregate.aggregate.count"
          :tweet-retweets="tweet.tweet_retweets_aggregate.aggregate.count"
          :tweet-replies="tweet.tweet_replies_aggregate.aggregate.count"
          :tweet-bookmarked="false"
          :tweet-liked="true"
          :tweet-retweeted="false"
          :tweet-replied="false"
          tweet-media="258"
          :tweet-views="25874123"
          :tweet-id="tweet.id"
          :tweet-thread="false"
          :user-id="auths.user? auths.user.id : null"
          :users-liked="tweet.tweet_likes_aggregate.nodes.map((like) => like.user_id)"
          :users-retweeted="tweet.tweet_retweets_aggregate.nodes.map((retweet) => retweet.user_id)"
        />      
      </div>
      <Loading v-else />
    </div>
  </div>
</template>

<script setup>
import NewTweet from "../components/NewTweet.vue";
import SingleTweet from "../components/SingleTweet.vue";
import { reactive } from "vue";
import { GET_TWEETS } from "../api";
import { ref } from "vue";
import {
  Dialog,
  DialogPanel,
  DialogTitle,
  DialogDescription,
} from "@headlessui/vue";
import { useAuthStore } from "../stores/authStore";
import Loading from "../components/Loading.vue";

const isOpen = ref(true);
const auths = useAuthStore();

function setIsOpen(value) {
  isOpen.value = value;
}

const state = reactive({
  tweets: [],
});

const subscription = GET_TWEETS();

subscription.subscribe({
  next: ({ data }) => {
    state.tweets = data.tweet;
  },
  error: (error) => {
    console.error(error);
  },
});
</script>
