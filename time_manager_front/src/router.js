import { createRouter, createWebHistory } from "vue-router";

const requireComponent = require.context("@/pages", false, /\.vue$/);
const components = {};

requireComponent.keys().forEach((fileName) => {
  const componentName = fileName.replace("./", "").replace(".vue", "");
  components[componentName] = requireComponent(fileName).default;
});

export const routes = [
  {
    path: "/",
    component: components["MainPage"],
  },
  {
    path: "/user_management",
    component: components["User"],
  },
  {
    path: "/chartManager/:userid",
    component: components["ChartManager"],
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
