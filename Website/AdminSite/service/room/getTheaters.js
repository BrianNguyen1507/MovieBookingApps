import { getUserToken } from "../authenticate/authenticate.js";

const url = "http://localhost:8083/cinema/getAllMovieTheater";
export async function getTheater() {
  try {
    const token = await getUserToken();
    const response = await fetch(url, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
    });

    const theaterData = await response.json();
    if (theaterData.code !== 1000) {
      return;
    }

    const selectElement = document.querySelector("#floatingSelectAddForm");
    theaterData.result.forEach((theater) => {
      const option = document.createElement("option");
      option.value = theater.id;
      option.textContent = theater.name;
      selectElement.appendChild(option);
    });
  } catch (error) {
  }
}

getTheater();
