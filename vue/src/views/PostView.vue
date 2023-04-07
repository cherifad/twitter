<template>
    <div class="post-view" v-if="!loading">
        <SingleTweet :tweet-author="state.tweet.tweet_user.name" :tweet-media="null" :tweet-media-count="0"
            :tweet-author-avatar="state.tweet.tweet_user.profile_picture_url"
            :tweet-author-username="state.tweet.tweet_user.username" :tweet-author-verified="state.tweet.tweet_user.premium"
            :tweet-content="state.tweet.content" :tweet-date="state.tweet.created_at"
            :tweet-likes="state.tweet.tweet_likes_aggregate.aggregate.count"
            :tweet-retweets="state.tweet.tweet_retweets_aggregate.aggregate.count" :tweet-replies="state.tweet.tweet_replies_aggregate.aggregate.count"
            :tweet-bookmarked="false" :tweet-liked="true" :tweet-retweeted="false" :tweet-replied="false" tweet-media="258"
            :tweet-views="25874123" :tweet-id="state.tweet.id" :tweet-thread="false"
            :user-id="auths.user ? auths.user.id : null"
            :users-liked="state.tweet.tweet_likes_aggregate.nodes.map((like) => like.user_id)"
            :users-retweeted="state.tweet.tweet_retweets_aggregate.nodes.map((retweet) => retweet.user_id)" />
        <div class="flex">
            <div class="w-1 mx-4 my-3 dark:bg-zinc-800 bg-zinc-200 rounded-full">

            </div>
            <div class="flex flex-col flex-1">
                <SingleTweet class="flex-1" v-if="state.tweet.tweet_replies" v-for="tweet in state.tweet.tweet_replies" :tweet-author="tweet.tweet_user.name" :tweet-media="null"
                    :tweet-media-count="0" :tweet-author-avatar="tweet.tweet_user.profile_picture_url"
                    :tweet-author-username="tweet.tweet_user.username" :tweet-author-verified="tweet.tweet_user.premium"
                    :tweet-content="tweet.content" :tweet-date="tweet.created_at"
                    :tweet-likes="tweet.tweet_likes_aggregate.aggregate.count"
                    :tweet-retweets="tweet.tweet_retweets_aggregate.aggregate.count" :tweet-replies="0"
                    :with-response="false"
                    :tweet-bookmarked="false" :tweet-liked="true" :tweet-retweeted="false" :tweet-replied="false"
                    tweet-media="258" :tweet-views="25874123" :tweet-id="tweet.id" :tweet-thread="false"
                    :user-id="auths.user ? auths.user.id : null"
                    :users-liked="tweet.tweet_likes_aggregate.nodes.map((like) => like.user_id)"
                    :users-retweeted="tweet.tweet_retweets_aggregate.nodes.map((retweet) => retweet.user_id)" />
            </div>
        </div>
    </div>
    <div v-else class="w-full flex-1 items-center justify-center flex">
        <Loading />
    </div>
</template>

<script setup>
import { useRoute } from 'vue-router';
import { reactive, ref } from 'vue';
import SingleTweet from '../components/SingleTweet.vue';
import Loading from '../components/Loading.vue';
import { GET_SINGLE_TWEET } from '../api';
import { useAuthStore } from '../stores/authStore';

const route = useRoute();
const loading = ref(true);
const auths = useAuthStore();

const state = reactive({
    tweet: {},
});

const subscription = GET_SINGLE_TWEET(route.params.id);

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