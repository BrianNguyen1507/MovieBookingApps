import { formatDate, formatDateRequest } from "./fetchSchedule";
import { addSchedule } from "./addScheuleService";
import { truncateText } from "./selectionFilm";

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
      const indexColumn = event.target.id;
      const tbody = document.querySelector("#schedule-table tbody");
      const existRow = document.querySelector(
        "#row-" + (tbody.children.length - 2)
      );

      
      const filmid = draggedItem.getAttribute("filmId");
      const roomId = draggedItem.getAttribute("roomId");
      const date = formatDateRequest(
        document.querySelector("#column-" + getIndexColumn(indexColumn))
          .children[0].textContent
      );
      const checkAdd = await checkAddSchedule(roomId, filmid, date);
      console.log(checkAdd);
      if (checkAdd != null) {
        if (existRow) {
          for (let i = 1; i < tbody.children.length; i++) {
            tbody.children[i].children[getIndexColumn(indexColumn)];
            if (
              tbody.children[i].children[getIndexColumn(indexColumn)]
                .innerHTML == ""
            ) {
              const cell = document.querySelector("#row-" + (i - 1)).children[
                getIndexColumn(indexColumn)
              ];
              cell.classList.add("draggable");
              cell.setAttribute("draggable", "true");
              cell.innerHTML = checkAdd;
              return;
            }
          }
          const row = document.createElement("tr");
          row.id = "row-" + (tbody.children.length - 1);
          row.classList.add("drop-row");
          for (let i = 0; i < 7; i++) {
            const cell = document.createElement("td");
            cell.id = "col-" + i + "-row-" + (tbody.children.length - 1);
            cell.classList.add("drop-column");
            if (i == getIndexColumn(indexColumn)) {
              cell.classList.add("draggable");
              cell.setAttribute("draggable", "true");
              cell.innerHTML = checkAdd;

            }
            row.appendChild(cell);
          }
          tbody.appendChild(row);
        } else {
          const row = document.createElement("tr");
          row.classList.add("drop-row");
          row.id = "row-" + (tbody.children.length - 1);
          for (let i = 0; i < 7; i++) {
            const cell = document.createElement("td");
            cell.classList.add("drop-column");
            cell.id = "col-" + i + "-row-" + (tbody.children.length - 1);
            if (i == getIndexColumn(indexColumn)) {
              cell.classList.add("draggable");
              cell.setAttribute("draggable", "true");
              cell.innerHTML = checkAdd;
            }
            row.appendChild(cell);
          }
          tbody.appendChild(row);
        }
      }
    }
  });

  // document
  //   .getElementById("drop-zone")
  //   .addEventListener("click", function (event) {
  //     if (event.target.classList.contains("drop-column")) {
  //       const dropColumns = document.querySelectorAll(".drop-column");
  //       const dropArray = Array.from(dropColumns);

  //       const draggedIndex = dropArray.indexOf(draggedItem.parentElement);
  //       const targetIndex = dropArray.indexOf(event.target.parentElement);

  //       if (draggedIndex !== -1 && targetIndex !== -1) {
  //         const temp = dropArray[draggedIndex].innerHTML;
  //         dropArray[draggedIndex].innerHTML = dropArray[targetIndex].innerHTML;
  //         dropArray[targetIndex].innerHTML = temp;
  //       }
  //     }
  //   });

  // document
  //   .getElementById("delete-zone")
  //   .addEventListener("drop", function (event) {
  //     event.preventDefault();
  //     if (event.target.id === "delete-zone") {
  //       draggedItem.parentElement.removeChild(draggedItem);
  //     }
  //   });
});

function getIndexColumn(string) {
  const parts = string.split("-");
  return parts[1];
}
async function checkAddSchedule(roomId, filmId, date) {
  if(roomId!=null||filmId!=null){
    const scheule = await addSchedule(roomId, filmId, date);
    if (scheule != null) {
      return (
        scheule.timeStart +
        "<br> - " +
        scheule.timeEnd +
        "<br>" +
        truncateText(scheule.film.title,20) +
        "<br>" +
        scheule.film.duration +
        " phút" +
        "<br>" +
        formatDate(scheule.film.releaseDate)
      ).toString();
    }
  }
  return null;
}
