import { createApp, markRaw } from 'vue'
import { createPinia } from 'pinia'
import { apolloProvider } from './api/apolloProvider';

import App from './App.vue'
import router from './router'

import './assets/main.css'

const app = createApp(App)

const pinia = createPinia();

pinia.use(({ store }) => {
    store.router = markRaw(router);
});

app.use(pinia)
app.use(apolloProvider)
app.use(router)

app.mount('#app')
