import { defineStore } from "pinia";

export const useNotificationStore = defineStore("notificationyyy",{
  state: () => ({
    notifications: [],
  }),
  getters: {
    getNotifications: (state) => state.notifications,
    unreadNotifications: (state) => state.notifications.length > 0 ? state.notifications.filter((n) => !n.read) : 0,
    unreadNotificationsCount: (state) => state.notifications.length > 0 ? state.notifications.filter((n) => !n.read).length : 0,
    notificationsCount: (state) => state.notifications.length,
  },
  actions: {
    setNotifications(notificationsParam) {
      this.notifications = notificationsParam;
    },
  },
});
