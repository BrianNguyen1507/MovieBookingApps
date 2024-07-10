import { getAllScheduleByRoomAndDate } from "./getAllSchedule";

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
      
      schedules.forEach((schedule, indexColumn) => {
       
        const column = document.createElement("th"); 
        column.classList.add("column-" + indexColumn);
        const date = document.createElement("h5");
        date.textContent = formatDate(schedule.date);
        column.appendChild(date);
        thead.appendChild(column);
        
        schedule.movieSchedule.forEach((movieSchedule, indexRow) => {
          let row = document.querySelector(".row-" + indexRow);
          let flag = row;
          
          if (!row) {
            row = document.createElement("tr");
            row.classList.add("row-" + indexRow);
            if (indexColumn > 0) {
              for (let i = 0; i < indexColumn; i++) {
                const emptyCell = document.createElement("td");
                row.appendChild(emptyCell);
              }
            }
          }
          
      
          const cell = document.createElement("td");
          const div = document.createElement("div");
          
          const timeStart = document.createElement("p");
          timeStart.textContent = movieSchedule.timeStart;
          const timeEnd = document.createElement("p");
          timeEnd.textContent = "- "+ movieSchedule.timeEnd;
          const title = document.createElement("p");
          title.textContent = movieSchedule.film.title;
          const duration = document.createElement("p");
          duration.textContent = movieSchedule.film.duration +" minute";
          const releaseDate = document.createElement("p");
          releaseDate.textContent = formatReleaseDate(movieSchedule.film.releaseDate);
          
          div.appendChild(timeStart);
          div.appendChild(timeEnd);
          div.appendChild(title);
          div.appendChild(duration);
          div.appendChild(releaseDate);
          cell.appendChild(div);
          row.appendChild(cell);
          
          if (!flag) {
            tbody.appendChild(row);
          }
        });
      });
      
    }
  });
});

function formatDate(dateString) {
  const parts = dateString.split("-");
  return `${parts[2]}/${parts[1]}`;
}
function formatReleaseDate(dateString) {
  const parts = dateString.split("-");
  return `${parts[2]}/${parts[1]}/${parts[0]}`;
}

