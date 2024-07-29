import { getRevenueByMonth } from "./getRevenueByMoth.js";
import { getFoodSaleTotalByMonth } from "./getFoodSalesTotalByMonth.js";
import { myChart2 } from "./fetchingRevenueByMoth.js";

// JavaScript to dynamically populate the combobox with years
const currentYear = new Date().getFullYear();
const startYear = currentYear - 10; // Define the start year
const yearSelect = document.getElementById("yearSelect");

for (let year = currentYear; year >= startYear; year--) {
  const option = document.createElement("option");
  option.value = year;
  option.textContent = year;
  yearSelect.appendChild(option);
}
yearSelect.addEventListener("change", async function (event) {
  const data = await getRevenueByMonth(yearSelect.value);
  const dataFood = await getFoodSaleTotalByMonth(yearSelect.value);
  const revenueTotal = Object.values(data.revenue);
  const saleTotal = Object.values(dataFood.revenue);
  myChart2.data.datasets[0].data = saleTotal;
  myChart2.data.datasets[1].data = revenueTotal;
  myChart2.update();
});
