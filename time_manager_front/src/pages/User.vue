<template>
  <div class="container mt-5">
    <div class="d-flex justify-content-between mb-4">
      <button class="btn btn-light" @click="goToHome">
        <i class="fas fa-home"></i> Home
      </button>

      <button
        class="btn btn-success"
        data-bs-toggle="modal"
        data-bs-target="#addUserModal"
      >
        <i class="fas fa-plus"></i> Ajouter un utilisateur
      </button>
    </div>

    <h1 class="text-center mb-5">Gestion des Utilisateurs</h1>

    <div>
      <input
        type="text"
        v-model="searchQuery"
        placeholder="Rechercher par email ou username"
        class="form-control"
      /><br /><br />

      <div class="row">
        <div v-for="user in filteredUsers" :key="user.id" class="col-md-4 mb-3">
          <div
            class="card card-hover position-relative"
            @click="viewStats(user.id)"
          >
            <div class="card-body">
              <div
                v-if="clocks[user.id]"
                :class="{
                  'bg-success': clocks[user.id].status,
                  'bg-danger': !clocks[user.id].status,
                }"
                class="status-indicator position-absolute rounded-circle"
              ></div>

              <h5 class="card-title">{{ user.username }}</h5>
              <p class="card-text">Email: {{ user.email }}</p>

              <div class="d-flex justify-content-between">
                <button
                  class="btn btn-primary"
                  @click.stop="openEditModal(user)"
                >
                  <i class="fas fa-edit"></i>
                </button>
                <button
                  class="btn btn-danger"
                  @click.stop="deleteUser(user.id)"
                >
                  <i class="fas fa-trash-alt"></i>
                </button>
                <button
                  class="btn btn-warning"
                  @click.stop="toggleClockStatus(user.id)"
                >
                  <i class="fas fa-sync-alt"></i>
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div
      class="modal fade"
      id="addUserModal"
      tabindex="-1"
      aria-labelledby="addUserModalLabel"
      aria-hidden="true"
    >
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="addUserModalLabel">
              Ajouter un utilisateur
            </h5>
            <button
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
              aria-label="Close"
            ></button>
          </div>
          <div class="modal-body">
            <form @submit.prevent="addUser">
              <div class="mb-3">
                <label for="username" class="form-label"
                  >Nom d'utilisateur</label
                >
                <input
                  type="text"
                  class="form-control"
                  id="username"
                  v-model="newUser.username"
                  required
                />
              </div>
              <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <input
                  type="email"
                  class="form-control"
                  id="email"
                  v-model="newUser.email"
                  required
                />
              </div>
              <button type="submit" class="btn btn-primary">Ajouter</button>
            </form>
          </div>
        </div>
      </div>
    </div>

    <div
      class="modal fade"
      id="editUserModal"
      tabindex="-1"
      aria-labelledby="editUserModalLabel"
      aria-hidden="true"
    >
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="editUserModalLabel">
              Modifier l'utilisateur
            </h5>
            <button
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
              aria-label="Close"
            ></button>
          </div>
          <div class="modal-body">
            <form @submit.prevent="editUser">
              <div class="mb-3">
                <label for="editUsername" class="form-label"
                  >Nom d'utilisateur</label
                >
                <input
                  type="text"
                  class="form-control"
                  id="editUsername"
                  v-model="selectedUser.username"
                  required
                />
              </div>
              <div class="mb-3">
                <label for="editEmail" class="form-label">Email</label>
                <input
                  type="email"
                  class="form-control"
                  id="editEmail"
                  v-model="selectedUser.email"
                  required
                />
              </div>
              <button type="submit" class="btn btn-primary">Sauvegarder</button>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style>
.status-indicator {
  width: 15px;
  height: 15px;
  top: 10px;
  right: 10px;
}

.card-hover {
  transition: box-shadow 0.3s ease-in-out;
}

.card-hover:hover {
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
  cursor: pointer;
}
</style>

<script>
import axios from "axios";
import { useRouter } from "vue-router";
import * as bootstrap from "bootstrap";

export default {
  name: "UserManagement",
  data() {
    return {
      searchQuery: "",
      users: [],
      clocks: {},
      newUser: {
        username: "",
        email: "",
      },
      selectedUser: {
        id: null,
        username: "",
        email: "",
      },
    };
  },
  computed: {
    filteredUsers() {
      if (!this.searchQuery.trim()) {
        return this.users;
      }
      const query = this.searchQuery.toLowerCase();
      return this.users.filter(
        (user) =>
          user.username.toLowerCase().includes(query) ||
          user.email.toLowerCase().includes(query)
      );
    },
  },
  setup() {
    const router = useRouter();

    const goToHome = () => {
      router.push("/");
    };

    return {
      goToHome,
    };
  },
  mounted() {
    this.fetchUsers();
  },
  methods: {
    viewStats(userId) {
      this.$router.push({ path: `/chartManager/${userId}` });
    },
    async toggleClockStatus(userId) {
      try {
        const res = await axios.put(
          `http://localhost:4000/api/clocks/${userId}/toggle_status`
        );
        if (res.data && res.data.clock) {
          this.clocks[userId] = res.data.clock;
        }
      } catch (error) {
        console.error(
          "Erreur lors de la mise à jour du statut du clock :",
          error
        );
      }
    },
    async fetchUsers() {
      try {
        const response = await axios.get("http://localhost:4000/api/users");
        this.users = response.data.data;
        this.users.forEach(async (user) => {
          const clock = await this.fetchClock(user.id);
          if (clock) {
            this.clocks[user.id] = JSON.parse(JSON.stringify(clock));
          } else {
            this.clocks[user.id] = null;
          }
        });
      } catch (error) {
        console.error(
          "Erreur lors de la récupération des utilisateurs :",
          error
        );
      }
    },
    async fetchClock(userId) {
      try {
        const response = await axios.get(
          `http://localhost:4000/api/clocks/${userId}`
        );
        return response.data.data || null;
      } catch (error) {
        console.error("Erreur lors de la récupération du clock :", error);
        return null;
      }
    },
    async addUser() {
      try {
        const response = await axios.post("http://localhost:4000/api/users", {
          user: {
            username: this.newUser.username,
            email: this.newUser.email,
          },
        });
        this.users.push(response.data.data);
        this.newUser = { username: "", email: "" };
        const modalElement = document.getElementById("addUserModal");
        const modalInstance = bootstrap.Modal.getInstance(modalElement);
        if (modalInstance) {
          modalInstance.hide();
        }
      } catch (error) {
        console.error("Erreur lors de la création de l'utilisateur :", error);
      }
    },
    async deleteUser(userId) {
      try {
        await axios.delete(`http://localhost:4000/api/users/${userId}`);
        this.users = this.users.filter((user) => user.id !== userId);
        delete this.clocks[userId];
      } catch (error) {
        console.error(
          "Erreur lors de la suppression de l'utilisateur :",
          error
        );
      }
    },
    openEditModal(user) {
      this.selectedUser = { ...user };
      const editModal = new bootstrap.Modal(
        document.getElementById("editUserModal")
      );
      editModal.show();
    },
    async editUser() {
      try {
        const response = await axios.put(
          `http://localhost:4000/api/users/${this.selectedUser.id}`,
          {
            user: {
              username: this.selectedUser.username,
              email: this.selectedUser.email,
            },
          }
        );
        const index = this.users.findIndex(
          (user) => user.id === this.selectedUser.id
        );
        if (index !== -1) {
          this.users[index] = response.data.data;
        }
        const modalElement = document.getElementById("editUserModal");
        const modalInstance = bootstrap.Modal.getInstance(modalElement);
        if (modalInstance) {
          modalInstance.hide();
        }
      } catch (error) {
        console.error(
          "Erreur lors de la modification de l'utilisateur :",
          error
        );
      }
    },
  },
};
</script>
