<script setup>
import { ref } from 'vue'

// defineProps({
//     accountPictureAuthor: {
//         type: String,
//         default: "",
//         required: true,
//     },
//     accountAuthor: {
//         type: String,
//         default: "",
//         required: true,
//     },
//     accountUserAuthor: {
//         type: String,
//         default: "",
//         required: true,
//     },
//     dateCreateAccount: {
//         type: String,
//         default: "",
//         required: true,
//     },
//     nbFollowers: {
//         type: String,
//         default: "",
//         required: true,
//     },
//     sendMessage: {
//         type: Boolean,
//         required: true,
//     },
//     messageUser: {
//         type: String,
//         default: "",
//         required: true,
//     }
// });

const array = ref([
    { "message": "Salut", "send": true },
    { "message": "t", "send": false },
    { "message": "bdrbdr", "send": true },
    { "message": "drtbrdtb", "send": true },
    { "message": "drtbdbrtb", "send": false },
    { "message": "drtbdrtbrd", "send": true },
    { "message": "t", "send": false },
    { "message": "bdrbdr", "send": true },
    { "message": "drtbrdtb", "send": true },
    { "message": "drtbdbrtb", "send": false },
    { "message": "drtbdrtbrd", "send": true },
    { "message": "rdtbrdtb", "send": false },
]);

</script>


<template>
    <!-- <div class="flex flex-col max-h-screen">
        <div class="  border-b-[1px] dark:border-zinc-800 border-zinc-200">
            <div class="w-full mt-10">
                <img :src="accountPictureAuthor" class=" w-1/6 rounded-full mx-auto">
            </div>
            <div class=" text-center">
                <h1 class=" mt-10">{{ accountAuthor }}</h1>
                <h1 class="text-zinc-700 mt-3">{{ accountUserAuthor }}</h1>
                <h1 class="text-zinc-700 mt-3">Joined {{ dateCreateAccount }} · {{ nbFollowers }} Follower(s)</h1>
                <h1 class="text-zinc-700 mt-3 mb-10">Not followed by RR anyone you’re following</h1>
            </div>
        </div>
        <div class="flex-1 flex flex-col overflow-scroll overflow-x-hidden">
            <singleChatBubble v-for="item in array" :send="item.send" :message="item.message" />
        </div>
        <div class="h-fit p-1 dark:border-zinc-800 border-zinc-200 border-t-[1px]">
            <div class=" bg-[rgb(239,244,243)] flex mx-3">
                <input type="text" class=" bg-transparent flex-1 outline-none" :placeholder="`Message ${accountUserAuthor}`">
            </div>
        </div>
    </div> -->
    <div>
        <h1>FROM COMPONENTcccfffff</h1>
    </div>
</template>