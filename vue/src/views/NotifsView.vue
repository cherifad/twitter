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
                <TabPanel>
                    <SingleNotificationTwitter contentNotif="There was a login to your account @JulesSil1 from a new device on 22 mars 2023. Review it now."/>
                    <SingleNotificationTwitter contentNotif="There was a login to your account @JulesSil1 from a new device on 22 mars 2023. Review it now."/>
                    <SingleNotification  accountPictureUser="../src/assets/img/mk.jpg" accountNameUser="Miakalifa3" contentNotif="Go to my bed ?"/>
                    <SingleNotificationTwitter contentNotif="There was a login to your account @JulesSil1 from a new device on 21 mars 2023. Review it now."/>
                </TabPanel>
                <TabPanel>
                    <img alt="" draggable="true" src="https://abs.twimg.com/responsive-web/client-web/illustration_unmention_1200w.a6d67a6a.png" class="css-9pa8cd">
                </TabPanel>
                <TabPanel>content 3</TabPanel>
            </TabPanels>
        </TabGroup>
    </div>
</template>

<script setup>
import { TabGroup, TabList, TabPanel, TabPanels, Tab } from '@headlessui/vue';

import IconSettings from '../components/icons/IconSettings.vue'; 
import SingleNotificationTwitter from '../components/SingleNotificationTwitter.vue';
import SingleNotification from '../components/SingleNotification.vue';

</script>