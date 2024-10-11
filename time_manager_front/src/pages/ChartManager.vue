<template>
  <div class="container-fluid mt-5">
    <div class="d-flex justify-content-between mb-4">
      <button class="btn btn-light" @click="goToHome">
        <i class="fas fa-home"></i> Home
      </button>
    </div>
    <h1 class="text-center mb-5">Statistiques des Utilisateurs</h1>
    <select id="user-select" v-model="selectedUserId" @change="fetchWorkedDays">
      <option disabled value="">Veuillez sélectionner un utilisateur</option>
      <option v-for="user in users" :key="user.id" :value="user.id">
        {{ user.username }}
      </option>
    </select>

    <div style="margin: 8vh">
      <div class="row mb-4">
        <div class="col-md-4 chart-container">
          <Bar :data="barData" :options="chartOptions" />
        </div>
        <div class="col-md-4 chart-container">
          <Line id="line-chart" :data="lineData" :options="chartOptions" />
        </div>
        <div class="col-md-4 chart-container">
          <Pie id="pie-chart" :data="pieData" :options="chartOptions" />
        </div>
      </div>
      <div class="row">
        <div class="col-md-6 chart-container">
          <Doughnut
            id="doughnut-chart"
            :data="doughnutData"
            :options="chartOptions"
          />
        </div>
        <div class="col-md-6 chart-container">
          <Radar id="radar-chart" :data="radarData" :options="chartOptions" />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from "vue-router";
import { Bar, Line, Pie, Doughnut, Radar } from "vue-chartjs";
import {
  Chart as ChartJS,
  Title,
  Tooltip,
  Legend,
  BarElement,
  LineElement,
  PointElement,
  ArcElement,
  RadialLinearScale,
  CategoryScale,
  LinearScale,
} from "chart.js";

// Register Chart.js components
ChartJS.register(
  Title,
  Tooltip,
  Legend,
  BarElement,
  LineElement,
  PointElement,
  ArcElement,
  RadialLinearScale,
  CategoryScale,
  LinearScale
);

const router = useRouter();
const goToHome = () => {
  router.push("/");
};

// Sample chart data and options
const chartOptions = {
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: {
      position: "top",
    },
    title: {
      display: true,
      text: "Jours Travaillés par Mois",
    },
  },
  scales: {
    y: {
      beginAtZero: true,
    },
  },
};

// Bar chart data
const barData = {
  labels: [
    "Janvier",
    "Février",
    "Mars",
    "Avril",
    "Mai",
    "Juin",
    "Juillet",
    "Août",
    "Septembre",
    "Octobre",
    "Novembre",
    "Décembre",
  ],
  datasets: [
    {
      label: "Jours travaillés (2024)",
      backgroundColor: "#42A5F5",
      data: [], // Initialisez avec un tableau vide
    },
  ],
};

// Line chart data
const lineData = {
  labels: ["January", "February", "March", "April", "May", "June"],
  datasets: [
    {
      label: "Revenue 2024 (in $)",
      borderColor: "#FF5733",
      backgroundColor: "rgba(255, 87, 51, 0.2)",
      data: [4500, 5200, 6300, 7000, 6700, 7500],
      fill: true,
    },
  ],
};

// Pie chart data
const pieData = {
  labels: ["Product A", "Product B", "Product C"],
  datasets: [
    {
      data: [300, 50, 100],
      backgroundColor: ["#FF6384", "#36A2EB", "#FFCE56"],
      hoverBackgroundColor: ["#FF6384", "#36A2EB", "#FFCE56"],
    },
  ],
};

// Doughnut chart data
const doughnutData = {
  labels: ["North", "South", "East", "West"],
  datasets: [
    {
      data: [1200, 1900, 3000, 500],
      backgroundColor: ["#FF6384", "#36A2EB", "#FFCE56", "#4BC0C0"],
      hoverBackgroundColor: ["#FF6384", "#36A2EB", "#FFCE56", "#4BC0C0"],
    },
  ],
};

// Radar chart data
const radarData = {
  labels: ["Strength", "Speed", "Endurance", "Agility", "Intelligence"],
  datasets: [
    {
      label: "Athlete 1",
      backgroundColor: "rgba(179,181,198,0.2)",
      borderColor: "rgba(179,181,198,1)",
      pointBackgroundColor: "rgba(179,181,198,1)",
      data: [65, 59, 90, 81, 56],
    },
    {
      label: "Athlete 2",
      backgroundColor: "rgba(255,99,132,0.2)",
      borderColor: "rgba(255,99,132,1)",
      pointBackgroundColor: "rgba(255,99,132,1)",
      data: [28, 48, 40, 19, 96],
    },
  ],
};
</script>

<script>
import axios from "axios";

export default {
  data() {
    return {
      users: [], // Pour stocker les utilisateurs
      selectedUserId: "", // Pour stocker l'ID de l'utilisateur sélectionné
      workedDaysByMonth: {}, // Pour stocker les jours travaillés par mois
      barData: {
        // Ajoutez barData ici
        labels: [
          "Janvier",
          "Février",
          "Mars",
          "Avril",
          "Mai",
          "Juin",
          "Juillet",
          "Août",
          "Septembre",
          "Octobre",
          "Novembre",
          "Décembre",
        ],
        datasets: [
          {
            label: "Jours travaillés (2024)",
            backgroundColor: "#42A5F5",
            data: [], // Initialisez avec un tableau vide
          },
        ],
      },
    };
  },
  mounted() {
    this.fetchUsers(); // Récupérer les utilisateurs lorsque le composant est monté
  },
  methods: {
    async fetchUsers() {
      try {
        const response = await axios.get("http://localhost:4000/api/users");
        this.users = response.data.data; // Accédez à la propriété 'data'
        console.log(this.users); // Pour vérifier le contenu
      } catch (error) {
        console.error(
          "Erreur lors de la récupération des utilisateurs :",
          error
        );
      }
    },

    async fetchWorkedDays() {
      if (!this.selectedUserId) return; // Ne rien faire si aucun utilisateur n'est sélectionné
      try {
        const response = await axios.get(
          `http://localhost:4000/api/stats/${this.selectedUserId}/worked_days_by_month`
        );
        this.workedDaysByMonth = response.data.worked_days_by_month;

        // Mettre à jour les données du graphique avec les jours travaillés
        const months = [
          "Janvier",
          "Février",
          "Mars",
          "Avril",
          "Mai",
          "Juin",
          "Juillet",
          "Août",
          "Septembre",
          "Octobre",
          "Novembre",
          "Décembre",
        ];

        // Initialisez les données du graphique avec 0 pour chaque mois
        const workedDaysArray = months.map(
          (month) => this.workedDaysByMonth[month] || 0
        );

        // Mettre à jour les données du graphique
        this.barData.datasets[0].data = workedDaysArray;

        console.log("Données des jours travaillés :", this.workedDaysByMonth);
      } catch (error) {
        console.error(
          "Erreur lors de la récupération des jours travaillés :",
          error
        );
      }
    },
  },
};
</script>

<style scoped>
/* Ensure no scrolling and a clean, even layout */
.container-fluid {
  max-width: 100%;
  padding: 0 15px;
}

.chart-container {
  height: 300px;
  padding: 10px;
  background-color: #f8f9fa;
  border-radius: 5px;
}

/* Adjust chart responsiveness */
canvas {
  max-width: 100% !important;
  height: auto !important;
}
</style>
