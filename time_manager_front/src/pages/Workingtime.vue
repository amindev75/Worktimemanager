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
      <button
        @click="searchUsers"
        class="btn btn-primary mt-2"
        :disabled="!searchQuery.trim()"
      >
        Rechercher
      </button>

      <div v-if="alertMessage" class="text-danger">
        {{ alertMessage }}
      </div>
    </div>

    <div v-if="workingTimes.length > 0" class="mt-5">
      <h3 class="text-center">Working Times</h3>
      <table class="table table-striped">
        <thead>
          <tr>
            <th>Date</th>
            <th>Heure de départ</th>
            <th>Heure d'arrivée</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="workingTime in workingTimes" :key="workingTime.id">
            <td>{{ new Date(workingTime.start).toLocaleDateString() }}</td>
            <td>{{ new Date(workingTime.start).toLocaleTimeString() }}</td>
            <td>{{ new Date(workingTime.end_w).toLocaleTimeString() }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";
import axios from "axios";

export default {
  name: "WorkingTimePage",
  setup() {
    const router = useRouter();
    const searchQuery = ref("");
    const users = ref([]);
    const workingTimes = ref([]);
    const alertMessage = ref("");

    const goToHome = () => {
      router.push("/");
    };

    const searchUsers = async () => {
      try {
        const response = await axios.get("http://localhost:4000/api/users", {
          params: {
            email: searchQuery.value || undefined,
            username: searchQuery.value || undefined,
          },
        });

        users.value = response.data.data || [];

        if (users.value.length > 0) {
          getWorkingTimes(users.value[0].id);
        } else {
          showAlert("Aucun utilisateur n'a été trouvé.");
        }
      } catch (error) {
        if (error.response && error.response.status === 404) {
          showAlert("Aucun utilisateur n'a été trouvé.");
        }
      }
    };

    const getWorkingTimes = async (userId) => {
      try {
        const response = await axios.get(
          `http://localhost:4000/api/workingtime/${userId}`
        );

        workingTimes.value = response.data.data || [];

        if (workingTimes.value.length === 0) {
          showAlert("Cet utilisateur n'a pas de working times.");
        }
      } catch (error) {
        if (error.response && error.response.status === 404) {
          showAlert("Cet utilisateur n'existe pas.");
        }
      }
    };

    const showAlert = (message) => {
      alertMessage.value = message;

      setTimeout(() => {
        alertMessage.value = "";
      }, 3000);
    };

    onMounted(() => {});

    return {
      goToHome,
      searchQuery,
      users,
      workingTimes,
      searchUsers,
      getWorkingTimes,
      alertMessage,
    };
  },
};
</script>
