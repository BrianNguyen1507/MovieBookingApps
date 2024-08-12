
import { getRevenueTotalByYear } from "./getRevenueTotalByYear.js";

export async function fetchingRevenue() {
  const data = await getRevenueTotalByYear();
 
  const dayLable = data.day;

  var ctx2 = $("#salse-revenue").get(0).getContext("2d");
  myChart2 = new Chart(ctx2, {
    type: "bar",
    data: {
      labels: dayLable,
      datasets: [
        {
          label: "Total",
          data: data.total,
          backgroundColor: "rgba(0, 156, 255, .7)",
          fill: true,
        },
        {
          label: "Film",
          data:  data.film,
          backgroundColor: "rgba(0, 156, 255, .5)",
          fill: true,
        },
        {
          label: "Food",
          data: data.food,
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

fetchingRevenue();
