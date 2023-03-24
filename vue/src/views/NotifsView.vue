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
                    <SingleNotification accountPictureUser="../src/assets/img/mk.jpg" accountNameUser="Miakalifa3" contentNotif="Go to my bed ?"/>
                    <SingleNotificationTwitter contentNotif="There was a login to your account @JulesSil1 from a new device on 21 mars 2023. Review it now."/>
                </TabPanel>
                <TabPanel>
                    <div>
                        <div class=" flex justify-center w-full">
                            <img src="https://abs.twimg.com/responsive-web/client-web/verification-check-400x200.v1.46c9cb39.png">
                        </div>
                        <div class=" px-40">
                            <div class="text-zinc-700">
                            <h1 class="text-white text-3xl font-black">Nothing to see here — yet</h1>
                                Likes, mentions, Retweets, and a whole lot more — when it comes from a verified account, you’ll find it here. <a href="https://help.twitter.com/managing-your-account/about-twitter-verified-accounts" target="_blank"><span class="text-white">Learn more</span></a>
                            </div>
                        </div>
                    </div>
                </TabPanel>
                <TabPanel>
                    <img alt="" draggable="true" src="https://abs.twimg.com/responsive-web/client-web/illustration_unmention_1200w.a6d67a6a.png" class="css-9pa8cd">
                    <div class="css-1dbjc4n r-494qqr p-10 border-b-[1px] border-current border-zinc-800" data-testid="inlinePrompt">
                    <h1 dir="ltr" role="heading"><span class="css-901oao css-16my406 r-poiln3 r-bcqeeo r-qvutc0 font-black text-3xl ">Control which conversations you’re mentioned in</span></h1>
                    <div dir="ltr" class="css-901oao r-1bwzh9t r-37j5jr r-a023e6 r-16dba41 r-rjixqe r-knv0ih r-bcqeeo r-fdjqy7 r-qvutc0 pt-4 text-zinc-700">
                        Use the action menu — those three little dots on a Tweet — to untag yourself and leave a conversation. <span role="button" tabindex="0" class="css-18t94o4 css-901oao css-16my406 r-1nao33i r-poiln3 r-1b43r93 r-b88u0q r-1cwl3u0 r-bcqeeo r-1ddef8g r-tjvw6i r-3s2u2q r-qvutc0"><span class="css-901oao css-16my406 r-poiln3 r-bcqeeo r-qvutc0">Learn more</span></span>
                    </div>
                    </div>
                    <SingleMention contentNotif="Do you want to come in my bed ?" account="JulosSs_05" accountName="Mia Kalifa" accountNameUser="miakalifa3" accountPictureUser="../src/assets/img/mk.jpg" tweetReplies="5" tweetRetweets="120" tweetLikes="15000"/>
                    <SingleMention contentNotif="Do you want to come in my bed ?" account="JulosSs_05" accountName="Adriana Chechik" accountNameUser="adriana_checkik_tv" accountPictureUser="../src/assets/img/ac.jpg" tweetReplies="8963" tweetRetweets="13000" tweetLikes="370000"/>
                </TabPanel>
            </TabPanels>
        </TabGroup>
    </div>
</template>

<script setup>
import { TabGroup, TabList, TabPanel, TabPanels, Tab } from '@headlessui/vue';

import IconSettings from '../components/icons/IconSettings.vue'; 
import SingleNotificationTwitter from '../components/SingleNotificationTwitter.vue';
import SingleNotification from '../components/SingleNotification.vue';
import SingleMention from '../components/SingleMention.vue';

</script>