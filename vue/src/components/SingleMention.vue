<script setup>
import IconLike from "./icons/IconLike.vue";
import IconRetweet from "./icons/IconRetweet.vue";
import IconReply from "./icons/IconReply.vue";
import IconVerified from "./icons/IconVerified.vue";
import IconViewsCount from "./icons/IconViewsCount.vue";
import { formatCount, timeSince } from "../utils/helpers.js";

    defineProps({
        contentNotif: {
            type: String,
            default: "",
            required: true,
        },
        account: {
            type: String,
            default: "",
            required: true,
        },
        accountPictureUser: {
            type: String,
            default: "",
            required: true,
        },
        accountNameUser: {
            type: String,
            default: "",
            required: true,
        },
        accountName: {
            type: String,
            default: "",
            required: true,
        },
        tweetAuthor: {
        type: String,
        default: "",
        required: true,
        },
        tweetAuthorId: {
            type: String,
            default: "",
        },
        tweetAuthorAvatar: {
            type: String,
            default: "",
        },
        tweetAuthorUsername: {
            type: String,
            default: "",
        },
        tweetAuthorVerified: {
            type: Boolean,
            default: false,
        },
        tweetContent: {
            type: String,
            default: "",
        },
        tweetDate: {
            type: String,
            default: "",
        },
        tweetLikes: {
            type: Number,
            default: 0,
        },
        tweetRetweets: {
            type: Number,
            default: 0,
        },
        tweetReplies: {
            type: Number,
            default: 0,
        },
        tweetBookmarked: {
            type: Boolean,
            default: false,
        },
        tweetLiked: {
            type: Boolean,
            default: false,
        },
        tweetRetweeted: {
            type: Boolean,
            default: false,
        },
        tweetReplied: {
            type: Boolean,
            default: false,
        },
        tweetMedia: {
            type: Array,
            default: [],
        },
        tweetMediaCount: {
            type: Number,
            default: 0,
        },
        tweetViews: {
            type: Number,
            default: 0,
        },
        tweetId: {
            type: String,
            default: "",
        },
        tweetThread: {
            type: Boolean,
            default: false,
        },
        tweetChild: {
            type: Object,

        }
    });
</script>


<template>
    <div class=" border-b-[1px] border-current border-zinc-800 p-2 text-sm">
        <div class=" flex w-5/6 items-center">
            <img :src=accountPictureUser class="w-12 h-12 rounded-full">
            <div class=" ml-3">
                <h1 class=" text-zinc-800"><span class="text-white">{{ accountName }}</span>  {{ accountNameUser }}</h1>
                <h1 class=" text-sky-700 font-thin">Replying to @{{ account }}</h1>
                <h1 class="text-white font-medium">{{ contentNotif }}</h1>
            </div>
        </div>
        <div class="flex mt-3 text-sm font-normal w-10/12 justify-between">
        <div
          id="reply"
          class="text-gray-light flex items-center gap-2 hover:text-blue cursor-pointer"
        >
          <div
            class="rounded-full w-9 h-9 flex items-center justify-center hover:bg-[rgba(29, 155, 240, 0.1)]"
          >
            <IconReply />
          </div>
          {{ formatCount(tweetReplies) }}
        </div>
        <div
          id="retweet"
          class="text-gray-light flex items-center gap-2 hover:text-[#00BA7C] cursor-pointer"
        >
          <div
            class="rounded-full w-9 h-9 flex items-center justify-center"
          >
            <IconRetweet />
          </div>
          {{ formatCount(tweetRetweets) }}
        </div>
        <div
          id="like"
          class="text-gray-light flex items-center gap-2 hover:text-[#F91880] cursor-pointer"
        >
          <div
            class="rounded-full w-9 h-9 flex items-center justify-center hover:bg-[rgba(224, 36, 94, 0.1)]"
          >
            <IconLike />
          </div>
          {{ formatCount(tweetLikes) }}
        </div>
        <div
          id="views"
          class="text-gray-light flex items-center gap-2 hover:text-blue cursor-pointer"
        >
          <div
            class="rounded-full w-9 h-9 flex items-center justify-center hover:bg-[rgba(255, 209, 102, 0.1)]"
          >
            <IconViewsCount />
          </div>
          0
        </div>
      </div>
    </div>
</template>