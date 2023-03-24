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
    });

</script>


<template>
    <div class="">
        <div class="">
            <img :src=accountPictureAuthor >
        </div>
    </div>
</template>