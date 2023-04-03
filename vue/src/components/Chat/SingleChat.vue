<template>
<div>
    <div class="pb-6">
        <div :class="fromUser ? 'flex justify-end text-right' : ''">
            <div :class="['w-[87.5%] pr-3', fromUser ? 'flex justify-end' : 'flex']">
                <div :class="['px-4 py-3 rounded-t-3xl ', fromUser ? 'rounded-br-[4px] dark:text-black text-white rounded-bl-3xl bg-blue' : 'rounded-bl-[4px] text-black dark:text-white rounded-br-3xl bg-[rgb(239,243,244)] dark:bg-[rgb(47,51,54)]']">
                    <div class="break-words">
                        {{ content }}
                    </div>
                </div>
            </div>
        </div>
        <div class=" mt-1">
            <div :class="fromUser ? 'flex justify-end text-right' : ''">
                <span class=" text-sm text-[rgb(113,118,123)]">{{ formatDate(createdAt) }}</span>
            </div>
        </div>
    </div>
</div>
</template>

<script setup>
import { formatDate } from '../../utils/helpers';

defineProps({
    content: {
        type: String,
        required: true
    },  
    createdAt: {
        type: String,
        required: true
    },
    tweetId: {
        type: String,
        required: false
    },
    mediaUrl: {
        type: String,
        required: false
    },
    fromUser: {
        type: Boolean,
        required: true
    },
});
</script>