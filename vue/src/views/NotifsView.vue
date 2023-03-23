<template>
    <div class="relative">
        <h1 class="flex relative font-extrabold text-xl top-3 left-5">Notifications</h1>
        <IconSettings class="absolute top-5 right-5"/>
        <TabGroup>
            <TabList class="flex mt-5">
                <Tab class="flex-1 font-bold text-xm top-3 text-zinc-700 py-4 hover:bg-zinc-800">All</Tab>
                <Tab class="flex-1 font-bold text-xm top-3 text-zinc-700 py-4 hover:bg-zinc-800">Verfied</Tab>
                <Tab class="flex-1 font-bold text-xm top-3 text-zinc-700 py-4 hover:bg-zinc-800">Mentions</Tab>
            </TabList>
            <TabPanels>
                <TabPanel>content 1</TabPanel>
                <TabPanel>content 2</TabPanel>
                <TabPanel>content 3</TabPanel>
            </TabPanels>
        </TabGroup>
    </div>
</template>

<script setup>
import { TabGroup, TabList, TabPanel, TabPanels, Tab } from '@headlessui/vue';

import IconSettings from '../components/icons/IconSettings.vue'; 

</script>