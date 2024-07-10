import { getAllMovieTheater } from "./getAllTheater.js";
import { fetchingSeclectionRoom } from "./selectionRoom.js";
export async function fetchingSeclectionTheater() {
  const theaterSelection = document.querySelector("#theater-selection");
  const theaters = await getAllMovieTheater();
  theaters.forEach((theater) => {
    const option = document.createElement("option");
    option.value = theater.id;
    option.textContent = theater.name;
    theaterSelection.appendChild(option);
  });
  theaterSelection.addEventListener("change", async (event) => {
    const roomSelection = document.querySelector("#room-selection");
    const selectedValue = theaterSelection.value;
    const $dateInput = $("#schedule-dateStart");
    $dateInput.val("");
    if (selectedValue != "none") fetchingSeclectionRoom(selectedValue);
  });
}
fetchingSeclectionTheater();
