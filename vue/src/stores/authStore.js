import { defineStore } from "pinia";
import { useStorage, StorageSerializers } from "@vueuse/core";
import { GET_USER_WITH_PASSWORD, CREATE_NEW_USER } from "../api";

export const useAuthStore = defineStore("auth", {
  state: () => ({
    twitterUser: useStorage("authUser", null, localStorage, {
      serializer: StorageSerializers.object,
      expires: 1800,
    }),
    twitterAuthErrors: [],
    notifications: [],
  }),
  getters: {
    user: (state) => state.twitterUser,
    errors: (state) => state.twitterAuthErrors,
    isAuthenticated: (state) => state.user !== null,
    isPremium: (state) => state.user !== null && state.user.premium,
    notifications: (state) => state.notifications,
  },
  actions: {
    async login(email, password) {
      this.twitterAuthErrors = [];
      try {
        const response = await GET_USER_WITH_PASSWORD(email, password);
        if (response.length == 0) {
          this.twitterAuthErrors.push("Identifiants incorrects");
          return false;
        } else {
          this.twitterUser = response[0];
          this.router.push(`/profile/${twitterUser.username}`);
          return true;
        }
      } catch (error) {
        this.twitterAuthErrors.push("Identifiants incorrects");
        return false;
      }
    },
    async logout() {
      this.twitterUser = null;
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
        this.twitterAuthErrors.push("Les mots de passe ne correspondent pas");
        return;
      }
      this.twitterAuthErrors = [];
      try {
        const response = await CREATE_NEW_USER(
          name,
          email,
          password,
          username,
          dateOfBirth
        );
        this.twitterUser = response.data;
        this.router.push(`/profile/${response.username}`);
        return true
      } catch (error) {
        this.twitterAuthErrors.push("Une erreur est survenue");
        return false
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
