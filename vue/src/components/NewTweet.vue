<template>
  <div
    class="flex pt-3 px-4 border-y-[1px] dark:border-zinc-800 border-zinc-200"
  >
    <div class="mr-3 p-2">
      <img
        class="w-12 h-12 rounded-full"
        :src="avatar ? avatar : '/src/assets/img/default-avatar.webp'"
        :alt="author_id"
      />
    </div>
    <div class="flex-1 pb-3 flex flex-col">
      <Menu as="div" class="relative inline-block text-left">
        <div>
          <MenuButton
            class="px-3 text-blue flex gap-1 items-center text-base font-bold border-[1px] border-zinc-800 rounded-full"
          >
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
            class="absolute right-0 dark:shadow-white shadow-black bg-white text-black dark:text-white mt-2 w-56 origin-top-right divide-y divide-gray-100 rounded-lg dark:bg-black shadow-md ring-1 ring-black ring-opacity-5 focus:outline-none"
          >
            <div class="py-3">
              <div class="flex flex-col">
                <span class="px-3 py-1 text-xl font-bold">Choose Audience</span>
                <div class="w-full py-3 px-4 hover:bg-gray-hover">
                  <MenuItem v-slot="{ active }">
                    <button class="flex text-base font-bold items-center">
                      <div
                        class="mr-3 w-10 h-10 rounded-full bg-blue flex items-center justify-center"
                      >
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
      <div class="max-h-[240px] overflow-auto w-full min-h-[24px] flex my-5">
        <span
          autocomplete="off"
          autocorrect="off"
          autocapitalize="off"
          spellcheck="false"
          @focusin="hideDisplayPlaceHolder(true)"
          @focusout="hideDisplayPlaceHolder(false)"
          @input="onInput"
          contenteditable
          ref="tweet"
          :class="
            tweetText.length > 0
              ? 'text-black dark:text-white'
              : 'text-[#71767B]'
          "
          class="bg-transparent flex-1 min-h-[24px] w-full break-all border-0 outline-none text-xl"
        >
        </span>
      </div>
      <div class="w-full flex justify-between items-center">
        <div>
          <label for="dropzone-file">
            <div
              class="w-9 h-9 flex items-center justify-center cursor-pointer hover:bg-blue/10 rounded-full"
            >
              <IconImage class="" />
            </div>
            <input
              id="dropzone-file"
              @input="onFilesSelected"
              hidden
              accept="image/jpeg,image/png,image/webp,image/gif,video/mp4,video/quicktime"
              multiple=""
              tabindex="-1"
              type="file"
              class="r-8akbif r-orgf3d r-1udh08x r-u8s1d r-xjis5s r-1wyyakw"
            />
          </label>
        </div>
        <Button
          @click="postNewTweet()"
          text="Tweet"
          :disabled="tweetText.length === 0 || !author_id"
          class="h-[36px]"
        />
      </div>
    </div>
  </div>
</template>

<script setup>
import IconChevron from "./icons/IconChevron.vue";
import IconEarth from "./icons/IconEarth.vue";
import IconImage from "./icons/IconImage.vue";
import { Menu, MenuButton, MenuItems, MenuItem } from "@headlessui/vue";
import { ref, watch, onMounted } from "vue";
import Button from "./Button.vue";
import { CREATE_NEW_TWEET } from "../api";

const props = defineProps({
  avatar: {
    type: String,
    required: false,
  },
  author_id: {
    type: String,
    required: true,
  },
});

const tweet = ref("");
const tweetText = ref("");

const selectedFiles = ref([]);

onMounted(() => {
  tweet.value.innerText = "What’s happening?";
  hideDisplayPlaceHolder;
});

const hideDisplayPlaceHolder = (focus = false) => {
  if (
    tweetText.value.length == 0 &&
    tweet.value.innerText != "What’s happening?"
  ) {
    tweet.value.innerText = "What’s happening?";
  } else if (tweet.value.innerText == "What’s happening?" && focus) {
    tweet.value.innerText = "";
  }
};

watch(tweetText, (val) => {
  hideDisplayPlaceHolder;
});

function onInput() {
  tweet.value.style.height = "auto";
  tweet.value.style.height = `${tweet.value.scrollHeight}px`;
  tweetText.value = tweet.value.innerText;
}

const sanitizedString = (str) => {
  return str.replace(/[&<>"'`=\/]/g, function (s) {
    return {
      "&": "&amp;",
      "<": "&lt;",
      ">": "&gt;",
      '"': "&quot;",
      "'": "&#39;",
      "/": "&#x2F;",
      "`": "&#x60;",
      "=": "&#x3D;",
    }[s];
  });
};

const postNewTweet = async () => {
  if (tweetText.value.length === 0) return;
  if (tweetText.value.length > 280) return;
  await CREATE_NEW_TWEET(
    sanitizedString(tweetText.value),
    props.author_id,
    null
  )
    .then(async () => {
      tweetText.value = "What’s happening?";
      tweet.value.innerText = "What’s happening?";
      tweet.value.style.height = "auto";
    })
    .catch((err) => {
      console.log(err);
    });
  tweetText.value = "";
};

const onFilesSelected = (event) => {
  selectedFiles.value = event.target.files;
};
</script>
