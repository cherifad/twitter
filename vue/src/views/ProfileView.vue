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
            v-if="authStore.user && user.id != authStore.user.id"
            @click="createConversation"
            class="rounded-full flex items-center justify-center dark:border-[rgb(83,100,113)] border-zinc-200 dark:text-white border-[1px] dark:hover:bg-zinc-800 font-bold h-[34px] w-[34px] hover:bg-slate-100"
          >
            <IconMessage class="w-4 h-4" />
          </button>
          <button
            @click="followUnfollow"
            @mouseover="textBtn = btnTextToDisplay(true)"
            @mouseleave="textBtn = btnTextToDisplay(false)"
            :class="
              state.doesFollow
                ? 'hover:text-red-500 hover:border-red-500'
                : 'border-zinc-200 dark:border-[rgb(83,100,113)] hover:bg-slate-100 dark:hover:bg-zinc-800'
            "
            class="dark:text-white rounded-full border-[1px] font-bold min-h-[36px] px-4"
          >
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
      <div class="flex mb-3">
        <span class="text-slate-700 dark:text-zinc-500 gap-2 flex items-center">
          <IconBorn class="w-[19px] h-[19px]" /> Born
          {{ convertDate(user.date_of_birth).getDay() }}
          {{ monthNames[convertDate(user.date_of_birth).getMonth()] }}
          {{ convertDate(user.date_of_birth).getFullYear() }}
        </span>
        <span
          class="text-slate-700 dark:text-zinc-500 gap-2 flex items-center ml-5"
        >
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
              <span class="py-3">Tweets</span>
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
              <span class="py-3">Replies</span>
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
              <span class="py-3">Media</span>
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
              <span class="py-3">Likes </span>
              <div
                v-if="selected"
                class="rounded-full bg-blue h-1 w-full"
              ></div>
            </div>
          </div>
        </Tab>
      </TabList>
      <TabPanels class="px-4">
        <TabPanel class="pt-3">
          <SingleTweet
            v-if="state.tweets.length > 0"
            v-for="tweet in state.tweets"
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
            :tweet-replies="2547"
            :tweet-bookmarked="false"
            :tweet-liked="true"
            :tweet-retweeted="false"
            :tweet-replied="false"
            tweet-media="258"
            :tweet-views="25874123"
            :tweet-id="tweet.id"
            :tweet-thread="false"
            :user-id="authStore.user ? authStore.user.id : null"
            :users-liked="
              tweet.tweet_likes_aggregate.nodes.map((like) => like.user_id)
            "
            :users-retweeted="
              tweet.tweet_retweets_aggregate.nodes.map(
                (retweet) => retweet.user_id
              )
            "
          />
          <Loading v-else />
        </TabPanel>
        <TabPanel class="pt-3">Content 2</TabPanel>
        <TabPanel class="pt-3">Content 3</TabPanel>
        <TabPanel class="pt-3">
          <SingleTweet
            v-if="state.tweetsLiked.length > 0"
            v-for="tweet in state.tweetsLiked"
            :tweet-author="tweetsLiked.tweet_user.name"
            :tweet-media="null"
            :tweet-media-count="0"
            :tweet-author-avatar="tweetsLiked.tweet_user.profile_picture_url"
            :tweet-author-username="tweetsLiked.tweet_user.username"
            :tweet-author-verified="tweetsLiked.tweet_user.premium"
            :tweet-content="tweetsLiked.content"
            :tweet-date="tweetsLiked.created_at"
            :tweet-likes="tweetsLiked.tweet_likes_aggregate.aggregate.count"
            :tweet-retweets="
              tweetsLiked.tweet_retweets_aggregate.aggregate.count
            "
            :tweet-replies="2547"
            :tweet-bookmarked="false"
            :tweet-liked="true"
            :tweet-retweeted="false"
            :tweet-replied="false"
            tweet-media="258"
            :tweet-views="25874123"
            :tweet-id="tweetsLiked.id"
            :tweet-thread="false"
            :user-id="authStore.user ? authStore.user.id : null"
            :users-liked="
              tweetsLiked.tweet_likes_aggregate.nodes.map(
                (like) => like.user_id
              )
            "
            :users-retweeted="
              tweetsLiked.tweet_retweets_aggregate.nodes.map(
                (retweet) => retweet.user_id
              )
            "
          />
        </TabPanel>
      </TabPanels>
    </TabGroup>
  </div>
  <div
    v-else-if="user == undefined"
    class="flex-1 flex items-center justify-center"
  >
    <h1 class="text-2xl font-bold">User not found</h1>
    <Button text="Go back home" class="mt-4" @click="router.push('/')"></Button>
  </div>
  <div v-else class="flex-1 flex items-center justify-center">
    <Loading />
  </div>
</template>

<script setup>
import SingleTweet from "../components/SingleTweet.vue";
import { GET_TWEETS } from "../api";
import { useAuthStore } from "../stores/authStore";
import IconLeft from "../components/icons/IconLeft.vue";
import IconVerified from "../components/icons/IconVerified.vue";
import IconCalendar from "../components/icons/IconCalendar.vue";
import IconBorn from "../components/icons/IconBorn.vue";
import IconMessage from "../components/icons/IconMessage.vue";
import Button from "../components/Button.vue";
import { useRouter, useRoute } from "vue-router";
import Loading from "../components/Loading.vue";
import { ref, onMounted, reactive } from "vue";
import {
  GET_USER_WITH_USERNAME,
  CREATE_CONVERSATION,
  FOLLOW_UNFOLLOW_USER,
  DOES_FOLLOW_USER,
  GET_TWEETS_BY_USER,
  GET_TWEET_BY_USER_LIKE,
} from "../api";
import { TabGroup, TabList, Tab, TabPanels, TabPanel } from "@headlessui/vue";
import { convertDate } from "../utils/helpers";

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
  tweets: [],
  tweetsLiked: [],
});

const username = ref(route.params.username);

onMounted(async () => {
  console.log(user.value);
  user.value = await GET_USER_WITH_USERNAME(username.value);
  console.log(user.value);

  if (authStore.user && user.value) {
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
  }

  textBtn.value = btnTextToDisplay();

  if (user.value) {
    const subscriptionTweets = GET_TWEETS_BY_USER(user.value.id);

    subscriptionTweets.subscribe({
      next: ({ data }) => {
        state.tweets = data.tweet;
      },
      error: (error) => {
        console.error(error);
      },
    });
    const subscriptionLikeTweets = GET_TWEET_BY_USER_LIKE(user.value.id);

    subscriptionLikeTweets.subscribe({
      next: ({ data }) => {
        state.tweetsLiked = data.tweet;
      },
      error: (error) => {
        console.error(error);
      },
    });
  }

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
  if (user.value && user.value.id === authStore.user.id) {
    return "Edit Profile";
  } else if (state.doesFollow) {
    return hover ? "Unfollow" : "Following";
  } else {
    return "Follow";
  }
};
</script>
