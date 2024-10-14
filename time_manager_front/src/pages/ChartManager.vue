<template>
  <div class="container-fluid mt-5">
    <div class="d-flex justify-content-between mb-4">
      <button class="btn btn-light" @click="goToHome">
        <i class="fas fa-home"></i> Home
      </button>
    </div>
    <h1 class="text-center mb-5">Statistiques de {{ username }}</h1>

    <div style="margin: 8vh">
      <div class="row mb-4">
        <div class="col-md-4 chart-container">
          <Bar :key="chartKey" :data="barData" :options="chartOptions" />
        </div>
        <div class="col-md-4 chart-container">
          <Doughnut :data="doughnutData" :options="doughnutOptions" />
        </div>
        <div class="col-md-4 chart-container">
          <Line :data="lineData" :key="chartKey" :options="lineOptions" />
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
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

canvas {
  max-width: 100% !important;
  height: auto !important;
}
</style>

<script setup>
import { ref, onMounted } from "vue";
import { useRouter, useRoute } from "vue-router";
import {
  Chart as ChartJS,
  Title,
  Tooltip,
  Legend,
  ArcElement,
  BarElement,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
} from "chart.js";
import axios from "axios";
import { Bar, Doughnut, Line } from "vue-chartjs";

ChartJS.register(
  Title,
  Tooltip,
  Legend,
  BarElement,
  CategoryScale,
  ArcElement,
  LinearScale,
  PointElement,
  LineElement
);

const router = useRouter();
const route = useRoute();
const userId = route.params.userid;
const username = ref("");

const goToHome = () => router.push("/");

const fetchUserDetails = async () => {
  try {
    const response = await axios.get(
      `http://localhost:4000/api/users/${userId}`
    );

    if (response.data && response.data.data) {
      username.value = response.data.data.username;
    }
  } catch (error) {
    console.error(
      "Erreur lors de la récupération des détails de l'utilisateur :",
      error
    );
  }
};

onMounted(() => {
  fetchUserDetails();
});

const chartOptions = {
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: { position: "top" },
    title: { display: true, text: "Jours Travaillés par Mois" },
  },
  scales: {
    y: { beginAtZero: true },
  },
};

const doughnutOptions = {
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: { position: "top" },
    title: { display: true, text: "Pourcentage des heures hors standard" },
  },
};

const lineOptions = {
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: { position: "top" },
    title: { display: true, text: "Moyenne d'heures travaillées" },
  },
  scales: {
    y: { beginAtZero: true },
  },
};

const doughnutData = ref({
  labels: ["Heures standards (8h - 16h)", "Heures hors standard"],
  datasets: [
    {
      data: [0, 0],
      backgroundColor: ["#36A2EB", "#FF6384"],
      hoverBackgroundColor: ["#36A2EB", "#FF6384"],
    },
  ],
});

const getLast12Months = () => {
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
  const result = [];
  const today = new Date();
  let currentMonth = today.getMonth();
  for (let i = 0; i < 12; i++) {
    result.unshift(months[currentMonth]);
    currentMonth = (currentMonth - 1 + 12) % 12;
  }
  return result;
};

const getRandomColors = () => {
  const colors = [];
  for (let i = 0; i < 12; i++) {
    const randomColor = `hsl(${Math.random() * 360}, 100%, 75%)`;
    colors.push(randomColor);
  }
  return colors;
};

const barData = ref({
  labels: getLast12Months(),
  datasets: [
    {
      label: `Jours travaillés (${new Date().getFullYear()})`,
      backgroundColor: getRandomColors(),
      data: [],
    },
  ],
});

const lineData = ref({
  labels: getLast12Months(),
  datasets: [
    {
      label: `Moyenne d'heures travaillées`,
      backgroundColor: "rgba(75, 192, 192, 0.2)",
      borderColor: "rgba(75, 192, 192, 1)",
      borderWidth: 2,
      fill: true,
      data: [],
    },
  ],
});

const chartKey = ref(0);

const fetchWorkedDays = async () => {
  if (!userId) return;

  try {
    const response = await axios.get(
      `http://localhost:4000/api/stats/${userId}/worked_days_by_month`
    );
    const workedDaysByMonth = response.data.worked_days_by_month;

    barData.value.datasets[0].data = Array.from({ length: 12 }, (v, i) => {
      return workedDaysByMonth[i] || 0;
    });

    const percentageResponse = await axios.get(
      `http://localhost:4000/api/stats/${userId}/calculate_percentage_working_times_outside_standard_hours`
    );
    const percentageOutside =
      percentageResponse.data.percentage_outside_standard_hours;

    doughnutData.value = {
      labels: ["Heures standards (8h - 16h)", "Heures hors standard"],
      datasets: [
        {
          data: [100 - percentageOutside, percentageOutside],
          backgroundColor: ["#36A2EB", "#FF6384"],
          hoverBackgroundColor: ["#36A2EB", "#FF6384"],
        },
      ],
    };

    const averageHoursResponse = await axios.get(
      `http://localhost:4000/api/stats/${userId}/calculate_average_hours_worked_by_month`
    );
    const averageHoursByMonth =
      averageHoursResponse.data.average_hours_by_month;

    lineData.value.datasets[0].data = Array.from({ length: 12 }, (v, i) => {
      return averageHoursByMonth[i] || 0;
    });
    lineData.value = { ...lineData.value };
    chartKey.value += 1;

    console.log(lineData.value.datasets[0].data);

    barData.value.datasets[0].backgroundColor = getRandomColors();

    chartKey.value += 1;
  } catch (error) {
    console.error(
      "Erreur lors de la récupération des jours travaillés :",
      error
    );
  }
};

onMounted(() => {
  fetchWorkedDays();
});
</script>
