<template>
    <div>
      <SingleTweet
          v-if="state.tweet.parent_tweet_id == null && !loading"
          :with-response="false"
          :tweet-author="state.tweet.tweet_user.name"
          :tweet-media="null"
          :tweet-media-count="0"
          :tweet-author-avatar="state.tweet.tweet_user.profile_picture_url"
          :tweet-author-username="state.tweet.tweet_user.username"
          :tweet-author-verified="state.tweet.tweet_user.premium"
          :tweet-content="state.tweet.content"
          :tweet-date="state.tweet.created_at"
          :tweet-likes="state.tweet.tweet_likes_aggregate.aggregate.count"
          :tweet-retweets="state.tweet.tweet_retweets_aggregate.aggregate.count"
          :tweet-replies="2547"
          :tweet-bookmarked="false"
          :tweet-liked="true"
          :tweet-retweeted="false"
          :tweet-replied="false"
          tweet-media="258"
          :tweet-views="25874123"
          :tweet-id="state.tweet.id"
          :tweet-thread="false"
          :user-id="auths.user? auths.user.id : null"
          :users-liked="state.tweet.tweet_likes_aggregate.nodes.map((like) => like.user_id)"
          :users-retweeted="state.tweet.tweet_retweets_aggregate.nodes.map((retweet) => retweet.user_id)"
        />      
    </div>
</template>

<script setup>
import SingleTweet from '../SingleTweet.vue';
import { useAuthStore } from '../../stores/authStore';
import { GET_SINGLE_TWEET } from '../../api';
import { reactive, ref } from 'vue';

const auths = useAuthStore();
const loading = ref(true);

const props = defineProps({
  tweetId: {
    type: String,
    required: true,
  },
});

const state = reactive({
  tweet: {},
});

const subscription = GET_SINGLE_TWEET(props.tweetId);

subscription.subscribe({
  next: ({ data }) => {
    state.tweet = data.tweet[0];
    loading.value = false;
  },
  error: (error) => {
    console.error(error);
  },
});


</script>