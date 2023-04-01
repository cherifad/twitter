<script setup>
    defineProps({
        accountPictureAuthor: {
            type: String,
            required: false,
        },
        accountAuthor: {
            type: String,
            required: true,
        },
        accountUserAuthor: {
            type: String,
            default: "",
            required: true,
        },
        lastSend: {
            type: String,
            default: "",
            required: true,
        },
        lastMessage: {
            type: String,
            default: "",
            required: true,
        },
        selected: {
            type: Boolean,
            default: false,
            required: true,
        },
    }
    );

</script>


<template>
    <div :class="selected ? 'border-r-[2px] border-blue dark:bg-[#16181c] bg-[#eff3f4]' : ''" class="flex justify-between items-center  py-4 dark:hover:bg-[#16181c] hover:bg-[#f7f9f9] hover:border-r-[2px] hover:border-blue hover:cursor-pointer w-full">
        <div class="flex items-center">
            <div class=" ml-5">
                <img :src="accountPictureAuthor ? accountPictureAuthor : '/src/assets/img/default-avatar.webp'" class="w-12 h-12 rounded-full">
            </div>
            <div class=" ml-4">
                <h1 class=" text-sl font-black dark:text-white">{{ accountAuthor }} <span class=" font-thin text-zinc-600">@{{ accountUserAuthor }} · {{ lastSend }}</span></h1>
                <h1 class=" text-sl font-normal dark:text-white">{{ lastMessage }}</h1>
            </div>
        </div>
    </div>
</template>