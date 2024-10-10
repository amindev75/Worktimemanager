<template>
  <div class="container mt-5">
    <div class="d-flex justify-content-between mb-4">
      <button class="btn btn-light" @click="goToHome">
        <i class="fas fa-home"></i> Home
      </button>

      <button
        class="btn btn-success"
        data-bs-toggle="modal"
        data-bs-target="#addWorkingTimeModal"
      >
        <i class="fas fa-plus"></i> Ajouter un Working Time
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

    <div
      class="modal fade"
      id="addWorkingTimeModal"
      tabindex="-1"
      aria-labelledby="addWorkingTimeModalLabel"
      aria-hidden="true"
    >
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="addWorkingTimeModalLabel">
              Ajouter un Working Time
            </h5>
            <button
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
              aria-label="Close"
            ></button>
          </div>
          <div class="modal-body">
            <form @submit.prevent="addWorkingTime">
              <div class="mb-3">
                <label for="selectUser" class="form-label"
                  >Sélectionner un utilisateur</label
                >
                <select
                  id="selectUser"
                  class="form-control"
                  v-model="newWorkingTime.user_id"
                  required
                >
                  <option v-for="user in users" :key="user.id" :value="user.id">
                    {{ user.username }}
                  </option>
                </select>
              </div>

              <div class="mb-3">
                <label for="startTime" class="form-label">Début</label>
                <input
                  type="datetime-local"
                  class="form-control"
                  id="startTime"
                  v-model="newWorkingTime.start"
                  required
                />
              </div>
              <div class="mb-3">
                <label for="endTime" class="form-label">Fin</label>
                <input
                  type="datetime-local"
                  class="form-control"
                  id="endTime"
                  v-model="newWorkingTime.end"
                  required
                />
              </div>
              <button type="submit" class="btn btn-primary">Ajouter</button>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";
import axios from "axios";
import * as bootstrap from "bootstrap";

export default {
  name: "WorkingTimePage",
  setup() {
    const router = useRouter();
    const searchQuery = ref("");
    const users = ref([]);
    const workingTimes = ref([]);
    const newWorkingTime = ref({
      start: "",
      end: "",
      user_id: null,
    });
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

    const addWorkingTime = async () => {
      if (!newWorkingTime.value.user_id) {
        return;
      }

      try {
        await axios.post(
          `http://localhost:4000/api/workingtime/${newWorkingTime.value.user_id}`,
          {
            workingtime: {
              start: newWorkingTime.value.start,
              end_w: newWorkingTime.value.end,
            },
            userId: newWorkingTime.value.user_id,
          }
        );

        const modalElement = document.getElementById("addWorkingTimeModal");
        const modalInstance = bootstrap.Modal.getInstance(modalElement);
        if (modalInstance) {
          modalInstance.hide();
        }

        newWorkingTime.value = {
          start: "",
          end: "",
          user_id: null,
        };
      } catch (error) {
        // Intentionally left empty
      }
    };

    const fetchAllUsers = async () => {
      try {
        const response = await axios.get("http://localhost:4000/api/users");
        users.value = response.data.data || [];
      } catch (error) {
        // Intentionally left empty
      }
    };

    onMounted(fetchAllUsers);

    return {
      goToHome,
      searchQuery,
      users,
      workingTimes,
      newWorkingTime,
      searchUsers,
      getWorkingTimes,
      addWorkingTime,
      alertMessage,
    };
  },
};
</script>
