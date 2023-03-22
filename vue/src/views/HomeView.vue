<template>
    <div>
        <div class=" px-4 items-center h-14 flex">
            <span class="text-xl font-bold">Home</span>
        </div>
        <NewTweet />
        <SingleTweet tweet-author="Kardesh" :tweet-media="medias" :tweet-media-count="medias.length" tweet-author-avatar="/src/assets/img/default-avatar.webp" tweet-author-username="guvton93i" :tweet-author-verified="true" tweet-content="Ptdrrrr il va voir comment cest la France en ce moment il voudra retourner au Sahel" tweet-date="2023-03-21T13:50:06.000Z" tweet-likes="258963" tweet-retweets="25896" tweet-replies="2547" :tweet-bookmarked="false" :tweet-liked="true" :tweet-retweeted="false" :tweet-replied="false" tweet-media="258" :tweet-views="25874123" tweet-id="2" :tweet-thread="false" />
    </div>
</template>

<script setup>
import NewTweet from '../components/NewTweet.vue';
import SingleTweet from '../components/SingleTweet.vue';

const medias = [
    {
        id: 1,
        url: '/src/assets/img/default-avatar.webp',
        alt: 'default-avatar'
    },
    {
        id: 2,
        url: '/src/assets/img/default-avatar.webp',
        alt: 'default-avatar'
    },
    {
        id: 3,
        url: '/src/assets/img/default-avatar.webp',
        alt: 'default-avatar'
    }
]

</script>