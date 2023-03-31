<script setup>
import IconSearch from "../components/icons/IconSearch.vue";
import IconSettings from "../components/icons/IconSettings.vue";
import SingleTrend from "../components/SingleTrend.vue";
import { useRoute } from "vue-router";
import { ref, onMounted, reactive } from "vue";
import { GET_TWEETS_OF_HASHTAG } from "../api";
import SingleTweet from "../components/SingleTweet.vue";

const route = useRoute();
const formInput = ref("");
const searchFocus = ref(false);

const state = reactive({
  tweets: [],
});

onMounted(() => {
  if (route.query.q && route.name == "Search") {
    formInput.value = route.query.q;
    const subscription = GET_TWEETS_OF_HASHTAG(formInput.value);

    subscription.subscribe({
      next: ({ data }) => {
        console.log(data);
        state.tweets = data.hashtag[0].tweet_hashtags;
      },
      error: (error) => {
        console.error(error);
      },
    });
  }
});
</script>

<template>
  <div class="relative">
    <form class="mb-3 mt-3 h-12">
      <div
        id="searchBar"
        class="flex items-center border-[1px] rounded-full"
        :class="
          searchFocus
            ? 'bg-white dark:bg-black border-blue'
            : 'bg-[#eff3f4] dark:bg-[#16181c] dark:border-[#16181c] border-[#eff3f4]'
        "
      >
        <IconSearch
          class="ml-3"
          :class="searchFocus ? 'text-blue' : 'text-[#536471]'"
        />
        <input
          @focusout="searchFocus = false"
          @focusin="searchFocus = true"
          id="search"
          type="text"
          v-model="formInput"
          placeholder="Search Twitter"
          class="outline-none border-none p-3 bg-transparent flex-1"
        />
      </div>
      <IconSettings class="absolute top-7 right-5" />
    </form>
    <div>
      <h1 class="relative font-extrabold text-xl top-3 left-5">
        Tendances pour vous
      </h1>
    </div>
    <div class="mt-5" v-if="route.name != 'Search'">
      <SingleTrend
        title="#Macron13h"
        theme="Seulement sur Twitter · Tendances"
        :ranking="1"
        :numberOfTweets="100000"
      />
      <SingleTrend
        title="Squeezie"
        theme="Divertissement · Tendances"
        :ranking="1"
        :numberOfTweets="3469"
      />
      <SingleTrend
        title="Président de la République"
        theme="Tendances dans la catégorie Politique"
        :ranking="1"
        :numberOfTweets="19400"
      />
      <SingleTrend
        title="Président de la République"
        theme="Tendances"
        :ranking="1"
        :numberOfTweets="19400"
      />
      <SingleTrend
        title="Pemamanuel Pacron"
        theme="Tendances dans la catégorie Politique"
        :ranking="2"
      />
      <SingleTrend
        title="Anne Sophie Lapix"
        theme="Tendances dans la catégorie France"
        :ranking="3"
      />
    </div>
    <div v-else>
      <SingleTweet
        v-if="state.tweets"
        v-for="tweet in state.tweets"
        :tweet-author="tweet.tweet.tweet_user.name"
        :tweet-media="null"
        :tweet-media-count="0"
        :tweet-author-avatar="tweet.tweet.tweet_user.profile_picture_url"
        :tweet-author-username="tweet.tweet.tweet_user.username"
        :tweet-author-verified="tweet.tweet.tweet_user.premium"
        :tweet-content="tweet.tweet.content"
        :tweet-date="tweet.tweet.created_at"
        :tweet-likes="tweet.tweet.tweet_likes_aggregate.aggregate.count"
        :tweet-retweets="tweet.tweet.tweet_retweets_aggregate.aggregate.count"
        :tweet-replies="2547"
        :tweet-bookmarked="false"
        :tweet-liked="true"
        :tweet-retweeted="false"
        :tweet-replied="false"
        tweet-media="258"
        :tweet-views="25874123"
        :tweet-id="tweet.tweet.id"
        :tweet-thread="false"
      />
    </div>
    <a href="#" class="ml-4 text-blue text-xm">Voir plus</a>
  </div>
</template>

<style scoped>
#searchBar {
  width: 80%;
  margin-left: 5%;
}
</style>
