<template>
    <button class="bg-blue hover:bg-blue-hover rounded-full h-14 text-white disabled:bg-blue/50 disabled:cursor-not-allowed min-w-fit px-5" :disabled="disabled">
        {{ text }}
    </button>
</template>

<script setup>
defineProps({
    text: {
        type: String,
        required: true
    },
    disabled: {
        type: Boolean,
        default: false
    }
})
</script>