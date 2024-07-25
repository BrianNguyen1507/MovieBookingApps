import { getUserToken } from "../authenticate/authenticate.js";
import { Room } from "../../models/room.js";

const url = "http://103.200.20.167:8083/cinema/getAllRoomByTheaterId?theaterId=";
export async function getRoomById(id) {
  try {
    const token = await getUserToken();
    const response = await fetch(url + id, {
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

    roomData.result.forEach((roomItem, index) => {
      const room = new Room(
        roomItem.id,
        roomItem.number,
        roomItem.row,
        roomItem.column
      );
      const row = document.createElement("tr");

      const indexCell = document.createElement("td");
      indexCell.textContent = index + 1;
      row.appendChild(indexCell);

      const numberCell = document.createElement("td");
      numberCell.textContent = `Room ${room.number}`;
      row.appendChild(numberCell);

      const seatsCell = document.createElement("td");
      seatsCell.textContent = `${room.row * room.column} ghế`;
      row.appendChild(seatsCell);

      const descriptionCell = document.createElement("td");
      descriptionCell.textContent = `${roomItem.movieTheater.name} - ${roomItem.movieTheater.address}`;
      row.appendChild(descriptionCell);

      const actionCell = document.createElement("td");
      actionCell.innerHTML = `
          <button class="btn btn-primary btn-room-edit" id="btn-add-room" data-id="${room.id}">Edit</button>
          <button class="btn btn-danger btn-room-delete" data-id="${room.id}">Delete</button>
        `;
      row.appendChild(actionCell);
      tbody.appendChild(row);
      const deleteButton = actionCell.querySelector(".btn-room-delete");
      deleteButton.addEventListener("click", async () => {
        try {
          const confirmation = await Swal.fire({
            title: "Are you sure?",
            text: "Do you really want to delete this category?",
            icon: "warning",
            showCancelButton: true,
            confirmButtonText: "Yes, delete it!",
            cancelButtonText: "No, cancel",
          });

          if (confirmation.isConfirmed) {
            const result = await deleteRoom(room.id);
            if (result) {
              tbody.removeChild(row);
              Swal.fire({
                title: "Deleted!",
                text: "Category has been deleted.",
                icon: "success",
                confirmButtonText: "OK",
              });
            } else {
              Swal.fire({
                title: "Error!",
                text: "Failed to delete the category.",
                icon: "error",
                confirmButtonText: "OK",
              });
            }
          } else {
            Swal.fire({
              title: "Cancelled",
              text: "Category deletion was cancelled.",
              icon: "info",
              confirmButtonText: "OK",
            });
          }
        } catch (error) {
          Swal.fire({
            title: "Error!",
            text: error.message,
            icon: "error",
            confirmButtonText: "OK",
          });
        }
      });
      async function deleteRoom(id) {
        const url = "http://103.200.20.167:8083/cinema/deleteRoom?id=";
        try {
          const token = await getUserToken();
          const response = await fetch(url + id, {
            method: "DELETE",
            headers: {
              "Content-Type": "application/json",
              Authorization: `Bearer ${token}`,
            },
          });

          const room = await response.json();
          if (room.code !== 1000) {
            return;
          }
          return room;
        } catch (error) {
          console.error("Error fetching and displaying theaters:", error);
        }
      }
    });
  } catch (error) {
    console.error("Error fetching and displaying rooms:", error);
  }
}
