import { createApp } from "vue";
import App from "./App.vue";
import router from "@/router";
import BootstrapVueNext from "bootstrap-vue-next";
import "@fortawesome/fontawesome-free/css/all.css";
import "bootstrap";
import "bootstrap/dist/css/bootstrap.min.css";
import "bootstrap-vue-next/dist/bootstrap-vue-next.css";
import "datatables.net-bs5/css/dataTables.bootstrap5.min.css";
const app = createApp(App);

app.use(BootstrapVueNext);
app.use(router);

app.mount("#app");
