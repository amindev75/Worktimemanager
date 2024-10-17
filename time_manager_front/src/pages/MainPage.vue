<script setup>
import { useRouter } from "vue-router";

const router = useRouter();

const goToUserManagement = () => {
  router.push("/admin");
};
</script>

<template>
  <div class="container mt-5">
    <h1 class="text-center mb-5">Bienvenue sur votre espace admin</h1>

    <div class="d-flex justify-content-center mb-4">
      <button class="btn btn-primary mx-2" @click="goToUserManagement">
        Gérer les utilisateurs
      </button>
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
