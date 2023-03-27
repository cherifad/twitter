<template>
  <div class="w-screen flex justify-center fixed bottom-0 right-0 py-3 bg-blue">
    <div class="w-[275px]"></div>
    <div class="w-[990px] flex justify-between items-center">
      <div class="flex flex-col">
        <span class="text-2xl font-bold text-white"
          >Don’t miss what’s happening</span
        >
        <span class="text-sm text-white"
          >People on Twitter are the first to know.</span
        >
      </div>
      <div class="flex gap-3">
        <button
          @click="showPopup = true"
          class="outline-none font-bold text-sm px-4 rounded-full border-[1px] border-slate-100 min-h-[36px] text-white"
        >
          Log in
        </button>
        <button
          class="outline-non bg-white font-bold text-sm px-4 rounded-full border-[1px] border-white min-h-[36px]"
        >
          Sign up
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
// import AuthPopup from "./AuthPopup.vue";
import { ref } from "vue";

const isOpen = ref(true);

const showPopup = ref(true);

function setIsOpen(value) {
  isOpen.value = value;
}
</script>
