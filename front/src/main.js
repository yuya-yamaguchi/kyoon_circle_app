import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import { FontAwesomeIcon } from "@/plugins/font-awesome";

var app = createApp(App);
app
.use(store)
.use(router)
.component("fa", FontAwesomeIcon)
.mount('#app');
