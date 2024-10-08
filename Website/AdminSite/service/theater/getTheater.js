import { getUserToken } from "../authenticate/authenticate.js";
const url = "http://103.200.20.167:8083/cinema/getAllMovieTheater";
import { Theater } from "../../models/theater.js";
import { deleteTheaeterById } from "./deleteMovieTheater.js";
import { UpdateTheater } from "./updateMovieTheater.js";
export async function getAndDisplayTheater() {
  try {
    const token = await getUserToken();
    const response = await fetch(url, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
    });

    const theaterData = await response.json();
    if (theaterData.code !== 1000) {
      return;
    }

    const tbody = document.querySelector("#theater-table tbody");
    tbody.innerHTML = "";

    theaterData.result.forEach((theaterData, index) => {
      const theater = new Theater(
        theaterData.id,
        theaterData.name,
        theaterData.address
      );
      const row = document.createElement("tr");

      const indexCell = document.createElement("td");
      indexCell.textContent = index + 1;
      row.appendChild(indexCell);

      const nameCell = document.createElement("td");
      nameCell.textContent = theater.name;
      row.appendChild(nameCell);

      const addressCell = document.createElement("td");
      addressCell.textContent = theater.address;
      row.appendChild(addressCell);

      const actionCell = document.createElement("td");
      actionCell.innerHTML = `
        <button class="btn btn-primary btn-theater-update" data-id="${theater.id}"><i class="fa fa-regular fa-arrow-up"></i></button>
        <button class="btn btn-danger btn-theater-delete" data-id="${theater.id}"><i class="fa fa-solid fa-trash"></i></button>
      `;

      const deleteButton = actionCell.querySelector(".btn-theater-delete");
      const editButton = actionCell.querySelector(".btn-theater-update");
      //delete event
      deleteButton.addEventListener("click", async () => {
        try {
          const confirmation = await Swal.fire({
            title: "Xác nhận",
            text: "Bạn có chắc muốn xóa rạp chiếu "+theater.name,
            icon: "warning",
            showCancelButton: true,
            confirmButtonText: "Có",
            cancelButtonText: "Hủy",
          });

          if (confirmation.isConfirmed) {
            const result = await deleteTheaeterById(theater.id);
            if (result) {
              tbody.removeChild(row);
              getAndDisplayTheater();
              Swal.fire({
                title: "Thành công!",
                text: `Rạp chiếu ${theater.name} đã được xóa.`,
                icon: "success",
                confirmButtonText: "OK",
              });
            } else {
              Swal.fire({
                title: "Thất bại!",
                text: "Xóa rạp chiếu thất bại.",
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
      //edit event
      editButton.addEventListener("click", () => {
        UpdateTheater(theater.id, theater.name, theater.address);
        getAndDisplayTheater();
      });

      row.appendChild(actionCell);
      tbody.appendChild(row);
    });
  } catch (error) {
    console.error("Error fetching and displaying theater:", error);
  }
}
getAndDisplayTheater();
