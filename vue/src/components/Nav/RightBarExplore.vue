
<script setup>
import IconSearch from '../icons/IconSearch.vue';
import SingleTrend from '../SingleTrend.vue';
import SingleAccount from '../SingleAccount.vue'
import { RouterLink } from 'vue-router';
import { ref, reactive } from 'vue';
import { GET_UNFOLLOWED_USERS } from '../../api';
import { useAuthStore } from '../../stores/authStore';

const search = ref('');
const searchFocus = ref(false);

const authStore = useAuthStore();

const state = reactive({
    users: [],
    doesFollow: false,
});

const subscription = GET_UNFOLLOWED_USERS(authStore.user ? authStore.user.id : "");

subscription.subscribe({
    next: ({ data }) => {
        state.users = data.user;
    },
});
</script>


<template>
    <div class="w-full flex-1 h-full mt-3">

        <div class="bg-[#f7f9f9] dark:bg-[#16181c] pt-5 rounded-2xl ">
            <span class="mx-4 mb-3 text-xl font-extrabold">Suggestions</span>
            <SingleAccount v-for="user in state.users" :doesFollow="state.doesFollow" :userId="user.id" :accountAuthor="user.name" :accountUserAuthor="user.username" :accountPictureAuthor="user.profile_picture_url"/>
            <!-- <SingleAccount accountAuthor="Adriana Chechik" accountUserAuthor="CheckikTv" accountPictureAuthor="/src/assets/img/ac.jpg"/>
            <SingleAccount accountAuthor="ClaraMorgane FanClub" accountUserAuthor="ClaraMorganeFC" accountPictureAuthor="/src/assets/img/cm.jpg"/> -->
            <div class="px-4 py-3 ring-gray-hover">
                <RouterLink to="/explore" class="text-sm text-blue">Voir plus</RouterLink>
            </div>
            <img src="" alt="">
        </div>
    </div>
</template>


<style scoped>

</style>