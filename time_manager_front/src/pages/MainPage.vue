<script setup>
import { ref } from "vue";
import { useRouter } from "vue-router";
import { useToast } from "vue-toastification";
import axios from "axios";

const router = useRouter();

const email = ref("");
const password = ref("");
const errorMessage = ref("");

const toast = useToast();
const login = async () => {
  try {
    const response = await axios.post("http://localhost:4000/api/login", {
      email: email.value,
      password: password.value,
    });

    console.log("Response data:", response.data);

    const token = response.data.token;
    const userRole = response.data.user.role;
    const userID = response.data.user.id;

    console.log("Login successful, token:", token);
    console.log("Login successful, ID:", userID);
    toast.success("Connexion réussie.");

    localStorage.setItem("authToken", token);
    localStorage.setItem("userRole", userRole);
    localStorage.setItem("userId", userID);

    if (userRole === 2) {
      router.push("/admin");
    } else if (userRole === 1) {
      router.push("/manager");
    } else {
      router.push(`/chartManager/${userID}`);
    }
  } catch (error) {
    toast.error("Erreur lors de la connexion. Vérifiez vos identifiants.");
    console.error("Login error:", error);
  }
};
</script>

<template>
  <div class="container mt-5">
    <h1 class="text-center mb-5">Bienvenue sur Time Manager</h1>

    <!-- Formulaire de connexion -->
    <div class="login-form mb-5">
      <h3 class="text-center">Connexion</h3>

      <div class="form-group mb-3">
        <label for="email">Email</label>
        <input
          v-model="email"
          type="email"
          class="form-control"
          id="email"
          placeholder="Entrez votre email"
          required
        />
      </div>

      <div class="form-group mb-3">
        <label for="password">Mot de passe</label>
        <input
          v-model="password"
          type="password"
          class="form-control"
          id="password"
          placeholder="Entrez votre mot de passe"
          required
        />
      </div>

      <button class="btn btn-primary btn-block" @click="login">
        Se connecter
      </button>

      <!-- Affichage des erreurs de connexion -->
      <div v-if="errorMessage" class="alert alert-danger mt-3">
        {{ errorMessage }}
      </div>
    </div>
  </div>
</template>

<style scoped>
.container {
  padding: 20px;
}

h1 {
  margin-bottom: 40px;
}

.login-form {
  max-width: 400px;
  margin: 0 auto;
}

.btn {
  padding: 10px 20px;
}

.alert {
  text-align: center;
}
</style>
