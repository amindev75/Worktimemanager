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
  const token = localStorage.getItem("authToken");
  const userRole = localStorage.getItem("userRole");
  const userId = localStorage.getItem("userId");
  const toast = useToast();

  if (to.matched.some((record) => record.meta.requiresAuth)) {
    if (!token) {
      toast.error(
        "Attention, vous devez être connecté pour accéder à cette page."
      );
      next("/");
    } else {
      if (to.path === "/admin" && userRole !== "2") {
        toast.error("Accès refusé. Vous devez être administrateur.");
        next(false);
      } else if (to.path === "/manager" && userRole !== "1") {
        toast.error("Accès refusé. Vous devez être manager.");
        next(false);
      } else if (to.path.startsWith("/chartManager/")) {
        const targetUserId = to.params.userid;

        if (userRole === "0" && userId !== targetUserId) {
          toast.error(
            "Accès refusé. Vous ne pouvez pas accéder à ce graphique."
          );
          next(false);
        } else {
          next();
        }
      } else {
        next();
      }
    }
  } else {
    next();
  }
});

export default router;
