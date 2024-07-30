import { getFoodSaleTotalByMonth } from "./getFoodSalesTotalByMonth.js";
import { getRevenueByMonth } from "./getRevenueByMoth.js";

export async function fetchingRevenue(data, dataFood) {
  const revenue = data.revenue;
  const revenueTotal = Object.values(revenue);

  const foodSale = dataFood.revenue;
  const saleMoth = Object.keys(foodSale);
  const saleTotal = Object.values(foodSale);
  var ctx2 = $("#salse-revenue").get(0).getContext("2d");
  myChart2 = new Chart(ctx2, {
    type: "line",
    data: {
      labels: saleMoth,
      datasets: [
        {
          label: "Salse",
          data: saleTotal,
          backgroundColor: "rgba(0, 156, 255, .5)",
          fill: true,
        },
        {
          label: "Revenue",
          data: revenueTotal,
          backgroundColor: "rgba(0, 156, 255, .3)",
          fill: true,
        },
      ],
    },
    options: {
      responsive: true,
      scales: {
        y: {
          beginAtZero: true,
        },
      },
    },
  });
}
export let myChart2;
const currentYear = new Date().getFullYear();
const data = await getRevenueByMonth(currentYear);
const dataFood = await getFoodSaleTotalByMonth(currentYear);
fetchingRevenue(data, dataFood);
