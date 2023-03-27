<template>
    <div class="w-full flex-1 h-full">
        <form class=" mb-3 mt-1 h-12">
            <div id="searchBar" class="flex items-center border-[1px] rounded-full" :class="searchFocus ? 'bg-white dark:bg-black border-blue': 'bg-[#eff3f4] dark:bg-[#16181c] dark:border-[#16181c] border-[#eff3f4]'">
                <IconSearch class="ml-3" :class="searchFocus ? 'text-blue' : 'text-[#536471]'" />
                <input @focusout="searchFocus = false" @focusin="searchFocus = true" id="search" type="text" placeholder="Search Twitter" class="outline-none border-none p-3 bg-transparent flex-1">
            </div>
        </form>
        <div class="bg-[#f7f9f9] dark:bg-[#16181c] pt-3 rounded-2xl">
            <span class="mx-4 mb-3 text-xl font-extrabold">Trends for you</span>
            <SingleTrend title="Trending in Nigeria" theme="Nigeria" :ranking="1" :numberOfTweets="1000000" />
            <SingleTrend title="Trending in Nigeria" theme="Nigeria" :ranking="2" :numberOfTweets="1000000" />
            <SingleTrend title="Trending in Nigeria" theme="Nigeria" :ranking="3" :numberOfTweets="1000000" />
            <SingleTrend title="Trending in Nigeria" theme="Nigeria" :ranking="4" :numberOfTweets="1000000" />
            <SingleTrend title="Trending in Nigeria" theme="Nigeria" :ranking="5" :numberOfTweets="1000000" />
            <div class="px-4 py-3 ring-gray-hover">
                <RouterLink to="/explore" class="text-sm text-blue">Show more</RouterLink>
            </div>
        </div>
    </div>
</template>

<script setup>
import IconSearch from '../icons/IconSearch.vue';
import SingleTrend from '../SingleTrend.vue';
import { RouterLink } from 'vue-router';
import { ref } from 'vue';

const search = ref('');
const searchFocus = ref(false);
</script>

<style scoped>

</style>