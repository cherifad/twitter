<template>
    <div class="rounded-full hover:bg-gray dark:hover:bg-gray-hover flex w-full items-center justify-between p-3 cursor-pointer">
        <div class="flex items-center gap-3">
            <img class="rounded-full w-10 h-10" :src="avatar ? avatar : '/src/assets/img/default-avatar.webp'" :alt="name">
            <!-- <IconTwitter v-else /> -->
            <div>
                <p class="flex items-center gap-2">{{ name }} <IconVerified v-if="verified" /></p>
                <p class="text-slate-700 dark:text-zinc-500">@{{ pseudo }}</p>
            </div>
        </div>
        <IconThreeDots />
    </div>
</template>

<script setup>
import IconThreeDots from "./icons/IconThreeDots.vue";
import IconVerified from "./icons/IconVerified.vue";

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
    verified : {
        type: Boolean,
        required: false
    }
})
</script>