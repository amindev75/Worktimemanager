import MainPage from "@/pages/MainPage"
import { createRouter, createWebHistory } from 'vue-router';

export const routes = [
    {
        path: '/',
        component: MainPage,
    }
]

const router = createRouter({
    history: createWebHistory(), 
    routes,
  });

export default router;