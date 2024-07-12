import { getAllScheduleByRoomAndDate } from "./getAllSchedule";
import { truncateText } from "./selectionFilm";

$(document).ready(function () {
  const $dateInput = $("#schedule-dateStart");
  const roomSelection = document.querySelector("#room-selection");
  var roomValue = roomSelection.value;

  roomSelection.addEventListener("change", (event) => {
    roomValue = roomSelection.value;
  });

  $dateInput.on("change", async function () {
    const selectedDate = $dateInput.val();
    console.log(roomValue);
    if (roomValue != "none") {
      const schedules = await getAllScheduleByRoomAndDate(
        roomValue,
        selectedDate
      );

      const thead = document.querySelector("#schedule-table thead");
      const tbody = document.querySelector("#schedule-table tbody");
      thead.innerHTML = "";
      tbody.innerHTML = "";
      const row = document.createElement("tr");
      row.classList.add("drop-row");
      row.heigh = 100;
      for (let i = 0; i < 7; i++) {
        const cell = document.createElement("td");
        cell.id = "col-" + i + "-row-add";
        cell.classList.add("drop-column");
        cell.textContent = "Add";
        row.appendChild(cell);
      }
      tbody.appendChild(row);

      schedules.forEach((schedule, indexColumn) => {
        const column = document.createElement("th");
        column.id = "column-" + indexColumn;
        const date = document.createElement("h5");
        date.textContent = formatDate(schedule.date);
        column.appendChild(date);
        thead.appendChild(column);

        schedule.movieSchedule.forEach((movieSchedule, indexRow) => {
          if (tbody.children.length - 1 == indexRow) {
            const row = document.createElement("tr");
            row.id = "row-" + indexRow;

            for (let i = 0; i < 7; i++) {
              const emptyCell = document.createElement("td");
              emptyCell.id = "col-" + i + "-row-" + indexRow;
              emptyCell.classList.add("drop-column");
              row.appendChild(emptyCell);
            }
            tbody.appendChild(row);
          }
          const row = document.querySelector("#row-" + indexRow);
          const cell = row.children[indexColumn];
          console.log(cell);
          if (cell) {
            cell.innerHTML =
              movieSchedule.timeStart +
              "<br> - " +
              movieSchedule.timeEnd +
              "<br>" +
              truncateText(movieSchedule.film.title,20) +
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
  });
});


export function formatDate(dateString) {
  const parts = dateString.split("-");
  return `${parts[2]}/${parts[1]}/${parts[0]}`;
}

export function formatDateRequest(dateString) {
  const parts = dateString.split("/");
  return `${parts[2]}-${parts[1]}-${parts[0]}`;
}





