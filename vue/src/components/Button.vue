<template>
    <button class="bg-blue hover:bg-blue-hover rounded-full h-14 text-white">
        {{ text }}
    </button>
</template>

<script setup>
defineProps({
    text: {
        type: String,
        required: true
    }
})
</script>