import { createRouter, createWebHistory } from "vue-router";
import { useToast } from "vue-toastification"; // Importer la fonction de notification

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
    meta: { requiresAuth: true }, // Route protégée
  },
  {
    path: "/chartManager/:userid",
    component: components["ChartManager"],
    meta: { requiresAuth: true }, // Route protégée
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

// Guard global pour gérer l'authentification
router.beforeEach((to, from, next) => {
  const token = localStorage.getItem("authToken"); // Vérifie si le token existe dans localStorage
  const toast = useToast(); // Utiliser la notification

  if (to.matched.some((record) => record.meta.requiresAuth)) {
    if (!token) {
      // Si non connecté, afficher une notification
      toast.error(
        "Attention, vous devez être connecté pour accéder à cette page."
      );
      // Rediriger vers la page principale ou page de connexion
      next("/");
    } else {
      next(); // Si connecté, permettre la navigation
    }
  } else {
    next(); // Si la page ne nécessite pas d'authentification, continuer
  }
});

export default router;
