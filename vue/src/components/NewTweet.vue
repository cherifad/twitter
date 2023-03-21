<template>
  <div class="flex px-4 py-1 border-y-2 border-zinc-800">
    <div class="mr-3 pt-1">
      <img v-if="avatar" :src="avatar" alt="" />
      <IconTwitter v-else />
    </div>
    <div class="w-full pb-3">
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
            class="absolute right-0 shadow-white mt-2 w-56 origin-top-right divide-y divide-gray-100 rounded-lg bg-black shadow-md ring-1 ring-black ring-opacity-5 focus:outline-none"
          >
            <div class="py-3">
              <div class="flex flex-col">
                <span class="px-3 py-1 text-xl font-bold">Choose Audience</span>
                <div class="w-full py-3 px-4 hover:bg-gray-hover">
                  <MenuItem v-slot="{ active }">
                    <button>Edit</button>
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
    </div>
  </div>
</template>

<script setup>
import IconTwitter from "./icons/IconTwitter.vue";
import IconChevron from "./icons/IconChevron.vue";
import { Menu, MenuButton, MenuItems, MenuItem } from "@headlessui/vue";
defineProps({
  avatar: {
    type: String,
    required: false,
  },
});
</script>
