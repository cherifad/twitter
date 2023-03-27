import { defineStore } from "pinia";
import { useStorage, StorageSerializers } from "@vueuse/core";
import { GET_USER_WITH_PASSWORD, CREATE_NEW_USER } from "../api";

export const useAuthStore = defineStore("auth", {
  state: () => ({
    authUser: useStorage("authUser", null, localStorage, {
      serializer: StorageSerializers.object,
      expires: 1800,
    }),
    authErrors: [],
  }),
  getters: {
    user: (state) => state.authUser,
    errors: (state) => state.authErrors,
    isAuthenticated: (state) => state.user !== null,
    isPremium: (state) => state.user !== null && state.user.premium,
  },
  actions: {
    async login(email, password) {
      this.authError = [];
      try {
        const response = await GET_USER_WITH_PASSWORD(email, password);
        if (response === null) {
          this.authErrors.push("Identifiants incorrects");
        } else {
          this.authUser = response;
          this.router.push(`/profile/${response.username}`);
        }
      } catch (error) {
        this.authErrors.push("Identifiants incorrects");
      }
    },
    async logout() {
      this.authUser = null;
      this.router.push("/");
    },
    async register(
      name,
      email,
      password,
      password_confirmation,
      username,
      dateOfBirth
    ) {
      if (password !== password_confirmation) {
        this.authErrors.push("Les mots de passe ne correspondent pas");
        return;
      }
      this.authError = [];
      try {
        const response = await CREATE_NEW_USER(
          name,
          email,
          password,
          username,
          dateOfBirth
        );
        this.authUser = response.data.userDetails;
        this.router.push(`/profile/${response.username}`);
      } catch (error) {
        this.authErrors = error.response.data.errors;
      }
    },
    // async forgotPassword(email) {
    //   this.authError = [];
    //   await this.getToken();
    //   try {
    //     await axios.post("/forgot-password", {
    //       email,
    //     });
    //     this.router.push("/mot-de-passe-oublie");
    //   } catch (error) {
    //     if (error.response.status === 422) {
    //       this.authErrors = error.response.data.errors;
    //     }
    //   }
    // },
    // async isValid() {
    //   var isValid = false;
    //   if (this.authToken === "") return false;
    //   await axios
    //     .get("/api/User/CheckToken?token=" + this.authToken)
    //     .then((response) => {
    //       isValid = response.data.valid;
    //     })
    //     .catch(() => {});
    //   return isValid;
    // },
    // async getUser() {
    //   if (!(await this.isValid())) {
    //     this.authUser = null;
    //     this.authToken = "";
    //     //this.router.push("/connexion");
    //     return;
    //   }
    // },
  },
});
