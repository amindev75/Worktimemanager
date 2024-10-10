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

    <div class="row">
      <div v-for="user in users" :key="user.id" class="col-md-4 mb-3">
        <div class="card">
          <div class="card-body">
            <h5 class="card-title">{{ user.username }}</h5>
            <p class="card-text">Email: {{ user.email }}</p>
            <div class="d-flex justify-content-between">
              <button class="btn btn-primary" @click="openEditModal(user)">
                <i class="fas fa-edit"></i> Edit
              </button>
              <button class="btn btn-danger" @click="deleteUser(user.id)">
                <i class="fas fa-trash-alt"></i> Delete
              </button>
              <button
                class="btn btn-warning"
                @click="toggleClockStatus(user.clockId)"
              >
                <i class="fas fa-sync-alt"></i> Toggle Status
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal pour ajouter un utilisateur -->
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

    <!-- Modal pour éditer un utilisateur -->
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

<script>
import axios from "axios";
import { useRouter } from "vue-router";
import * as bootstrap from "bootstrap";

export default {
  name: "UserManagement",
  data() {
    return {
      users: [],
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
    async fetchUsers() {
      try {
        const response = await axios.get("http://localhost:4000/api/users");
        this.users = response.data.data;
      } catch (error) {
        console.error(
          "Erreur lors de la récupération des utilisateurs :",
          error
        );
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
      } catch (error) {
        console.error(
          "Erreur lors de la suppression de l'utilisateur :",
          error
        );
      }
    },
    openEditModal(user) {
      this.selectedUser = { ...user }; // Pré-remplit les informations de l'utilisateur
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
