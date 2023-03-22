<template>
    <div class="rounded-full hover:bg-gray dark:hover:bg-gray-hover flex w-full items-center justify-between p-3 cursor-pointer">
        <div class="flex items-center gap-3">
            <img v-if="avatar" :src="avatar" :alt="name">
            <IconTwitter v-else />
            <div>
                <p>{{ name }}</p>
                <p class="text-slate-700 dark:text-zinc-500">@{{ pseudo }}</p>
            </div>
        </div>
        <IconThreeDots />
    </div>
</template>

<script setup>
import IconThreeDots from "./icons/IconThreeDots.vue";
import IconTwitter from "./icons/IconTwitter.vue";

defineProps({
    name: {
        type: String,
        required: true
    },
    pseudo: {
        type: String,
        required: true
    },
    avatar: {
        type: String,
        required: false
    },
})
</script>