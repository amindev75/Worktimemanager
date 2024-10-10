<script setup>
import { reactive, onMounted } from "vue";
import { useRouter } from "vue-router";
import axios from "axios";

const baseURI = "http://localhost:3000";

const users = reactive([]);

const router = useRouter();

const goToUserManagement = () => {
  router.push("/user_management");
};

onMounted(async () => {
  try {
    const { data: userData } = await axios.get(`${baseURI}/user`);
    users.push(...userData);
  } catch (error) {
    console.error("Erreur lors de la récupération des utilisateurs :", error);
  }
});
</script>

<template>
  <div class="container mt-5">
    <h1 class="text-center mb-5">Bienvenue sur votre espace admin</h1>

    <div class="d-flex justify-content-center mb-4">
      <button class="btn btn-primary mx-2" @click="goToUserManagement">
        Gérer les utilisateurs
      </button>
      <button class="btn btn-secondary mx-2">Gérer le temps de travail</button>
    </div>
  </div>
</template>

<style scoped>
.users {
  width: 50%;
  margin-left: auto;
  margin-right: auto;
  margin-top: 30px;
}

.user {
  color: #ffffff;
  background-color: #007bff;
  width: fit-content;
  padding: 10px;
  border-radius: 5px;
  margin-bottom: 10px;
}

h3 {
  margin-bottom: 20px;
}

.list {
  display: flex;
  flex-wrap: wrap;
  gap: 10px 20px;
}

.container {
  padding: 20px;
}

.btn {
  padding: 10px 20px;
}
</style>
