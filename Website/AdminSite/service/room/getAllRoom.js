import { getUserToken } from "../authenticate/authenticate.js";
const url = "http://localhost:8083/cinema/getAllRoom";
import { Room } from "../../models/room.js";
export async function getAllRoom() {
  try {
    const token = await getUserToken();
    const response = await fetch(url, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
    });

    const roomData = await response.json();
    if (roomData.code !== 1000) {
      return;
    }

    const tbody = document.querySelector("#room-table tbody");
    tbody.innerHTML = "";

    roomData.result.forEach((room, index) => {
      
      const row = document.createElement("tr");

     

      const indexCell = document.createElement("td");
      indexCell.textContent = index + 1;
      row.appendChild(indexCell);

      const numberCell = document.createElement("td");
      numberCell.textContent = `${room.number}-${room.movieTheater.name} ` ;
      row.appendChild(numberCell);

      const seatsCell = document.createElement("td");
      seatsCell.textContent = `${countEmptySeats(room.seat)}/${
        room.seat.flat().length
      } ghế trống`;
      row.appendChild(seatsCell);

      const actionCell = document.createElement("td");
      actionCell.innerHTML = `
         <button class="btn btn-dark btn-room-detail" data-id="${room.id}">Detail</button>
          <button class="btn btn-primary btn-room-edit" data-id="${room.id}">Edit</button>
          <button class="btn btn-danger btn-room-delete" data-id="${room.id}">Delete</button>
        `;
      row.appendChild(actionCell);

      tbody.appendChild(row);
    });
  } catch (error) {
    console.error("Error fetching and displaying rooms:", error);
  }
}
function countEmptySeats(seatsArray) {
  let emptySeatCount = 0;
  for (let i = 0; i < seatsArray.length; i++) {
    for (let j = 0; j < seatsArray[i].length; j++) {
      if (seatsArray[i][j] === 0) {
        emptySeatCount++;
      }
    }
  }
  return emptySeatCount;
}
getAllRoom();