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
          <div
            class="flex min-h-full items-center justify-center p-4 text-center"
          >
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
                class="transform relative overflow-hidden rounded-2xl dark:bg-black bg-white p-6 text-left align-middle shadow-xl transition-all min-h-[400px] max-h-[90vh] max-w-[80vw] w-[600px]"
              >
                <div
                  id="close"
                  class="absolute dark:hover:bg-[rgb(239,244,243)]/10 hover:bg-[rgb(15,20,25)]/10 rounded-full p-2 top-2 left-2 cursor-pointer"
                  @click="closeModal"
                >
                  <IconClose class="bg-white text-white" />
                </div>
                <DialogTitle
                  as="h3"
                  class="dark:text-white flex-col text-3xl flex items-center font-bold leading-6 text-gray-900"
                >
                  <IconTwitter />
                  <span class="my-5"
                    >{{ register ? "Sign up" : "Log in" }} to Twitter</span
                  >
                </DialogTitle>
                <form
                  v-if="register"
                  @submit="(e) => registerUser(e)"
                  class="pb-12 flex h-full justify-center items-center flex-col px-8 max-w-[364px] m-auto py-3 rounded-sm overflow-y-auto overflow-scroll overflow-x-hidden"
                >
                  <div
                    class="group rounded-[4px] dark:text-white my-3 w-full"
                    :class="
                      emailFocus
                        ? 'border-blue border-2'
                        : 'border-[1px] border-[#515151]'
                    "
                  >
                    <input
                      @focusin="emailFocus = true"
                      @focusout="emailFocus = false"
                      v-model="registerForm.email"
                      required=""
                      type="email"
                      class="input dark:text-white"
                    />
                    <span class="highlight"></span>
                    <span class="bar"></span>
                    <label :class="emailFocus ? 'text-blue' : 'text-[#999]'"
                      >Email</label
                    >
                  </div>
                  <div
                    v-if="authStore.errors.length > 0"
                    class="w-full flex flex-col"
                  >
                    <span
                      v-for="error in authStore.errors"
                      class="text-red-600"
                      >{{ error }}</span
                    >
                  </div>
                  <div
                    class="group rounded-[4px] dark:text-white my-3 w-full"
                    :class="
                      passwordFocus
                        ? 'border-blue border-2'
                        : 'border-[1px] border-[#515151]'
                    "
                  >
                    <input
                      @focusin="passwordFocus = true"
                      @focusout="passwordFocus = false"
                      v-model="registerForm.password"
                      required=""
                      type="password"
                      class="input dark:text-white"
                    />
                    <span class="highlight"></span>
                    <span class="bar"></span>
                    <label :class="passwordFocus ? 'text-blue' : 'text-[#999]'"
                      >Password</label
                    >
                  </div>
                  <div
                    class="group rounded-[4px] dark:text-white my-3 w-full"
                    :class="
                      registerFocus.password_confirmation
                        ? 'border-blue border-2'
                        : 'border-[1px] border-[#515151]'
                    "
                  >
                    <input
                      @focusin="registerFocus.password_confirmation = true"
                      @focusout="registerFocus.password_confirmation = false"
                      v-model="registerForm.password_confirmation"
                      required=""
                      type="password"
                      class="input dark:text-white"
                    />
                    <span class="highlight"></span>
                    <span class="bar"></span>
                    <label
                      :class="
                        registerFocus.password_confirmation
                          ? 'text-blue'
                          : 'text-[#999]'
                      "
                      >Password confirmation</label
                    >
                  </div>
                  <div class="flex justify-between gap-2">
                    <DayInput @day="(day) => (date.day = day)" />
                    <MonthInput @month="(month) => (date.month = month)" />
                    <YearInput @year="(year) => (date.year = year)" />
                  </div>
                  <div
                    class="group rounded-[4px] dark:text-white my-3 w-full"
                    :class="
                      registerFocus.name
                        ? 'border-blue border-2'
                        : 'border-[1px] border-[#515151]'
                    "
                  >
                    <input
                      @focusin="registerFocus.name = true"
                      @focusout="registerFocus.name = false"
                      v-model="registerForm.name"
                      required=""
                      type="text"
                      class="input dark:text-white"
                    />
                    <span class="highlight"></span>
                    <span class="bar"></span>
                    <label
                      :class="registerFocus.name ? 'text-blue' : 'text-[#999]'"
                      >Full Name</label
                    >
                  </div>
                  <div
                    class="group rounded-[4px] dark:text-white my-3 w-full"
                    :class="
                      registerFocus.username
                        ? 'border-blue border-2'
                        : 'border-[1px] border-[#515151]'
                    "
                  >
                    <input
                      @focusin="registerFocus.username = true"
                      @focusout="registerFocus.username = false"
                      v-model="registerForm.username"
                      required=""
                      type="text"
                      class="input dark:text-white"
                    />
                    <span class="highlight"></span>
                    <span class="bar"></span>
                    <label
                      :class="
                        registerFocus.username ? 'text-blue' : 'text-[#999]'
                      "
                      >Username</label
                    >
                  </div>
                  <input
                    type="submit"
                    value="Sign up"
                    class="w-full rounded-full dark:bg-white bg-black text-white dark:text-black font-bold min-h-[36px] mt-3 hover:bg-slate-900 dark:hover:bg-slate-100 cursor-pointer"
                  />
                  <span class="text-gray-light w-full mt-10"
                    >Already have an account?
                    <a
                      @click="register = false"
                      class="text-blue cursor-pointer"
                      >Sign in</a
                    ></span
                  >
                </form>
                <form
                  v-else
                  @submit="(e) => login(e)"
                  class="pb-12 flex h-full justify-center items-center flex-col px-8 max-w-[364px] m-auto py-3 rounded-sm overflow-auto overflow-x-hidden"
                >
                  <div
                    class="group rounded-[4px] dark:text-white my-3 w-full"
                    :class="
                      emailFocus
                        ? 'border-blue border-2'
                        : 'border-[1px] border-[#515151]'
                    "
                  >
                    <input
                      @focusin="emailFocus = true"
                      @focusout="emailFocus = false"
                      v-model="form.email"
                      required
                      type="text"
                      class="input dark:text-white"
                    />
                    <span class="highlight"></span>
                    <span class="bar"></span>
                    <label :class="emailFocus ? 'text-blue' : 'text-[#999]'"
                      >Phone, Email or username</label
                    >
                  </div>
                  <div
                    v-if="authStore.errors.length > 0"
                    class="w-full flex flex-col"
                  >
                    <span
                      v-for="error in authStore.errors"
                      class="text-red-600"
                      >{{ error }}</span
                    >
                  </div>
                  <div
                    class="group rounded-[4px] dark:text-white my-3 w-full"
                    :class="
                      passwordFocus
                        ? 'border-blue border-2'
                        : 'border-[1px] border-[#515151]'
                    "
                  >
                    <input
                      @focusin="passwordFocus = true"
                      @focusout="passwordFocus = false"
                      v-model="form.password"
                      required
                      type="password"
                      class="input dark:text-white"
                    />
                    <span class="highlight"></span>
                    <span class="bar"></span>
                    <label :class="passwordFocus ? 'text-blue' : 'text-[#999]'"
                      >Password</label
                    >
                  </div>
                  <input
                    type="submit"
                    value="Sign in"
                    class="w-full rounded-full dark:bg-white bg-black text-white dark:text-black font-bold min-h-[36px] mt-3 hover:bg-slate-900 dark:hover:bg-slate-100 cursor-pointer"
                  />
                  <button
                    class="w-full rounded-full dark:border-white border-black dark:text-white border-[1px] font-bold min-h-[36px] mt-7 hover:bg-slate-100"
                  >
                    Forgot password?
                  </button>
                  <span class="text-gray-light w-full mt-10"
                    >Don't have an account?
                    <a @click="register = true" class="text-blue cursor-pointer"
                      >Sign up</a
                    ></span
                  >
                </form>
              </DialogPanel>
            </TransitionChild>
          </div>
        </div>
      </Dialog>
    </TransitionRoot>
  </div>
</template>

<script setup>
import { ref, watch, computed } from "vue";
import {
  TransitionRoot,
  TransitionChild,
  Dialog,
  DialogPanel,
  DialogTitle,
} from "@headlessui/vue";
import IconTwitter from "../icons/IconTwitter.vue";
import IconClose from "../icons/IconClose.vue";
import { useAuthStore } from "../../stores/authStore";
import DayInput from "./DayInput.vue";
import MonthInput from "./MonthInput.vue";
import YearInput from "./YearInput.vue";

const authStore = useAuthStore();

const props = defineProps({
  toShow: {
    type: Boolean,
    required: true,
  },
  registerProp: {
    type: Boolean,
  },
});

///////////////////
// date handler //
//////////////////

const date = ref({
  day: null,
  month: null,
  year: null,
});

///////////////////
/// modal part ///
//////////////////

const register = ref(props.registerProp);

watch(
  () => props.toShow,
  (value) => {
    isOpen.value = value;
  }
);

watch(
  () => props.registerProp,
  (value) => {
    register.value = value;
  }
);

watch(
  () => authStore.isAuthenticated,
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
  register.value = false;
  close("close");
}

///////////////////
/// login part ///
//////////////////

const emailFocus = ref(false);
const passwordFocus = ref(false);

const form = ref({
  email: "",
  password: "",
});

const login = (event) => {
  event.preventDefault();
  const response = authStore.login(form.value.email, form.value.password);
};

///////////////////
// register part //
///////////////////

const monthsIndex = [
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

const registerUser = (event) => {
  const dateGenerated = `${date.value.year}-${
    monthsIndex.indexOf(date.value.month) + 1
  }-${date.value.day}`;
  console.log(dateGenerated);
  event.preventDefault();
  const response = authStore.register(
    registerForm.value.name,
    registerForm.value.email,
    registerForm.value.password,
    registerForm.value.password_confirmation,
    registerForm.value.username,
    dateGenerated
  );
};

const registerForm = ref({
  email: "",
  password: "",
  password_confirmation: "",
  username: "",
  name: "",
  dateOfBirth: "",
});

const registerFocus = ref({
  password_confirmation: false,
  username: false,
  name: false,
  dateOfBirth: false,
});
</script>

<style scoped>
.group {
  position: relative;
  padding-top: 7px;
}

.input {
  font-size: 17px;
  padding: 10px 10px 10px 5px;
  display: block;
  width: 100%;
  border: none;
  background: transparent;
}

.input:focus {
  outline: none;
}

label {
  font-size: 18px;
  font-weight: normal;
  position: absolute;
  pointer-events: none;
  left: 5px;
  top: 12px;
  transition: 0.2s ease all;
  -moz-transition: 0.2s ease all;
  -webkit-transition: 0.2s ease all;
}

.input:focus ~ label,
.input:valid ~ label {
  top: 0px;
  font-size: 13px;
  /* color: #5264AE; */
}

.bar {
  position: relative;
  display: block;
  width: 100%;
}

.bar:before,
.bar:after {
  content: "";
  height: 2px;
  width: 0;
  bottom: 1px;
  position: absolute;
  /* background: #5264AE; */
  transition: 0.2s ease all;
  -moz-transition: 0.2s ease all;
  -webkit-transition: 0.2s ease all;
}

.bar:before {
  left: 50%;
}

.bar:after {
  right: 50%;
}

.input:focus ~ .bar:before,
.input:focus ~ .bar:after {
  width: 50%;
}

.highlight {
  position: absolute;
  height: 60%;
  width: 100px;
  top: 25%;
  left: 0;
  pointer-events: none;
  opacity: 0.5;
}

.input:focus ~ .highlight {
  animation: inputHighlighter 0.3s ease;
}
</style>
