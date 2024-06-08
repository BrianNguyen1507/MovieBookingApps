import { getUserToken } from "../authenticate/authenticate.js";
const url = "http://localhost:8083/cinema/getAllMovieTheater";
import { Theater } from "../../models/theater.js";
async function getAndDisplayTheater() {
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
      //event
      const deleteButton = actionCell.querySelector(".btn-theater-delete");
      const editButton = actionCell.querySelector(".btn-theater-update");

      
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
      editButton.addEventListener("click", () => {
        UpdateTheater(theater.id);
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

//delete n update call
const apiUrl = "http://localhost:8083/cinema/deleteMovieTheater?id=";
const tokenUser = await getUserToken();
async function deleteTheaeterById(theaterId) {
  try {
    const response = await fetch(`${apiUrl}${theaterId}`, {
      method: "DELETE",
      headers: {
        Authorization: `Bearer ${tokenUser}`,
      },
    });

    if (!response.ok) {
      const data = await response.json();
      throw new Error(data.message);
    }

    return true;
  } catch (error) {
    console.error("Error deleting:", error);
    throw error;
  }
}
const UpdateTheater = (id) => {
  Swal.fire({
    title: "Cập nhật thông tin chi nhánh rạp chiếu",
    html: `
      <div class="input-group">
          <span class="input-group-text" id="basic-addon3">Tên chi nhánh</span>
          <input type="text" class="form-control" id="editTheaterName" aria-describedby="basic-addon3 basic-addon4">
      </div>
      <div class="input-group">
          <span class="input-group-text" id="basic-addon3">Địa chi</span>
          <input type="text" class="form-control" id="editTheaterAddress" aria-describedby="basic-addon3 basic-addon4">
      </div>
      `,
    showCancelButton: true,
    confirmButtonText: "Cập nhật",
    showLoaderOnConfirm: true,
    preConfirm: () => {
      const name = document.getElementById("editTheaterName").value;
      const address = document.getElementById("editTheaterAddress").value;
      return fetch(`http://localhost:8083/cinema/updateMovieTheater?id=${id}`, {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",

          Authorization: `Bearer ${tokenUser}`,
        },
        body: JSON.stringify({
          id,
          name,
          address,
        }),
      })
        .then((response) => {
          if (!response.ok) {
            throw new Error(response.statusText);
          }
          return response.json();
        })
        .catch((error) => {
          Swal.showValidationMessage(`Cập nhật thể loại thất bại: ${error}`);
        });
    },
    allowOutsideClick: () => !Swal.isLoading(),
  }).then((result) => {
    if (result.isConfirmed) {
      Swal.fire({
        icon: "success",
        title: `Cập nhật thể loại thành công`,
      });
      getAndDisplayTheater();
    }
  });
};
