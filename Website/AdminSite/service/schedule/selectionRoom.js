import { getAllRoomByTheater } from "./getAllRoomByTheater.js";

export async function fetchingSeclectionRoom(id) {
  const roomSelection = document.querySelector("#room-selection");

  if (id != null) {
    const rooms = await getAllRoomByTheater(id);
    console.log(rooms);
    if (rooms.length != 0) {
      removeChild(roomSelection);
      rooms.forEach((room) => {
        const option = document.createElement("option");
        option.value = room.id;
        option.textContent = "Room " + room.number;
        roomSelection.appendChild(option);
      });
    } else {
      removeChild(roomSelection);
    }
  } else {
    removeChild(roomSelection);
  }
  roomSelection.addEventListener("change", async (event) => {
    const $dateInput = $("#schedule-dateStart");
    $dateInput.val("");
    sessionStorage.setItem("roomId",roomSelection.value);
    const thead = document.querySelector("#schedule-table thead");
    const tbody = document.querySelector("#schedule-table tbody");
    thead.innerHTML = "";
    tbody.innerHTML = "";
  });
}
function removeChild(selection) {
  while (selection.firstChild) {
    selection.removeChild(selection.firstChild);
  }
  const option = document.createElement("option");
  option.value = "none";
  option.textContent = "Không có";
  selection.appendChild(option);
}
