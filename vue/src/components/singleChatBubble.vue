<script setup>
defineProps({
    send: {
        type: Boolean,
        required: true,
    },
    message: {
        type: String,
        default: "",
        required: true,
    },
});

</script>


<template>
    <div class="flex flex-col">
        <div v-if="send == true" class="w-full">
            <h1
                class=" max-w-[450px] w-fit bg-blue text-white rounded-2xl rounded-br-sm px-[20px] py-[3px] float-right mr-2 mt-4">
                {{ message }}</h1>
        </div>
        <div v-else class="">
            <h1
                class=" max-w-[450px] w-fit bg-zinc-500 text-white rounded-2xl rounded-bl-sm px-[20px] py-[3px] float-left mr-2 mt-4">
                {{ message }}</h1>
    </div>
</div></template>