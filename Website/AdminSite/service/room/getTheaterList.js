import { getUserToken } from "../authenticate/authenticate.js";
import { getRoomById } from "../room/getAllRoomId.js";
import { getAllRoom } from "./getAllRoom.js";
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

    const selectElement = document.querySelector("#floatingSelect");

    theaterData.result.forEach((theater) => {
      const option = document.createElement("option");
      option.value = theater.id;
      option.textContent = theater.name;
      selectElement.appendChild(option);
    });
    selectElement.addEventListener("change", async (event) => {
      const selectedOption = event.target.options[event.target.selectedIndex];
      const selectedValue = selectedOption.value;

      const tbody = document.querySelector("#room-table tbody");
      tbody.innerHTML = "";
      selectedValue == "all"
        ? await getAllRoom()
        : await getRoomById(selectedValue);
    });
  } catch (error) {
    console.error("Error fetching and displaying theaters:", error);
  }
}

getTheater();
