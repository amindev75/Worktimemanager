<template>
  <div class="container-fluid mt-5">
    <div class="d-flex justify-content-between mb-4">
      <button class="btn btn-light" @click="goToHome">
        <i class="fas fa-home"></i> Home
      </button>
    </div>
    <h1 class="text-center mb-5">Statistiques des Utilisateurs</h1>
    <div style="margin: 8vh">
      <div class="row mb-4">
        <div class="col-md-4 chart-container">
          <Bar id="bar-chart" :data="barData" :options="chartOptions" />
        </div>
        <div class="col-md-4 chart-container">
          <Line id="line-chart" :data="lineData" :options="chartOptions" />
        </div>
        <div class="col-md-4 chart-container">
          <Pie id="pie-chart" :data="pieData" :options="chartOptions" />
        </div>
      </div>
      <div class="row">
        <!-- Row 2: 2 charts -->
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
  labels: ["January", "February", "March", "April", "May", "June"],
  datasets: [
    {
      label: "Sales 2024 (in $)",
      backgroundColor: "#42A5F5",
      data: [5000, 6000, 7000, 8000, 5500, 6200],
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
