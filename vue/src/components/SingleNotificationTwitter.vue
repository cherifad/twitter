<script setup>
    import IconTwitter from './icons/IconTwitter.vue';

    defineProps({
        contentNotif: {
            type: String,
            default: "",
            required: true,
        },
    }
    );
</script>


<template>
    <div class="flex border-b-[1px] border-current border-zinc-800 p-2 text-sm">
        <div class=" relative justify-center flex w-2/12 items-center">
            <IconTwitter/>
        </div>
        <div class="flex w-5/6 items-center">
            <h1>{{ contentNotif }}</h1>
        </div>
    </div>
</template>