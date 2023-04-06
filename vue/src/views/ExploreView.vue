<script setup>
import IconSearch from "../components/icons/IconSearch.vue";
import IconSettings from "../components/icons/IconSettings.vue";
import SingleTrend from "../components/SingleTrend.vue";
import { useRoute, RouterLink } from "vue-router";
import { ref, onMounted, reactive, watch } from "vue";
import { GET_TWEETS_OF_HASHTAG, GET_TRENDING_HASHTAGS, SEARCH } from "../api";
import SingleTweet from "../components/SingleTweet.vue";
import SingleAccount from "../components/SingleAccount.vue";

const route = useRoute();
const formInput = ref("");
const searchFocus = ref(false);
const tendanceFor = ref("you");

const userInput = ref(false);

const state = reactive({
  tweets: [],
  users: [],
  hashtags: [],
  trendingHashtags: [],
});

async function search() {
  if (formInput.value != "") {
    const data = await SEARCH(formInput.value);

    state.tweets = data.data.tweet;
    state.users = data.data.user;
    console.log(state.users);
    state.hashtags = data.data.hashtag;
  }
}

watch(formInput, () => {
  if (formInput.value != "") {
    tendanceFor.value = formInput.value;
    userInput.value = true;
    search();
  } else {
    state.tweets = [];
    state.users = [];
    state.hashtags = [];
    tendanceFor.value = "you";
  }
});

const getTrending = async () => {
  const subscription = GET_TRENDING_HASHTAGS();

  subscription.subscribe({
    next: ({ data }) => {
      state.trendingHashtags = data.hashtag;
      console.log(state.trendingHashtags);
    },
    error: (error) => {
      console.error(error);
    },
  });
};

onMounted(() => {
  getTrending();
  if (route.query.q) {
    formInput.value = route.query.q;
    userInput.value = false;
  } 
});
</script>

<template>
  <div class="relative">
    <form class="mb-3 mt-3 h-12">
      <div id="searchBar" class="flex items-center border-[1px] rounded-full" :class="
        searchFocus
          ? 'bg-white dark:bg-black border-blue'
          : 'bg-[#eff3f4] dark:bg-[#16181c] dark:border-[#16181c] border-[#eff3f4]'
      ">
        <IconSearch class="ml-3" :class="searchFocus ? 'text-blue' : 'text-[#536471]'" />
        <input @focusout="searchFocus = false" @focusin="searchFocus = true" @change="searchFun" id="search" type="text"
          v-model="formInput" placeholder="Search Twitter" class="outline-none border-none p-3 bg-transparent flex-1" />
      </div>
      <IconSettings class="absolute top-7 right-5" />
    </form>
    <div>
      <h1 class="relative font-extrabold text-xl top-3 left-5 mb-3">
        {{ userInput ? 'Search For ' : 'Trending for ' }}<span class="text-blue">"{{ tendanceFor }}"</span>
      </h1>
    </div>
    <div>
      <div class="mt-5" v-if="state.trendingHashtags.length > 0 && formInput.length == 0">
        <RouterLink v-for="(item, index) in state.trendingHashtags" :to="`/search?q=%23${item.text.replace('#', '')}`"
          class="text-blue no-underline cursor-pointer hover:underline">
          <SingleTrend :title="item.text" theme="Seulement sur Twitter · Tendances" :ranking="index + 1"
            :numberOfTweets="item.number_of_tweets" />
        </RouterLink>
        <a href="#" class="ml-4 text-blue text-xm">Voir plus</a>
      </div>
    </div>
    <div id="#tweet">
      <SingleTweet v-if="state.tweets && route.query.q" v-for="tweet in state.tweets"
        :tweet-author="tweet.tweet_user.name" :tweet-media="null" :tweet-media-count="0"
        :tweet-author-avatar="tweet.tweet_user.profile_picture_url" :tweet-author-username="tweet.tweet_user.username"
        :tweet-author-verified="tweet.tweet_user.premium" :tweet-content="tweet.content" :tweet-date="tweet.created_at"
        :tweet-likes="tweet.tweet_likes_aggregate.aggregate.count"
        :tweet-retweets="tweet.tweet_retweets_aggregate.aggregate.count" :tweet-replies="2547" :tweet-bookmarked="false"
        :tweet-liked="true" :tweet-retweeted="false" :tweet-replied="false" tweet-media="258" :tweet-views="25874123"
        :tweet-id="tweet.id" :tweet-thread="false" />
    </div>
    <div id="#account">
      <SingleAccount v-if="state.users.length > 0" v-for="(item, index) in state.users"
        :account-picture-author="item.profile_picture_url" :account-user-author="item.username"
        :account-author="item.name" :user-id="item.id" />
    </div>
    <div id="#hashtag">
      <SingleTrend v-if="state.hashtags.length > 0" v-for="(item, index) in state.hashtags" :title="item.text"
        theme="Seulement sur Twitter · Tendances" :ranking="index + 1" :numberOfTweets="item.number_of_tweets" />
    </div>
  </div>
</template>

<style scoped>
#searchBar {
  width: 80%;
  margin-left: 5%;
}
</style>
