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
        }
    }
    );

</script>


<template>
    <div class="flex justify-between items-center mt-5">
        <div class="flex items-center">
            <div class=" ml-5">
                <img :src=accountPictureAuthor class="w-12 h-12 rounded-full">
            </div>
            <div class=" ml-4">
                <h1 class=" text-sl font-black">{{ accountAuthor }}</h1>
                <h1 class=" text-sl font-normal text-gray-light">@{{ accountUserAuthor }}</h1>
            </div>

        </div>
        <div class="flex items-center">
            <button class=" mr-7 rounded-full bg-black text-white font-black px-4 text-sm min-h-[32px] dark:bg-white dark:text-black">Follow</button>
        </div>
    </div>
</template>