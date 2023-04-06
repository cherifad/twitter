<template>
  <div>
    <TransitionRoot appear :show="isOpen">
      <Dialog as="div" @close="closeModal" class="relative z-10">
        <TransitionChild
          as="template"
          enter="duration-300 ease-out"
          enter-from="opacity-0"
          enter-to="opacity-100"
          leave="duration-200 ease-in"
          leave-from="opacity-100"
          leave-to="opacity-0"
        >
          <div class="fixed inset-0 bg-slate-300 bg-opacity-40" />
        </TransitionChild>

        <div class="fixed inset-0 overflow-y-auto">
          <div class="flex min-h-full justify-center p-4 text-center">
            <TransitionChild
              as="template"
              enter="duration-300 ease-out"
              enter-from="opacity-0 scale-95"
              enter-to="opacity-100 scale-100"
              leave="duration-200 ease-in"
              leave-from="opacity-100 scale-100"
              leave-to="opacity-0 scale-95"
            >
              <DialogPanel
                class="transform relative overflow-hidden rounded-2xl dark:bg-black bg-white p-6 text-left align-middle shadow-xl transition-all min-h-fit max-h-[40vh] max-w-[80vw] w-[600px]"
              >
                <DialogTitle as="h3" class="dark:text-white text-gray-900">
                  <div
                    id="close"
                    class="absolute dark:hover:bg-[rgb(239,244,243)]/10 hover:bg-[rgb(15,20,25)]/10 rounded-full p-2 top-2 left-2 cursor-pointer"
                    @click="closeModal"
                  >
                    <IconClose class="" />
                  </div>
                </DialogTitle>
                <div class="flex mt-5">
                  <div class="p-2 flex flex-col items-center gap-2">
                    <img
                      class="w-12 h-12 rounded-full"
                      :src="
                        originalTweetAuthorPicture
                          ? originalTweetAuthorPicture
                          : '/src/assets/img/default-avatar.webp'
                      "
                      :alt="tweetAuthor"
                    />
                    <div
                      class="w-[2px] flex-1 bg-gray-light/50 rounded-full"
                    ></div>
                  </div>
                  <div class="pt-2 mb-3 flex-1">
                    <div class="flex items-center justify-between w-full">
                      <div class="flex items-center text-base">
                        <RouterLink
                          :to="'/' + originalTweetAuthorUsername"
                          class="font-bold dark:text-white flex items-center underline-offset-2 hover:underline"
                          >{{ originalTweetAuthor }}
                          <IconVerified class="ml-1 w-4 h-4" v-if="false"
                        /></RouterLink>
                        <span class="ml-1 text-gray-light font-normal"
                          >@{{ originalTweetAuthorUsername }}</span
                        >
                        <span class="px-1 text-gray-light font-normal">·</span>
                        <span class="ml-1 text-gray-light">{{
                          timeSince(originalTweetDate)
                        }}</span>
                      </div>
                      <div class="ml-2">
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
                    <div class="text-base dark:text-slate-200 text-black">
                      <p
                        class="break-all"
                        v-html="formatTweetContent(originalTweetContent)"
                      ></p>
                    </div>
                    <div
                      class="dark:text-[rgb(113,118,123)] pb-4 pt-1 font-normal"
                    >
                      Replying to
                      <RouterLink
                        :to="`/${originalTweetAuthorUsername}`"
                        class="text-blue"
                        >@{{ originalTweetAuthorUsername }}</RouterLink
                      >
                    </div>
                  </div>
                </div>
                <div class="flex" v-if="auths">
                  <div class="p-2 flex flex-col items-center gap-2">
                    <img
                      class="w-12 h-12 rounded-full"
                      :src="
                        auths.user.profile_picture_url
                          ? auths.user.profile_picture_url
                          : '/src/assets/img/default-avatar.webp'
                      "
                      :alt="auths.user.id"
                    />
                  </div>
                  <div class="pt-2 mb-3 flex-1 flex flex-col">
                    <div
                      class="max-h-[240px] overflow-auto w-full min-h-[24px] flex my-5"
                    >
                      <span
                        autocomplete="off"
                        autocorrect="off"
                        autocapitalize="off"
                        spellcheck="false"
                        @focusin="hideDisplayPlaceHolder(true)"
                        @focusout="hideDisplayPlaceHolder(false)"
                        @input="onInput"
                        contenteditable
                        ref="reply"
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
                        :disabled="tweetText.length === 0 || !auths.user"
                        class="h-[36px] absolute bottom-2 right-2"
                      />
                    </div>
                  </div>
                </div>
              </DialogPanel>
            </TransitionChild>
          </div>
        </div>
      </Dialog>
    </TransitionRoot>
  </div>
</template>

<script setup>
import {
  TransitionRoot,
  TransitionChild,
  Dialog,
  DialogPanel,
  DialogTitle,
} from "@headlessui/vue";
import IconTwitter from "./icons/IconTwitter.vue";
import IconClose from "./icons/IconClose.vue";
import NewTweet from "./NewTweet.vue";
import { useAuthStore } from "../stores/authStore";
import { ref, watch, onMounted } from "vue";
import { timeSince } from "../utils/helpers";
import { RouterLink } from "vue-router";
import { POST_NEW_REPLY } from "../api";
import Button from "./Button.vue";

const auths = useAuthStore();
const reply = ref("");
const tweetText = ref("");

const props = defineProps({
  originalTweetContent: {
    type: String,
    default: "",
    required: true,
  },
  originalTweetAuthor: {
    type: String,
    default: "",
    required: true,
  },
  originalTweetAuthorUsername: {
    type: String,
    default: "",
    required: true,
  },
  originalTweetAuthorPicture: {
    type: String,
    default: "",
    required: false,
  },
  originalTweetDate: {
    type: String,
    default: "",
    required: true,
  },
  toShow: {
    type: Boolean,
    default: false,
    required: true,
  },
  originalTweetId: {
    type: String,
    default: "",
    required: true,
  },
});

///////////////////
/// modal part ///
//////////////////

watch(
  () => props.toShow,
  (value) => {
    isOpen.value = value;
  }
);

watch(
  () => auths.isAuthenticated,
  (value) => {
    if (value) {
      closeModal();
    }
  }
);

const close = defineEmits(["close"]);

const isOpen = ref(props.toShow);

function closeModal() {
  isOpen.value = false;
  close("close");
}

function formatTweetContent(tweetContent) {
  // Find all hashtags and wrap them in a span with a CSS class
  tweetContent = tweetContent.replace(
    /#([\p{L}\p{Mn}\p{Pc}]+)/gu,
    '<a href="/search?q=%23$1" class="text-blue cursor-pointer hover:underline">#$1</a>'
  );
  // Find all mentions and wrap them in a span with a CSS class
  tweetContent = tweetContent.replace(
    /@([\p{L}\p{Mn}\p{Pc}-]+)/gu,
    '<a href="/$1" class="text-blue cursor-pointer hover:underline">@$1</a>'
  );
  // Find all URLs and wrap them in a span with a CSS class
  tweetContent = tweetContent.replace(
    /(https?:\/\/[^\s]+)/gu,
    '<a href="$1" class="text-blue cursor-pointer hover:underline">$1</a>'
  );

  return tweetContent;
}

watch(
  () => reply.value,
  (value) => {
    if (value) {
      reply.value.innerHTML = "What’s happening?";
    }
  }
);

onMounted(() => {
  hideDisplayPlaceHolder;
});

const hideDisplayPlaceHolder = (focus = false) => {
  if (
    tweetText.value.length == 0 &&
    reply.value.innerText != "What’s happening?"
  ) {
    reply.value.innerText = "What’s happening?";
  } else if (reply.value.innerText == "What’s happening?" && focus) {
    reply.value.innerText = "";
  }
};

watch(tweetText, (val) => {
  hideDisplayPlaceHolder;
});

function onInput() {
  reply.value.style.height = "auto";
  reply.value.style.height = `${reply.value.scrollHeight}px`;
  tweetText.value = reply.value.innerText;
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
  await POST_NEW_REPLY(sanitizedString(tweetText.value), auths.user.id, props.originalTweetId)
    .then(async () => {
      reply.value.innerText = "What’s happening?";
      reply.value.style.height = "auto";
      closeModal();
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
