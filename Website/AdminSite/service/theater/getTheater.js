import { getUserToken } from "../authenticate/authenticate.js";
const url = "http://localhost:8083/cinema/getAllMovieTheater";
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
        <button class="btn btn-primary btn-theater-update" data-id="${theater.id}">Edit</button>
        <button class="btn btn-danger btn-theater-delete" data-id="${theater.id}">Delete</button>
      `;

      const deleteButton = actionCell.querySelector(".btn-theater-delete");
      const editButton = actionCell.querySelector(".btn-theater-update");
      //delete event
      deleteButton.addEventListener("click", async () => {
        try {
          const confirmation = await Swal.fire({
            title: "Are you sure?",
            text: "Do you really want to delete this Theater?",
            icon: "warning",
            showCancelButton: true,
            confirmButtonText: "Yes, delete it!",
            cancelButtonText: "No, cancel",
          });

          if (confirmation.isConfirmed) {
            const result = await deleteTheaeterById(theater.id);
            if (result) {
              tbody.removeChild(row);
              getAndDisplayTheater();
              Swal.fire({
                title: "Deleted!",
                text: `Theater ${theater.name} has been deleted.`,
                icon: "success",
                confirmButtonText: "OK",
              });
            } else {
              Swal.fire({
                title: "Error!",
                text: "Failed to delete the Theater.",
                icon: "error",
                confirmButtonText: "OK",
              });
            }
          } else {
            Swal.fire({
              title: "Cancelled",
              text: "Theater deletion was cancelled.",
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
