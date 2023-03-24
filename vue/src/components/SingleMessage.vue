<script setup>
    defineProps({
        accountPictureAuthor: {
            type: String,
            default: "",
            required: true,
        },
        accountAuthor: {
            type: String,
            default: "",
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
    <div :class="selected ? 'border-r-[2px] border-blue bg-[#16181c]' : ''" class="flex justify-between items-center  py-4 hover:bg-[#16181c] hover:border-r-[2px] hover:border-blue hover:cursor-pointer w-full">
        <div class="flex items-center">
            <div class=" ml-5">
                <img :src=accountPictureAuthor class="w-12 h-12 rounded-full">
            </div>
            <div class=" ml-4">
                <h1 class=" text-sl font-black text-white">{{ accountAuthor }} <span class=" font-thin text-zinc-600">@{{ accountUserAuthor }} · {{ lastSend }}</span></h1>
                <h1 class=" text-sl font-normal text-white">{{ lastMessage }}</h1>
            </div>
        </div>
    </div>
</template>