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
          @click="register = false, showPopup = true"
          class="outline-none font-bold text-sm px-4 rounded-full border-[1px] border-slate-100 min-h-[36px] text-white"
        >
          Log in
        </button>
        <button
          @click="register = true, showPopup = true"
          class="outline-non bg-white font-bold text-sm px-4 rounded-full border-[1px] border-white min-h-[36px]"
        >
          Sign up
        </button>
      </div>
    </div>
    <AuthPopup @close="showPopup = false" :toShow="showPopup" :register="register" />
  </div>
</template>

<script setup>
import { ref } from "vue";
import AuthPopup from "./AuthPopup.vue";

const isOpen = ref(true);
const register = ref(false);

const showPopup = ref(true);

function setIsOpen(value) {
  isOpen.value = value;
}
</script>
