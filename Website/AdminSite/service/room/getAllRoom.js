import { getUserToken } from "../authenticate/authenticate.js";
const url = "http://localhost:8083/cinema/getAllRoom";
import { Room } from "../../models/room.js";
import { deleteRoom } from "./deleteRoom.js";


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

    roomData.result.forEach((item, index) => {
      const room = new Room(item.id, item.number, item.row, item.column);
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
      descriptionCell.textContent = `${item.movieTheater.name} - ${item.movieTheater.address}`;
      row.appendChild(descriptionCell);

      const actionCell = document.createElement("td");
      actionCell.innerHTML = `
          <button class="btn btn-primary btn-room-edit" id="btn-add-room" data-id="${room.id}"><i class="fa fa-regular fa-arrow-up"></i></button>
          <button class="btn btn-danger btn-room-delete" data-id="${room.id}"><i class="fa fa-solid fa-trash"></i></button>
        `;
      row.appendChild(actionCell);
    
      tbody.appendChild(row);
      const deleteButton = actionCell.querySelector(".btn-danger");
      deleteButton.addEventListener("click", async () => {
        try {
          const confirmation = await Swal.fire({
            title: "Xác nhận",
            text: "Bạn có chắc muốn xóa phòng chiếu "+room.number+" ở rạp chiếu "+item.movieTheater.name,
            icon: "warning",
            showCancelButton: true,
            confirmButtonText: "Có",
            cancelButtonText: "Hủy",
          });
    
          if (confirmation.isConfirmed) {
            const result = await deleteRoom(room.id);
            if (result) {
              tbody.removeChild(row);
              Swal.fire({
                title: "Thành công!",
                text: "Phòng chiếu "+room.number+" đã được xóa",
                icon: "success",
                confirmButtonText: "OK",
              });
            } else {
              Swal.fire({
                title: "Thất bại!",
                text: "Xóa phòng chiếu thất bại.",
                icon: "error",
                confirmButtonText: "OK",
              });
            }
          }
        } catch (error) {
          Swal.fire({
            title: "Thất bại!",
            text: error.message,
            icon: "error",
            confirmButtonText: "OK",
          });
        }
      });   
    });
  } catch (error) {
    console.error("Error fetching and displaying rooms:", error);
  }
}

getAllRoom();
