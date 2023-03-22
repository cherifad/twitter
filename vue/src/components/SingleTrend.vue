<template>
    <div>
        <div class="text-gray-light text-sm">
            <span>{{ ranking }}</span>
            <span>{{ theme }}</span>
            <span>Trending</span>
        </div>
    </div>
</template>

<script setup>
defineProps({
    ranking: {
        type: Number,
        required: true
    },
    theme: {
        type: String,
        required: true
    },
    title: {
        type: String,
        required: true
    },
    numberOfTweets: {
        type: Number,
        required: true
    },
})
</script>