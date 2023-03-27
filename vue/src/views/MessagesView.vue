<script setup>
import IconSettings from "../components/icons/IconSettings.vue";
import IconSearch from "../components/icons/IconSearch.vue";
import IconNewMessage from "../components/icons/IconNewMessage.vue";
import SingleMessage from "../components/SingleMessage.vue";
import SingleChatMessage from "../components/SingleChatMessage.vue";
import { TabGroup, TabList, Tab, TabPanels, TabPanel } from "@headlessui/vue";
import Button from "../components/Button.vue";
</script>

<template>
  <div class="h-full w-full">
    <TabGroup vertical :defaultIndex="1">
      <div class="flex h-full">
        <TabList
          class="w-[350px] h-full border-r-[1px] border-current border-zinc-800 mr-3 flex flex-col"
        >
          <div
            class="w-[350px] border-r-[1px] border-current border-zinc-800 px-4"
          >
            <div class="flex items-center justify-between h-[53px]">
              <div>
                <h1 class="font-black text-xl">Messages</h1>
              </div>
              <div class="flex justify-between gap-3">
                <IconSettings class="" />
                <IconNewMessage class="" />
              </div>
            </div>
            <div class="py-3">
              <div
                class="flex gap-2 items-center justify-center border-[1px] border-content border-zinc-700 rounded-full min-h-[40px]"
              >
                <IconSearch class="border-zinc-700" />
                <input
                  placeholder="Search Direct Message"
                  class="outline-none border-none bg-transparent"
                />
              </div>
            </div>
          </div>
          <!--Default-->
          <Tab class="w-0 h-0"></Tab>
          <Tab
            class="w-full outline-none text-left"
            as="template"
            v-slot="{ selected }"
            ><SingleMessage
              :selected="selected"
              accountPictureAuthor="/src/assets/img/mk.jpg"
              accountAuthor="Mia Kalifa"
              accountUserAuthor="miakalifa3"
              lastSend="16m"
              lastMessage="Big kisss !!"
          /></Tab>
          <Tab
            class="w-full outline-none text-left"
            as="template"
            v-slot="{ selected }"
            ><SingleMessage
              :selected="selected"
              accountPictureAuthor="/src/assets/img/cm.jpg"
              accountAuthor="Clara Morgane"
              accountUserAuthor="ClaraMorganeFC"
              lastSend="16m"
              lastMessage="Join my OnlyFan !!"
          /></Tab>
        </TabList>
        <TabPanels class="flex-1 flex flex-col border-r-[1px] border-current border-zinc-800">
          <TabPanel class="flex-1 flex items-center justify-center">
            <div class="flex flex-col px-8 my-8 mx-auto max-w-[400px]">
                <span class=" text-3xl font-extrabold">Select a message</span>
                <span class="text-[rgb(113, 118, 123)] text-sm font-normal">Choose from your existing conversations, start a new one, or just keep swimming.</span>
                <Button class="mt-8" text="New Message" />
            </div>
          </TabPanel>
          <TabPanel>
            <SingleChatMessage messageUser="Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." :sendMessage="true" nbFollowers="15194525" accountPictureAuthor="/src/assets/img/mk.jpg" dateCreateAccount="March 2023" accountAuthor="Mia Kalifa" accountUserAuthor="Miakalifa3"/>
          </TabPanel>
          <TabPanel>
            <SingleChatMessage messageUser="Reçu" :sendMessage="false" nbFollowers="37537637" accountPictureAuthor="/src/assets/img/cm.jpg" dateCreateAccount="September 2021" accountAuthor="ClaraMorgane FanClub" accountUserAuthor="ClaraMorganeFC"/>
          </TabPanel>
        </TabPanels>
      </div>
    </TabGroup>
  </div>
</template>
