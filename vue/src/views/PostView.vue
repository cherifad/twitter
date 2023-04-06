<template>

</template>

<script setup>
import { useRoute } from 'vue-router';

const route = useRoute();

const state = reactive({
    tweet: {},
});

const subscription = GET_TWEET(route.params.id);

subscription.subscribe({
    next: ({ data }) => {
        state.tweet = data.tweet[0];
    },
    error: (error) => {
        console.error(error);
    },
});
</script>