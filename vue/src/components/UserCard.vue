<template>
    <div>
        <Popover class="relative">
            <PopoverPanel class="absolute top-0 transform" >
                <div class="grid grid-cols-2">
                    <a href="/analytics">Analytics</a>
                    <a href="/engagement">Engagement</a>
                    <a href="/security">Security</a>
                    <a href="/integrations">Integrations</a>
                </div>
                <img src="/solutions.jpg" alt="" />
            </PopoverPanel>
            <PopoverButton class="" :class="`top-[-${toAddHeight + 5}px] w-full`">
                {{ toAddHeight }}
                <div
                    class="rounded-full hover:bg-gray dark:hover:bg-gray-hover flex w-full items-center justify-between p-3 cursor-pointer">
                    <div class="flex items-center gap-3">
                        <img class="rounded-full w-10 h-10" :src="avatar ? avatar : '/src/assets/img/default-avatar.webp'"
                            :alt="name">
                        <div class="flex flex-col items-start">
                            <p class="flex items-center gap-2">{{ name }}
                                <IconVerified v-if="verified" />
                            </p>
                            <p class="text-slate-700 dark:text-zinc-500">@{{ pseudo }}</p>
                        </div>
                    </div>
                    <IconThreeDots />
                </div>
            </PopoverButton>
        </Popover>
    </div>
</template>

<script setup>
import IconThreeDots from "./icons/IconThreeDots.vue";
import IconVerified from "./icons/IconVerified.vue";
import { Popover, PopoverButton, PopoverPanel } from '@headlessui/vue';
import { ref, onMounted, watch } from 'vue';

const toAddHeight = ref(0);

function consoleLogel(el) {
    console.log(Object.keys(el));
}

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
    verified: {
        type: Boolean,
        required: false
    }
})
</script>