<template>
  <Combobox v-model="selectedDay" class="w-1/5">
    <div class="relative mt-1">
      <div
        class="relative w-full cursor-default overflow-hidden border-[1px] border-[#515151] py-2 rounded-[4px] dark:text-white text-left shadow-md focus:outline-none sm:text-sm"
      >
        <ComboboxInput
          class="w-full outline-none border-none py-2 pl-3 bg-transparent text-sm leading-5 text-gray-900 focus:ring-0"
          :displayValue="(day) => day"
          @change="queryDay = $event.target.value"
        />
      </div>
      <TransitionRoot
        leave="transition ease-in duration-100"
        leaveFrom="opacity-100"
        leaveTo="opacity-0"
        @after-leave="queryDay = ''"
      >
        <ComboboxOptions
          class="absolute z-50 mt-1 min-w-[60px] max-h-60 w-full overflow-auto rounded-[4px] bg-white py-1 text-base shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none sm:text-sm"
        >
          <div
            v-if="filteredDays.length === 0 && queryDay !== ''"
            class="relative cursor-default select-none py-2 px-4 text-gray-700"
          >
            Nothing found.
          </div>

          <ComboboxOption
            v-for="day in filteredDays"
            as="template"
            :key="day"
            :value="day"
            v-slot="{ selected, active }"
            class="min-w-[50px]"
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
                {{ day }}
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

import { ref, computed, watch } from 'vue'
import {
  Combobox,
  ComboboxInput,
  ComboboxButton,
  ComboboxOptions,
  ComboboxOption,
  TransitionRoot,
} from '@headlessui/vue';
import IconVerified from '../icons/IconVerified.vue';

const dayEmit = defineEmits(['day']);

const days = Array.from({ length: 31 }, (_, i) => i + 1);

const selectedDay = ref(days[0]);
dayEmit('day', selectedDay.value)

watch(selectedDay, (day) => {
  dayEmit('day', day);
});

// day
const queryDay = ref("");

const filteredDays = computed(() =>
  queryDay.value === ""
    ? days
    : days.filter((day) => {
        return day.toString().toLowerCase().includes(queryDay.value.toLowerCase());
      })
);

</script>