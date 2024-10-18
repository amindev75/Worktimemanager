import { createRouter, createWebHistory } from "vue-router";
import { useToast } from "vue-toastification";

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
    path: "/admin",
    component: components["User"],
    meta: { requiresAuth: true },
  },
  {
    path: "/manager",
    component: components["UserForManager"],
    meta: { requiresAuth: true },
  },
  {
    path: "/chartManager/:userid",
    component: components["ChartManager"],
    meta: { requiresAuth: true },
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

router.beforeEach((to, from, next) => {
  const token = localStorage.getItem("authToken"); // Vérifie si le token existe dans localStorage
  const toast = useToast(); // Utiliser la notification

  if (to.matched.some((record) => record.meta.requiresAuth)) {
    if (!token) {
      toast.error(
        "Attention, vous devez être connecté pour accéder à cette page."
      );

      next("/");
    } else {
      next();
    }
  } else {
    next(); // Si la page ne nécessite pas d'authentification, continuer
  }
});

export default router;
