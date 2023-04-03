<template>
  <div v-if="Object.keys(state.current_user).length != 0" class="flex relative flex-col flex-1 h-screen">
    <div class="flex justify-between px-4 flex-col flex-1 max-h-full">
      <RouterLink :to="`/${state.current_user.username}`"
        class="mb-4 border-b-[1px] cursor-pointer dark:hover:bg-zinc-800 border-gray dark:border-zinc-800 py-5 px-4 flex flex-col items-center">
        <img class="w-16 h-16 rounded-full" :src="
          state.current_user.profile_picture_url
            ? state.current_user.profile_picture_url
            : '/src/assets/img/default-avatar.webp'
        " :alt="state.current_user.username" />
        <div class="text-center flex flex-col items-center">
          <RouterLink :to="`/${state.current_user.username}`" class="flex items-center w-fit font-bold hover:underline">{{
            state.current_user.name }}
            <IconVerified class="ml-2" v-if="state.current_user.premium" />
          </RouterLink>
          <span class="text-slate-700 dark:text-zinc-500">@{{ state.current_user.username }}</span>
        </div>
        <div class="flex">
          <span class="text-slate-700 dark:text-zinc-500 gap-2 flex items-center">
            <IconCalendar class="w-[19px] h-[19px]" /> Joined
            {{ monthNames[new Date(state.current_user.created_at).getMonth()] }}
            {{ new Date(state.current_user.created_at).getFullYear() }}
            ·
            {{ state.current_user.followers_aggregate.aggregate.count }}
            Followers
          </span>
        </div>
      </RouterLink>
      <div class="pb-7 flex flex-col justify-end flex-1 overflow-y-scroll">
        <div v-if="state.messages.length == 0">
          <div class="flex-1">
            <div class="flex flex-col items-center">
              <div class="text-4xl font-bold">No messages yet</div>
              <div class="text-xl text-gray-500">
                Send messages to your friends and family
              </div>
            </div>
          </div>
        </div>
        <SingleChat v-else v-for="message in state.messages.conversation_messages" :content="message.content"
          :createdAt="message.created_at" :fromUser="message.sender_id == userId" />
      </div>
    </div>
    <div class="border-t-[1px] absolute bottom-0 w-full cursor-pointer border-gray dark:border-zinc-800">
      <form @submit="sendMessage"
        class="flex gap-2 mx-4 my-1 dark:bg-[rgb(32,35,39)] bg-[rgb(239,243,244)] p-1 rounded-2xl">
        <div class="flex items-center">
          <label for="dropzone-file">
            <div class="w-9 h-9 flex items-center justify-center cursor-pointer hover:bg-blue/10 rounded-full">
              <IconImage class="" />
            </div>
            <input id="dropzone-file" @input="onFilesSelected" hidden
              accept="image/jpeg,image/png,image/webp,image/gif,video/mp4,video/quicktime" multiple="" tabindex="-1"
              type="file" class="r-8akbif r-orgf3d r-1udh08x r-u8s1d r-xjis5s r-1wyyakw" />
          </label>
        </div>
        <input type="text" v-model="messageContent" class="flex-1 bg-transparent outline-none dark:text-white"
          placeholder="Type a message" />
        <button type="submit"
          class="w-9 h-9 flex items-center justify-center cursor-pointer hover:bg-blue/10 rounded-full">
          <IconSend />
        </button>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from "vue";
import { RouterLink } from "vue-router";
import SingleChat from "./SingleChat.vue";
import { GET_MESSAGES_OF_CONVERSATION, POST_NEW_MESSAGE } from "../../api";
import IconImage from "../icons/IconImage.vue";
import IconSend from "../icons/IconSend.vue";
import IconVerified from "../icons/IconVerified.vue";
import IconCalendar from "../icons/IconCalendar.vue";

const props = defineProps({
  conversationId: {
    type: String,
    required: true,
  },
  userId: {
    type: String,
    required: true,
  },
});

const messageContent = ref("");

const monthNames = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December",
];

const state = reactive({
  messages: [],
  conversation_users: [],
  current_user: {},
});

const subscription = GET_MESSAGES_OF_CONVERSATION(props.conversationId);

console.log(subscription);

subscription.subscribe({
  next: ({ data }) => {
    state.messages = data.conversation_by_pk;
    state.conversation_users = [
      data.conversation_by_pk.conversation_user,
      data.conversation_by_pk.conversation_user2,
    ];
    state.current_user = state.conversation_users.find(
      (user) => user.id != props.userId
    );
  },
  error: (error) => {
    console.error(error);
  },
});

const sendMessage = (e) => {
  e.preventDefault();
  if (messageContent.value == "") return;
  POST_NEW_MESSAGE(
    messageContent.value,
    props.userId,
    state.current_user.id,
    props.conversationId
  );
  messageContent.value = "";
};
</script>
