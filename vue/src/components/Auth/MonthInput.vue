<template>
  <Combobox v-model="selectedMonth" class="w-3/5 ">
    <div class="relative mt-1">
      <div
        class="relative w-full cursor-default overflow-hidden border-[1px] border-[#515151] py-2 rounded-[4px] dark:text-white text-left shadow-md  sm:text-sm"
      >
        <ComboboxInput
          class="w-full outline-none border-none py-2 pl-3 bg-transparent text-sm leading-5 text-gray-900 focus:ring-0"
          :displayValue="(month) => month"
          @change="queryMonth = $event.target.value"
        />
      </div>
      <TransitionRoot
        leave="transition ease-in duration-100"
        leaveFrom="opacity-100"
        leaveTo="opacity-0"
        @after-leave="queryMonth = ''"
      >
        <ComboboxOptions
          class="absolute z-50 mt-1 max-h-60 w-full overflow-auto rounded-md bg-white py-1 text-base shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none sm:text-sm"
        >
          <div
            v-if="fileteredMonth.length === 0 && queryMonth !== ''"
            class="relative cursor-default select-none py-2 px-4 text-gray-700"
          >
            Nothing found.
          </div>

          <ComboboxOption
            v-for="month in fileteredMonth"
            as="template"
            :key="month"
            :value="month"
            v-slot="{ selected, active }"
          >
            <li
              class="cursor-default select-none py-2 px-1 w-full flex justify-between"
              :class="{
                'bg-blue text-white': active,
                'text-gray-900': !active,
              }"
            >
              <span
                class="block truncate"
                :class="{ 'font-medium': selected, 'font-normal': !selected }"
              >
                {{ month }}
              </span>
              <span
                v-if="selected"
                class="inset-y-0 left-0 flex items-center"
                :class="{ 'text-white': active, 'text-blue': !active }"
              >
                <IconVerified class="h-5 w-5" aria-hidden="true" />
              </span>
            </li>
          </ComboboxOption>
        </ComboboxOptions>
      </TransitionRoot>
    </div>
  </Combobox>
</template>

<script setup>
import { ref, computed, watch } from "vue";
import {
  Combobox,
  ComboboxInput,
  ComboboxButton,
  ComboboxOptions,
  ComboboxOption,
  TransitionRoot,
} from "@headlessui/vue";
import IconVerified from "../icons/IconVerified.vue";

const monthEmit = defineEmits(["month"]);

const months = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December",
];

const selectedMonth = ref(months[0]);
monthEmit("month", selectedMonth.value)

watch(selectedMonth, (value) => {
    console.log(value)
    monthEmit("month", value);
});

// day
const queryMonth = ref("");

const fileteredMonth = computed(() =>
  queryMonth.value === ""
    ? months
    : months.filter((month) => {
        return month.toString().toLowerCase().includes(queryMonth.value.toLowerCase());
      })
);
</script>
