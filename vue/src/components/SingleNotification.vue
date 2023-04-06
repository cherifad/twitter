<script setup>
import IconNotificationUser from "./icons/IconNotificationUser.vue";
import { GET_USER } from "../api";
import { onMounted, ref, reactive } from "vue";

const props = defineProps({
  contentNotif: {
    type: String,
    default: "",
    required: true,
  },
  from: {
    type: String,
    default: "",
    required: true,
  },
});

const state = reactive({
  user: {},
});

const loading = ref(true);

onMounted(async () => {
    state.user.value = await GET_USER(props.from);
    loading.value = false;
});
</script>

<template>
  <div
    class="flex border-b-[1px] border-current dark:border-zinc-800 border-zinc-200 p-2 text-sm"
  >
    <div class="relative justify-center flex w-2/12 items-center">
      <IconNotificationUser />
    </div>
    <div class="w-5/6 items-center" v-if="!loading">
        <div class="flex items-center gap-2">
            <img :src="state.user.value[0].profile_picture_url ? state.user.value[0].profile_picture_url : '/src/assets/img/default-avatar.webp'" class="w-12 h-12 rounded-full" />
            <div>
              <h1 class="dark:text-white">{{ state.user.value[0].name }}</h1>
              <span class="dark:text-white">@{{ state.user.value[0].username }}</span>
            </div>
        </div>
      <div class="ml-2">
        <h1 class="mt-5 text-zinc-700 dark:text-white font-bold text-lg">{{ contentNotif }}</h1>
      </div>
    </div>
  </div>
</template>
