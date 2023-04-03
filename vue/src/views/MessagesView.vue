<script setup>
import IconSettings from "../components/icons/IconSettings.vue";
import IconSearch from "../components/icons/IconSearch.vue";
import IconNewMessage from "../components/icons/IconNewMessage.vue";
import SingleMessage from "../components/SingleMessage.vue";
import { TabGroup, TabList, Tab, TabPanels, TabPanel } from "@headlessui/vue";
import Button from "../components/Button.vue";
import ChatFeed from "../components/Chat/ChatFeed.vue";
import { useAuthStore } from "../stores/authStore";
import { GET_CONVERSATION_OF_USER } from "../api";
import { reactive } from "vue";
import { timeSince } from "../utils/helpers";

const authStore = useAuthStore();

const state = reactive({
  conversations: [],
});

const subscription = GET_CONVERSATION_OF_USER(authStore.user.id);

console.log(subscription);

subscription.subscribe({
  next: ({ data }) => {
    state.conversations = [...data.user_by_pk.user_conversations, ...data.user_by_pk.user_conversations_2]
    console.log(state.conversations)
  },
  error: (error) => {
    console.error(error);
  },
});
</script>

<template>
  <div class="h-full w-full">
    <TabGroup vertical :defaultIndex="1">
      <div class="flex h-full">
        <TabList
          class="w-[350px] h-full border-r-[1px] dark:border-zinc-800 border-gray flex flex-col"
        >
          <div
            class="w-[350px] border-r-[1px] dark:border-zinc-800 border-gray px-4"
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
                class="flex gap-2 items-center justify-center border-[1px] border-gray dark:border-zinc-700 rounded-full min-h-[40px]"
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
          <Tab v-for="conversation in state.conversations" class="w-full outline-none text-left" v-slot="{ selected }">
            <SingleMessage
              :selected="selected"
              :accountPictureAuthor="conversation.conversation_user.id == authStore.user.id ? conversation.conversation_user2.profile_picture_url : conversation.conversation_user.profile_picture_url"
              :accountAuthor="conversation.conversation_user.id == authStore.user.id ? conversation.conversation_user2.username : conversation.conversation_user.username"
              :accountUserAuthor="conversation.conversation_user.id == authStore.user.id ? conversation.conversation_user2.name : conversation.conversation_user.name"
              :lastSend="conversation.conversation_messages[0] ? timeSince(conversation.conversation_messages[0].created_at) : ''"
              :lastMessage="conversation.conversation_messages[0] ? conversation.conversation_messages[0].content : ''"
            />
          </Tab>
        </TabList>
        <TabPanels
          class="flex-1 flex flex-col border-r-[1px] border-gray dark:border-zinc-800 max-h-screen"
        >
          <TabPanel class="flex-1 flex items-center justify-center">
            <div class="flex flex-col px-8 my-8 mx-auto max-w-[400px]">
              <span class="text-3xl font-extrabold">Select a message</span>
              <span class="text-[rgb(113, 118, 123)] text-sm font-normal"
                >Choose from your existing conversations, start a new one, or
                just keep swimming.</span
              >
              <Button class="mt-8" text="New Message" />
            </div>
          </TabPanel>
          <TabPanel class="flex-1 flex max-h-screen" v-for="conversation in state.conversations">
            <ChatFeed :conversation-id="conversation.id" :user-id="authStore.user.id" />
          </TabPanel>
        </TabPanels>
      </div>
    </TabGroup>
  </div>
</template>
