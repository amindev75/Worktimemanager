<template>
  <div class="container mt-5">
    <div class="d-flex justify-content-between mb-4">
      <button class="btn btn-light" @click="goToHome">
        <i class="fas fa-home"></i> Home
      </button>
    </div>

    <h1 class="text-center mb-5">Gestion du temps de travail</h1>

    <div>
      <input
        type="text"
        v-model="searchQuery"
        placeholder="Rechercher par email ou username"
        class="form-control"
      />
      <button @click="searchUsers" class="btn btn-primary mt-2">
        Rechercher
      </button>
    </div>

    <div v-if="workingTimes.length > 0" class="mt-5">
      <h3 class="text-center">Working Times</h3>
      <div class="row">
        <div
          v-for="workingTime in workingTimes"
          :key="workingTime.id"
          class="col-md-4 mb-3"
        >
          <div class="card">
            <div class="card-body">
              <p class="card-text">Début : {{ workingTime.start }}</p>
              <p class="card-text">Fin : {{ workingTime.end_w }}</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref } from "vue";
import { useRouter } from "vue-router";
import axios from "axios";

export default {
  name: "WorkingTimePage",
  setup() {
    const router = useRouter();
    const searchQuery = ref("");
    const users = ref([]);
    const workingTimes = ref([]);

    const goToHome = () => {
      console.log("Navigating to home");
      router.push("/");
    };

    const searchUsers = async () => {
      console.log(
        "Recherche d'utilisateurs avec la requête :",
        searchQuery.value
      );
      try {
        const response = await axios.get("http://localhost:4000/api/users", {
          params: {
            email: searchQuery.value || undefined,
            username: searchQuery.value || undefined,
          },
        });

        users.value = response.data.data || [];
        console.log("Utilisateurs trouvés :", users.value);
        const workingtime_userId = users.value[0].id;
        getWorkingTimes(workingtime_userId);
      } catch (error) {
        console.error("Erreur lors de la recherche des utilisateurs :", error);
      }
    };

    const getWorkingTimes = async (userId) => {
      console.log(
        "Récupération des working times pour l'utilisateur ID :",
        userId
      );
      try {
        const response = await axios.get(
          `http://localhost:4000/api/workingtime/${userId}`
        );
        workingTimes.value = response.data.data || [];
        console.log("Working times récupérés :", workingTimes.value);
      } catch (error) {
        console.error(
          "Erreur lors de la récupération des working times :",
          error
        );
      }
    };

    return {
      goToHome,
      searchQuery,
      users,
      workingTimes,
      searchUsers,
      getWorkingTimes,
    };
  },
};
</script>
