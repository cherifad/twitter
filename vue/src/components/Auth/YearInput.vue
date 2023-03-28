<template>
  <Combobox v-model="selectedYear" class="w-2/5">
    <div class="relative mt-1">
      <div
        class="relative w-full cursor-default overflow-hidden rounded-lg border-[1px] border-[#515151] py-2 dark:text-white text-left shadow-md focus:outline-none sm:text-sm"
      >
        <ComboboxInput
            class="w-full outline-none border-none py-2 pl-3 bg-transparent text-sm leading-5 text-gray-900 focus:ring-0"
          :displayValue="(year) => year"
          @change="queryYear = $event.target.value"
        />
      </div>
      <TransitionRoot
        leave="transition ease-in duration-100"
        leaveFrom="opacity-100"
        leaveTo="opacity-0"
        @after-leave="queryYear = ''"
      >
        <ComboboxOptions
          class="absolute z-50 mt-1 max-h-60 w-full overflow-auto rounded-md bg-white py-1 text-base shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none sm:text-sm"
        >
          <div
            v-if="filteredYears.length === 0 && queryYear !== ''"
            class="relative cursor-default select-none py-2 px-4 text-gray-700"
          >
            Nothing found.
          </div>

          <ComboboxOption
            v-for="year in filteredYears"
            as="template"
            :key="year"
            :value="year"
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
                {{ year }}
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

const yearEmit = defineEmits(["year"]);

// create an array of years, starting from 1900 to 18 years ago
var years = [];
var startYear = 1900;
for (var i = startYear; i <= (new Date().getFullYear() - 18); i++) {
    years.push(startYear);
    startYear++;
}

const selectedYear = ref(years[0]);
yearEmit("year", selectedYear.value);

watch(selectedYear, (year) => {
    yearEmit("year", year);
});

// year
const queryYear = ref("");

const filteredYears = computed(() =>
  queryYear.value === ""
    ? years
    : years.filter((year) => {
        return year.toString().toLowerCase().includes(queryYear.value.toLowerCase());
      })
);
</script>
