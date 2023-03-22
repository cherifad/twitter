<script setup>
    import IconSearch from '../components/icons/IconSearch.vue';
    import IconSettings from '../components/icons/IconSettings.vue';    
    import SingleTrend from '../components/SingleTrend.vue';
</script>

<template>
    <div class="relative">
        <form class=" mb-3 mt-3 h-12">
            <div id="searchBar" class="flex items-center border-[1px] rounded-full" :class="searchFocus ? 'bg-white dark:bg-black border-blue': 'bg-[#eff3f4] dark:bg-[#16181c] dark:border-[#16181c] border-[#eff3f4]'">
                <IconSearch class="ml-3" :class="searchFocus ? 'text-blue' : 'text-[#536471]'" />
                <input @focusout="searchFocus = false" @focusin="searchFocus = true" id="search" type="text" placeholder="Search Twitter" class="outline-none border-none p-3 bg-transparent flex-1">
            </div>
            <IconSettings class="absolute top-7 right-5"/>
        </form>
        <div>
            <h1 class="relative font-extrabold text-xl top-3 left-5">Tendances pour vous</h1>
        </div>
        <div class=" mt-5">
            <SingleTrend title="#Macron13h" theme="Seulement sur Twitter · Tendances" ranking="1" :numberOfTweets="100000"/>
            <SingleTrend title="Squeezie" theme="Divertissement · Tendances" ranking="1" :numberOfTweets="3469" />          
            <SingleTrend title="Président de la République" theme="Tendances dans la catégorie Politique" ranking="1" :numberOfTweets="19400" />          
            <SingleTrend title="Président de la République" theme="Tendances" ranking="1" :numberOfTweets="19400" />          
            <SingleTrend title="Pemamanuel Pacron" theme="Tendances dans la catégorie Politique"/>          
            <SingleTrend title="Anne Sophie Lapix" theme="Tendances dans la catégorie France"/>          
        </div>
        <a href="#" class=" ml-4 text-blue text-xm">Voir plus</a>
    </div>
</template>

<style scoped>
    #searchBar{
        width: 80%;
        margin-left: 5%;
    }

</style>