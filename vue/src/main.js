import { createApp } from 'vue'
import { createPinia } from 'pinia'
import { apolloProvider } from './api/apolloProvider';

import App from './App.vue'
import router from './router'

import './assets/main.css'

const app = createApp(App)

app.use(createPinia())
app.use(apolloProvider)
app.use(router)

app.mount('#app')
