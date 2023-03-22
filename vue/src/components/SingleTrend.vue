<template>
  <div class="px-4 py-3 dark:hovergraydark hoverdark flex justify-between cursor-pointer">
    <div>
      <div class="text-gray-light text-sm">
        <span>{{ ranking }} · {{ theme }} · Trending</span>
      </div>
      <div class="text-base font-bold dark:text-white">
        {{ title }}
      </div>
      <div>
        <span class="text-gray-light text-sm"
          >{{ formatCount(numberOfTweets) }} Tweets</span
        >
      </div>
    </div>
    <div id="report" class="h-9 w-9 flex items-center justify-center rounded-full cursor-pointer">
      <svg
        class="w-4 h-4 text-gray-light"
        viewBox="0 0 24 24"
        fill="currentColor"
        stroke="currentColor"
        stroke-width="2"
        stroke-linecap="round"
        stroke-linejoin="round"
      >
        <circle cx="12" cy="12" r="1"></circle>
        <circle cx="19" cy="12" r="1"></circle>
        <circle cx="5" cy="12" r="1"></circle>
      </svg>
    </div>
  </div>
</template>

<script setup>
import { formatCount } from "../utils/helpers";
defineProps({
  ranking: {
    type: Number,
    required: true,
  },
  theme: {
    type: String,
    required: true,
  },
  title: {
    type: String,
    required: true,
  },
  numberOfTweets: {
    type: Number,
    required: true,
  },
});
</script>

<style scoped>
.hoverdark:hover {
  background-color: rgba(0, 0, 0, 0, 0.03);
}

.hovergraydark {
  background-color: rgba(0, 0, 0, 0.05);
}

#report:hover {
  background-color: rgba(29, 155, 240, 0.1);
}

#report:hover > svg {
    color: #1d9bf0;
}
</style>
