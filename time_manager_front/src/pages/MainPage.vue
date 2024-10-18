<script setup>
import { ref } from "vue";
import { useRouter } from "vue-router";
import { useToast } from "vue-toastification";
import axios from "axios"; // Pour faire des requêtes HTTP

const router = useRouter();

// Références pour les champs du formulaire
const email = ref("");
const password = ref("");
const errorMessage = ref("");

// Redirection vers la gestion des utilisateurs
const goToUserManagement = () => {
  router.push("/admin");
};

// Fonction de login
const toast = useToast();
const login = async () => {
  try {
    const response = await axios.post("http://localhost:4000/api/login", {
      email: email.value,
      password: password.value,
    });

    // Si la connexion est réussie, tu peux stocker le token dans localStorage
    const token = response.data.token;
    console.log("Login successful, token:", token);

    // Stocker le token dans localStorage
    localStorage.setItem("authToken", token);

    // Rediriger vers l'espace utilisateur après la connexion
    router.push("/admin");
  } catch (error) {
    toast.error("Erreur lors de la connexion. Vérifiez vos identifiants.");
    console.error("Login error:", error);
  }
};
</script>

<template>
  <div class="container mt-5">
    <h1 class="text-center mb-5">Bienvenue sur votre espace admin</h1>

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

    <!-- Bouton pour la gestion des utilisateurs -->
    <div class="d-flex justify-content-center">
      <button class="btn btn-secondary mx-2" @click="goToUserManagement">
        Gérer les utilisateurs
      </button>
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
