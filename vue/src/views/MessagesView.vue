<script setup>
    import IconSettings from '../components/icons/IconSettings.vue';
    import IconSearch from '../components/icons/IconSearch.vue';
    import IconNewMessage from '../components/icons/IconNewMessage.vue'
    import SingleMessage from '../components/SingleMessage.vue'
    import SingleChatMessage from '../components/SingleChatMessage.vue'
    import { TabGroup, TabList, Tab, TabPanels, TabPanel } from '@headlessui/vue'
</script>


<template>
    <div class=" justify-between">
    <div class=" relative w-[350px] border-r-[1px] border-current border-zinc-800">
        <div class="flex items-center">
            <div class="absolute top-1 left-3">
                <h1 class="font-black text-xl">Messages</h1>
            </div>
            <div class="flex absolute top-2 right-2 w-2/12 justify-between mr-5">
                <IconSettings class=""/>
                <IconNewMessage class=""/>
            </div>
        </div>
        <div class="flex items-center border-[1px] border-content border-zinc-700 rounded-full mt-16 mx-4">
            <IconSearch class="ml-3 border-zinc-700" />
            <input placeholder="Search Direct Message" class=" outline-none border-none p-3 bg-transparent flex-1">
        </div>
    </div>
        <div class="absolute w-fit">
            <TabGroup vertical>
                <TabList class="w-[350px] h-full border-r-[1px] border-current border-zinc-800 mr-3 pt-10">
                    <Tab class="w-full outline-none text-left"><SingleMessage accountPictureAuthor="/src/assets/img/mk.jpg" accountAuthor="Mia Kalifa" accountUserAuthor="miakalifa3" lastSend="16m" lastMessage="Big kisss !!"/></Tab>
                    <Tab class="w-full outline-none text-left"><SingleMessage accountPictureAuthor="/src/assets/img/cm.jpg" accountAuthor="Clara Morgane" accountUserAuthor="ClaraMorganeFC" lastSend="16m" lastMessage="Join my OnlyFan !!"/></Tab>
                </TabList>
                <TabPanels>
                    <TabPanel><SingleChatMessage accountPictureAuthor="/src/assets/img/mk.jpg"/></TabPanel>
                    <TabPanel><SingleChatMessage accountPictureAuthor="/src/assets/img/cm.jpg"/></TabPanel>
                </TabPanels>
            </TabGroup>
        </div>
    </div>
</template>

