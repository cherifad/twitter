
<script setup>
import IconSearch from '../icons/IconSearch.vue';
import SingleTrend from '../SingleTrend.vue';
import SingleAccount from '../SingleAccount.vue'
import { RouterLink } from 'vue-router';
import { ref } from 'vue';

const search = ref('');
const searchFocus = ref(false);
</script>


<template>
    <div class="w-full flex-1 h-full">

        <div class="bg-[#f7f9f9] dark:bg-[#16181c] pt-3 rounded-2xl">
            <span class="mx-4 mb-3 text-xl font-extrabold">Suggestions</span>
            <SingleAccount accountAuthor="Mia Kalifa" accountUserAuthor="Miakalifa3" accountPictureAuthor="/src/assets/img/mk.jpg"/>
            <SingleAccount accountAuthor="Mia Kalifa" accountUserAuthor="Miakalifa3" accountPictureAuthor="/src/assets/img/mk.jpg"/>
            <SingleAccount accountAuthor="Mia Kalifa" accountUserAuthor="Miakalifa3" accountPictureAuthor="/src/assets/img/mk.jpg"/>
            <div class="px-4 py-3 ring-gray-hover">
                <RouterLink to="/explore" class="text-sm text-blue">Voir plus</RouterLink>
            </div>
            <img src="" alt="">
        </div>
    </div>
</template>


<style scoped>

</style>