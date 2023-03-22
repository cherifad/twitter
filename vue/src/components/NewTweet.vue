<template>
  <div class="flex px-4 py-1 border-y-[1px] dark:border-zinc-800 border-zinc-200">
    <div class="mr-3 pt-1">
      <img v-if="avatar" :src="avatar" alt="" />
      <IconTwitter v-else />
    </div>
    <div class="w-full pb-3 flex flex-col">
      <Menu as="div" class="relative inline-block text-left">
        <div>
          <MenuButton
            class="px-3 text-blue flex gap-1 items-center text-base font-bold border-[1px] border-zinc-800 rounded-full">
            Everyone
            <IconChevron class="w-5 h-5" />
          </MenuButton>
        </div>

        <transition
          enter-active-class="transition duration-100 ease-out"
          enter-from-class="transform scale-95 opacity-0"
          enter-to-class="transform scale-100 opacity-100"
          leave-active-class="transition duration-75 ease-in"
          leave-from-class="transform scale-100 opacity-100"
          leave-to-class="transform scale-95 opacity-0"
        >
          <MenuItems
            class="absolute right-0 dark:shadow-white shadow-black bg-white text-black dark:text-white mt-2 w-56 origin-top-right divide-y divide-gray-100 rounded-lg dark:bg-black  shadow-md ring-1 ring-black ring-opacity-5 focus:outline-none"
          >
            <div class="py-3">
              <div class="flex flex-col">
                <span class="px-3 py-1 text-xl font-bold">Choose Audience</span>
                <div class="w-full py-3 px-4 hover:bg-gray-hover">
                  <MenuItem v-slot="{ active }">
                    <button class="flex text-base font-bold items-center">
                      <div class="mr-3 w-10 h-10 rounded-full bg-blue flex items-center justify-center">
                        <IconEarth />
                      </div>
                      Everyone
                    </button>
                  </MenuItem>
                </div>
                <div class="w-full py-3 px-4 hover:bg-gray-hover">
                  <MenuItem v-slot="{ active }">
                    <button>Duplicate</button>
                  </MenuItem>
                </div>
              </div>
            </div>
          </MenuItems>
        </transition>
      </Menu>
      <input type="text" v-model="tweet" :class="tweet.length > 0 ? 'text-black dark:text-white' : 'text-[#71767B]'" class="bg-transparent border-0 my-5 outline-none text-xl" placeholder="What’s happening?">
    </div>

  </div>
</template>

<script setup>
import IconTwitter from "./icons/IconTwitter.vue";
import IconChevron from "./icons/IconChevron.vue";
import IconEarth from "./icons/IconEarth.vue";
import { Menu, MenuButton, MenuItems, MenuItem } from "@headlessui/vue";
import { ref } from "vue";

defineProps({
  avatar: {
    type: String,
    required: false,
  },
});

const tweet = ref("");

</script>
