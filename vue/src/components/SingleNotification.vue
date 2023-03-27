<script setup>
    import IconNotificationUser from './icons/IconNotificationUser.vue';

    defineProps({
        contentNotif: {
            type: String,
            default: "",
            required: true,
        },
        accountPictureUser: {
            type: String,
            default: "",
            required: true,
        },
        accountNameUser: {
            type: String,
            default: "",
            required: true,
        },
    }
    );
</script>


<template>
    <div class="flex border-b-[1px] border-current dark:border-zinc-800 border-zinc-200 p-2 text-sm">
        <div class=" relative justify-center flex w-2/12 items-center">
            <IconNotificationUser/>
        </div>
        <div class=" w-5/6 items-center">
            <img :src=accountPictureUser class="w-12 h-12 rounded-full">
            <div class=" ml-2">
                <h1 class=" mt-5">{{ accountNameUser }}</h1>
                <h1 class=" mt-5 text-zinc-700 font-bold">{{ contentNotif }}</h1>
            </div>
        </div>
    </div>
</template>