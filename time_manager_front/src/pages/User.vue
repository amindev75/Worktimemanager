<template>
  <div class="container mt-5">
    <div class="d-flex justify-content-between mb-4">
      <button
        class="btn btn-success"
        data-bs-toggle="modal"
        data-bs-target="#addUserModal"
      >
        <i class="fas fa-plus"></i> Ajouter un utilisateur
      </button>

      <button class="btn btn-danger ms-2" @click="logout">
        <i class="fas fa-sign-out-alt"></i>
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
    </div>

    <div
      id="carouselExampleControls"
      class="carousel slide"
      data-bs-interval="false"
    >
      <div class="carousel-inner">
        <!-- Boucle pour chaque groupe d'utilisateurs (9 par slide) -->
        <!--     eslint-disable -->
        <div
          class="carousel-item"
          v-for="(group, index) in chunkArray(filteredUsers, 9)"
          :class="{ active: index === 0 }"
          :key="index"
        >
          <UserOnly />
          <div class="container">
            <div class="row">
              <!-- Boucle pour chaque utilisateur dans le groupe -->
              <div class="col-md-4 mb-3" v-for="user in group" :key="user.id">
                <div
                  class="card card-hover position-relative"
                  @click="viewStats(user.id)"
                >
                  <div class="card-body">
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
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="d-flex justify-content-center mt-3">
      <button
        class="btn btn-secondary me-2"
        type="button"
        data-bs-target="#carouselExampleControls"
        data-bs-slide="prev"
        id="prevButton"
      >
        Précédent
      </button>
      <button
        class="btn btn-secondary ms-2"
        type="button"
        data-bs-target="#carouselExampleControls"
        data-bs-slide="next"
        id="nextButton"
      >
        Suivant
      </button>
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
              <div class="mb-3">
                <label for="role" class="form-label">Rôle</label>
                <select
                  class="form-select"
                  id="role"
                  v-model="newUser.role"
                  required
                >
                  <option value="0">Employé</option>
                  <option value="1">Manager</option>
                  <option value="2">Admin</option>
                </select>
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
.custom-carousel-prev,
.custom-carousel-next {
  background-color: transparent; /* ou autre couleur */
  border: none;
  font-size: 24px; /* Ajuste la taille de la flèche */
  color: #000; /* Couleur de la flèche */
  padding: 10px;
}

.custom-arrow {
  font-weight: bold;
  display: inline-block;
}

.custom-carousel-prev:hover,
.custom-carousel-next:hover {
  color: #007bff; /* Changer la couleur au survol */
}

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
import * as bootstrap from "bootstrap";
import { useToast } from "vue-toastification";

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
        role: 0,
      },
      selectedUser: {
        id: null,
        username: "",
        email: "",
        role: 0,
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
    const toast = useToast();

    return {
      toast,
    };
  },
  mounted() {
    this.fetchUsers();
  },
  methods: {
    // Déconnexion de l'utilisateur
    async logout() {
      try {
        const token = localStorage.getItem("authToken");
        // Appelle la route DELETE pour déconnexion
        await axios.delete("http://localhost:4000/api/logout", {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        });

        localStorage.removeItem("authToken"); // Supprimer le token du localStorage

        // Utilisation de toast depuis setup pour afficher la notification
        this.toast.success("Déconnexion réussie.");

        this.$router.push("/"); // Rediriger l'utilisateur vers la page principale
      } catch (error) {
        console.error("Erreur lors de la déconnexion :", error);
      }
    },
    // Méthode pour diviser les utilisateurs en groupes de taille donnée
    chunkArray(arr, size) {
      let result = [];
      for (let i = 0; i < arr.length; i += size) {
        result.push(arr.slice(i, i + size));
      }
      return result;
    },

    // Rediriger vers les statistiques de l'utilisateur
    viewStats(userId) {
      this.$router.push({ path: `/chartManager/${userId}` });
    },

    // Activer/Désactiver le statut du clock d'un utilisateur
    async toggleClockStatus(userId) {
      try {
        const token = localStorage.getItem("authToken");
        const res = await axios.put(
          `http://localhost:4000/api/clocks/${userId}/toggle_status`,
          {},
          {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          }
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

    // Récupérer la liste des utilisateurs et leurs clocks respectifs
    async fetchUsers() {
      try {
        const token = localStorage.getItem("authToken");
        const response = await axios.get("http://localhost:4000/api/users", {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        });
        console.log(response.data);
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
    // Récupérer le clock d'un utilisateur par son ID
    async fetchClock(userId) {
      try {
        const token = localStorage.getItem("authToken");
        const response = await axios.get(
          `http://localhost:4000/api/clocks/${userId}`,
          {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          }
        );
        return response.data.data || null;
      } catch (error) {
        console.error("Erreur lors de la récupération du clock :", error);
        return null;
      }
    },

    // Ajouter un nouvel utilisateur
    async addUser() {
      try {
        const token = localStorage.getItem("authToken");
        const response = await axios.post(
          "http://localhost:4000/api/users",
          {
            user: {
              username: this.newUser.username,
              email: this.newUser.email,
              role: this.newUser.role,
            },
          },
          {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          }
        );
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

    // Supprimer un utilisateur par son ID
    async deleteUser(userId) {
      try {
        const token = localStorage.getItem("authToken");
        await axios.delete(`http://localhost:4000/api/users/${userId}`, {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        });
        this.users = this.users.filter((user) => user.id !== userId);
        delete this.clocks[userId];
      } catch (error) {
        console.error(
          "Erreur lors de la suppression de l'utilisateur :",
          error
        );
      }
    },

    // Ouvrir la modale d'édition d'un utilisateur
    openEditModal(user) {
      this.selectedUser = { ...user };
      const editModal = new bootstrap.Modal(
        document.getElementById("editUserModal")
      );
      editModal.show();
    },

    // Modifier un utilisateur
    async editUser() {
      try {
        const token = localStorage.getItem("authToken");
        const response = await axios.put(
          `http://localhost:4000/api/users/${this.selectedUser.id}`,
          {
            user: {
              username: this.selectedUser.username,
              email: this.selectedUser.email,
            },
          },
          {
            headers: {
              Authorization: `Bearer ${token}`,
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
