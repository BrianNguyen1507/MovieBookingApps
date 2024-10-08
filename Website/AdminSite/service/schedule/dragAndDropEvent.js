import { formatDate, formatDateRequest, loadingTable } from "./fetchSchedule.js";
import { addSchedule } from "./addScheuleService.js";
import { truncateText } from "./selectionFilm.js";
import { swapSchedule } from "./swapScheduleService.js";
import { deleteSchedule } from "./deleteScheduleService.js";
import { getMessageWithCode } from "../../util/exception/exception.js";

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
        document.querySelector("#col-" + getIndexColumn(cellId) + "-row-add")
          .textContent
      );

      if (draggedItem.getAttribute("data-id") == null) {
        const existRow = document.querySelector(
          "#row-" + (tbody.children.length - 1)
        );

        const filmid = draggedItem.getAttribute("filmId");
        const roomId = sessionStorage.getItem("roomId");

        const checkAdd = await checkAddSchedule(roomId, filmid, date);
        const text = checkAdd[0];
        const scheduleId = checkAdd[1];
        if (checkAdd != null) {
          if (existRow) {
            for (let i = 0; i < tbody.children.length; i++) {
              tbody.children[i].children[getIndexColumn(cellId)];
              if (
                tbody.children[i].children[getIndexColumn(cellId)].innerHTML ==
                ""
              ) {
                const cell = document.querySelector("#row-" + i).children[
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
            row.id = "row-" + tbody.children.length;
            row.classList.add("drop-row");
            for (let i = 0; i < 8; i++) {
              const cell = document.createElement("td");
              if (i == 7) {
                cell.classList.add("delete-zone");
                cell.style.backgroundColor = "red";
                const image = document.createElement("img");
                image.classList.add("delete-zone");
                image.src = "img/trash_icon.png";
                image.width = 30;
                cell.appendChild(image);
                row.appendChild(cell);
                break;
              }
              cell.id = "col-" + i + "-row-" + tbody.children.length;
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
            row.id = "row-" + tbody.children.length;
            for (let i = 0; i < 8; i++) {
              const cell = document.createElement("td");
              if (i == 7) {
                cell.classList.add("delete-zone");
                cell.style.backgroundColor = "red";
                const image = document.createElement("img");
                image.classList.add("delete-zone");
                image.src = "img/trash_icon.png";
                image.width = 50;
                cell.appendChild(image);
              } else {
                cell.classList.add("drop-column");
                cell.id = "col-" + i + "-row-" + tbody.children.length;
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
        let idSwap = -1;
        if (cell.getAttribute("data-id") != null) {
          idSwap = cell.getAttribute("data-id");
        }
        const id = draggedItem.getAttribute("data-id");
        const response = await swapSchedule(id, idSwap, date);

        if (response.code==1000) {
          const dateTable = sessionStorage.getItem("date");
          const roomId = sessionStorage.getItem("roomId");
          Swal.fire({
            title: "Thành công!",
            text: "Đổi 2 suất chiếu thành công !",
            icon: "success",
            confirmButtonText: "OK",
          }).then(() => {
            loadingTable(roomId, dateTable);
          });
          
        }
        else{
          Swal.fire({
            title: "Thất bại!",
            text: getMessageWithCode(response.code),
            icon: "error",
            confirmButtonText: "OK",
          }).then(() => {
            
          });
        }
      }
    } else if (event.target.classList.contains("delete-zone")) {
      const id = draggedItem.getAttribute("data-id");
      if (id != null) {
        const result = await deleteSchedule(id);
        const dateTable = sessionStorage.getItem("date");
        const roomId = sessionStorage.getItem("roomId");
        if (result == 1000) {
          Swal.fire({
            title: "Thành công!",
            text: "Xóa lịch chiếu thành công!",
            icon: "success",
            confirmButtonText: "OK",
          }).then(() => {
            loadingTable(roomId, dateTable);
          });
         
        } else {
          Swal.fire({
            title: "Thất bại!",
            text: result,
            icon: "error",
            confirmButtonText: "OK",
          }).then(() => {
            
          });
        }
      }
    }
  });
});

function getIndexColumn(string) {
  const parts = string.split("-");
  return parts[1];
}
async function checkAddSchedule(roomId, filmId, date) {
  if (roomId != null || filmId != null) {
    const response = await addSchedule(roomId, filmId, date);
    if (response.code == 1000) {
      const schedule = response.result;
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
    else{
      Swal.fire({
        title: "Thất bại!",
        text: getMessageWithCode(response.code),
        icon: "error",
        confirmButtonText: "OK",
      }).then(() => {
        
      });
    }
  }
  return null;
}

