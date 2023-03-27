<template>
  <div class="flex flex-col max-h-screen">
    <div class="px-4 items-center h-14 flex">
      <span class="text-xl font-bold">Home</span>
    </div>
    <NewTweet />
    <div class="flex-1">
        <SingleTweet
          v-if="state.tweets"
          v-for="tweet in state.tweets"
          :tweet-author="tweet.tweet_user.name"
          :tweet-media="null"
          :tweet-media-count="0"
          :tweet-author-avatar="tweet.tweet_user.profile_picture_url"
          :tweet-author-username="tweet.tweet_user.username"
          :tweet-author-verified="tweet.premium"
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
        />
    </div>
  </div>
</template>

<script setup>
import NewTweet from "../components/NewTweet.vue";
import SingleTweet from "../components/SingleTweet.vue";
import { reactive } from "vue";
import { GET_TWEETS } from "../api";

const state = reactive({
  tweets: [],
});

(async () => {
  state.tweets = await GET_TWEETS();
  console.log(state.tweets);
})();

</script>
