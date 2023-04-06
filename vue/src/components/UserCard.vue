<template>
  <div>
    <transition
      enter-active-class="transition duration-200 ease-out"
      enter-from-class="translate-y-1 opacity-0"
      enter-to-class="translate-y-0 opacity-100"
      leave-active-class="transition duration-150 ease-in"
      leave-from-class="translate-y-0 opacity-100"
      leave-to-class="translate-y-1 opacity-0"
    >
      <div v-if="showPopover" class="absolute z-50 py-3 rounded-lg shadow-md mb-4 shadow-white">
        <div class="py-3 px-4 font-bold hover:bg-zinc-800 dark:hover:bg-[#e7e9ea1a] cursor-pointer" @click="authStore.logout">
            Logout from @{{ pseudo }}
        </div>
      </div>
    </transition>
    <div v-if="showPopover" class="w-screen h-screen z-40 fixed top-0 left-0" @click="showPopover = !showPopover"></div>
    <div
      @click="showPopover = !showPopover"
      class="rounded-full hover:bg-gray dark:hover:bg-gray-hover flex w-full items-center justify-between p-3 cursor-pointer"
    >
      <div class="flex items-center gap-3">
        <img
          class="rounded-full w-10 h-10"
          :src="avatar ? avatar : '/src/assets/img/default-avatar.webp'"
          :alt="name"
        />
        <div class="flex flex-col items-start">
          <p class="flex items-center gap-2">
            {{ name }}
            <IconVerified v-if="verified" />
          </p>
          <p class="text-slate-700 dark:text-zinc-500">@{{ pseudo }}</p>
        </div>
      </div>
      <IconThreeDots />
    </div>
  </div>
</template>

<script setup>
import IconThreeDots from "./icons/IconThreeDots.vue";
import IconVerified from "./icons/IconVerified.vue";
import { Popover, PopoverButton, PopoverPanel } from "@headlessui/vue";
import { ref, onMounted, watch } from "vue";
import { useAuthStore } from "../stores/authStore";

const authStore = useAuthStore();

const toAddHeight = ref(0);
const showPopover = ref(false);

function consoleLogel(el) {
  console.log(Object.keys(el));
}

defineProps({
  name: {
    type: String,
    required: true,
  },
  pseudo: {
    type: String,
    required: true,
  },
  avatar: {
    type: String,
    required: false,
  },
  verified: {
    type: Boolean,
    required: false,
  },
});
</script>
