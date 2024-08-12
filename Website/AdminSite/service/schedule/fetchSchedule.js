import { getAllScheduleByRoomAndDate } from "./getAllSchedule.js";
import { truncateText } from "./selectionFilm.js";

$(document).ready(function () {
  const $dateInput = $("#schedule-dateStart");
  const roomSelection = document.querySelector("#room-selection");
  var roomValue = roomSelection.value;

  roomSelection.addEventListener("change", (event) => {
    roomValue = roomSelection.value;
  });

  $dateInput.on("change", async function () {
    const selectedDate = $dateInput.val();
    sessionStorage.setItem("date", selectedDate);
    console.log(roomValue);
    if (roomValue != "none") {
      await loadingTable(roomValue, selectedDate);
    }
  });
});

export async function loadingTable(roomId, date) {
  const schedules = await getAllScheduleByRoomAndDate(roomId, date);

  const thead = document.querySelector("#schedule-table thead");
  const tbody = document.querySelector("#schedule-table tbody");
  thead.innerHTML = "";
  tbody.innerHTML = "";
  const row = document.createElement("tr");
  row.classList.add("drop-row");
  row.heigh = 100;
  for (let i = 0; i < 7; i++) {
    const cell = document.createElement("th");
    cell.id = "col-" + i + "-row-add";
    cell.classList.add("drop-column");
    row.appendChild(cell);
  }
  thead.appendChild(row);

  schedules.forEach((schedule, indexColumn) => {
    const column = document.querySelector("#col-" + indexColumn + "-row-add");
    column.textContent = formatDate(schedule.date);
    schedule.movieSchedule.forEach((movieSchedule, indexRow) => {
      if (tbody.children.length == indexRow) {
        const row = document.createElement("tr");
        row.id = "row-" + indexRow;

        for (let i = 0; i < 8; i++) {
          const emptyCell = document.createElement("td");
          if (i == 7) {
            emptyCell.classList.add("delete-zone");
            emptyCell.style.backgroundColor = "red";
            const image = document.createElement("img");
            image.classList.add("delete-zone");
            image.src = "img/trash_icon.png";
            image.width = 30;
            emptyCell.appendChild(image);
          } else {
            emptyCell.id = "col-" + i + "-row-" + indexRow;
            emptyCell.classList.add("drop-column");
          }
          row.appendChild(emptyCell);
        }
        tbody.appendChild(row);
      }
      const row = document.querySelector("#row-" + indexRow);
      const cell = row.children[indexColumn];
      if (cell) {
        cell.setAttribute("data-id", movieSchedule.id);
        cell.innerHTML =
          movieSchedule.timeStart +
          "<br> - " +
          movieSchedule.timeEnd +
          "<br>" +
          truncateText(movieSchedule.film.title, 20) +
          "<br>" +
          movieSchedule.film.duration +
          " phút" +
          "<br>" +
          formatDate(movieSchedule.film.releaseDate);
        cell.classList.add("draggable");
        cell.setAttribute("draggable", "true");
      }
    });
  });
}

export function formatDate(dateString) {
  const parts = dateString.split("-");
  return `${parts[2]}/${parts[1]}/${parts[0]}`;
}

export function formatDateRequest(dateString) {
  const parts = dateString.split("/");
  return `${parts[2]}-${parts[1]}-${parts[0]}`;
}
