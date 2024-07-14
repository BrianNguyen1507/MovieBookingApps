import { formatDate, formatDateRequest, loadingTable } from "./fetchSchedule";
import { addSchedule } from "./addScheuleService";
import { truncateText } from "./selectionFilm";
import { swapSchedule } from "./swapScheduleService";
import { deleteSchedule } from "./deleteScheduleService";

document.addEventListener("DOMContentLoaded", function () {
  let draggedItem = null;

  // Drag and drop events
  document.addEventListener("dragstart", function (event) {
    draggedItem = event.target;
    event.dataTransfer.setData("text/plain", "");
  });

  document.addEventListener("dragover", function (event) {
    event.preventDefault();
  });

  document.addEventListener("drop", async function (event) {
    event.preventDefault();
    if (event.target.classList.contains("drop-column")) {
      const cell = event.target;
      const cellId = cell.id;
      const tbody = document.querySelector("#schedule-table tbody");
      const date = formatDateRequest(
        document.querySelector("#column-" + getIndexColumn(cellId)).children[0]
          .textContent
      );

      if (draggedItem.getAttribute("data-id") == null) {
        const existRow = document.querySelector(
          "#row-" + (tbody.children.length - 2)
        );

        const filmid = draggedItem.getAttribute("filmId");
        const roomId = draggedItem.getAttribute("roomId");
       
        const checkAdd = await checkAddSchedule(roomId, filmid, date);
        const text = checkAdd[0];
        const scheduleId = checkAdd[1];
        if (checkAdd != null) {
          if (existRow) {
            for (let i = 1; i < tbody.children.length; i++) {
              tbody.children[i].children[getIndexColumn(cellId)];
              if (
                tbody.children[i].children[getIndexColumn(cellId)].innerHTML ==
                ""
              ) {
                const cell = document.querySelector("#row-" + (i - 1)).children[
                  getIndexColumn(cellId)
                ];
                cell.classList.add("draggable");
                cell.setAttribute("draggable", "true");
                cell.setAttribute("data-id", scheduleId);
                cell.innerHTML = text;
                return;
              }
            }
            const row = document.createElement("tr");
            row.id = "row-" + (tbody.children.length - 1);
            row.classList.add("drop-row");
            for (let i = 0; i < 8; i++) {
              const cell = document.createElement("td");
              if(i==7){
                cell.classList.add("delete-zone");
                cell.style.backgroundColor = "red";
                const image = document.createElement("img");
                image.classList.add("delete-zone");
                image.src = "img/trash_icon.png";
                image.width=50;
                cell.appendChild(image);
                row.appendChild(cell);
                break;
              }
              cell.id = "col-" + i + "-row-" + (tbody.children.length - 1);
              cell.classList.add("drop-column");
              if (i == getIndexColumn(cellId)) {
                cell.classList.add("draggable");
                cell.setAttribute("draggable", "true");
                cell.innerHTML = text;
                cell.setAttribute("data-id", scheduleId);
              }
              row.appendChild(cell);
            }
            tbody.appendChild(row);
          } else {
            const row = document.createElement("tr");
            row.classList.add("drop-row");
            row.id = "row-" + (tbody.children.length - 1);
            for (let i = 0; i < 8; i++) {
              const cell = document.createElement("td");
              if(i==7){
                cell.classList.add("delete-zone");
                cell.style.backgroundColor = "red";
                const image = document.createElement("img");
                image.classList.add("delete-zone");
                image.src = "img/trash_icon.png";
                image.width=50;
                cell.appendChild(image);
              }else{
                cell.classList.add("drop-column");
                cell.id = "col-" + i + "-row-" + (tbody.children.length - 1);
                if (i == getIndexColumn(cellId)) {
                  cell.classList.add("draggable");
                  cell.setAttribute("draggable", "true");
                  cell.innerHTML = text;
                  cell.setAttribute("data-id", scheduleId);
                }
              }
              row.appendChild(cell);
              
            }
            tbody.appendChild(row);
          }
        }
      } else {
        let idSwap =-1;
        if (cell.getAttribute("data-id") != null) {
            idSwap = cell.getAttribute("data-id");
        }
        const id = draggedItem.getAttribute("data-id");
        const result = await swapSchedule(id, idSwap, date);
        
        if (result) {
          const dateTable = sessionStorage.getItem("date");
          const roomId = sessionStorage.getItem("roomId");
          loadingTable(roomId, dateTable);
        }
      }
    }
    else if (event.target.classList.contains("delete-zone")){
      const id =draggedItem.getAttribute("data-id");
      if(id!=null){
        const result = await deleteSchedule(id);
        if(result==1000){
          const dateTable = sessionStorage.getItem("date");
          const roomId = sessionStorage.getItem("roomId");
          loadingTable(roomId, dateTable);
        }
      }
    }
  });

  document
    .getElementById("delete-zone")
    .addEventListener("drop", async function (event) {
      event.preventDefault();
      
    });
});

function getIndexColumn(string) {
  const parts = string.split("-");
  return parts[1];
}
async function checkAddSchedule(roomId, filmId, date) {
  if (roomId != null || filmId != null) {
    const schedule = await addSchedule(roomId, filmId, date);
    if (schedule != null) {
      return [
        (
          schedule.timeStart +
          "<br> - " +
          schedule.timeEnd +
          "<br>" +
          truncateText(schedule.film.title, 20) +
          "<br>" +
          schedule.film.duration +
          " phút" +
          "<br>" +
          formatDate(schedule.film.releaseDate)
        ).toString(),
        schedule.id,
      ];
    }
  }
  return null;
}
function removeRow(parent, tbody) {
  var count = 0;
  for (let i = 0; i < parent.children.length; i++) {
    if (parent.children[i].children.length == 0) {
      count++;
    }
  }
  if (count == parent.children.length) {
    tbody.removeChild(parent);
  }
}
