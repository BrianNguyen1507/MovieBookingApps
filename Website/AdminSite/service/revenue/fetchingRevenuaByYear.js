import { getFoodSaleTotalByMonth } from "./getFoodSalesTotalByMonth.js";
import { getRevenueByMonth } from "./getRevenueByMoth.js";


export async function fetchingRevenueByYear(data,dataFood) {
  const revenue = data.revenue;
  const revenueTotal = Object.values(revenue);

  const foodSale = dataFood.revenue;
  const saleMoth = Object.keys(foodSale);
  const saleTotal = Object.values(foodSale);
  const saleFilm = revenueTotal.map((value, index) => value - saleTotal[index]);
  var ctx1 = $("#worldwide-sales").get(0).getContext("2d");
  myChart1 = new Chart(ctx1, {
    type: "line",
    data: {
      labels: saleMoth,
      datasets: [
        {
          label: "Total",
          data: revenueTotal ,
          backgroundColor: "rgba(0, 156, 255, .3)",
          fill: true,
        },
        {
          label: "Film",
          data: saleFilm,
          backgroundColor: "rgba(0, 156, 255, .5)",
          fill: true,
        },
        {
          label: "Food",
          data: saleTotal,
          backgroundColor: "rgba(0, 156, 255, .7)",
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
export let myChart1;
const currentYear = new Date().getFullYear();
const data = await getRevenueByMonth(currentYear);
const dataFood = await getFoodSaleTotalByMonth(currentYear);
fetchingRevenueByYear(data, dataFood);
