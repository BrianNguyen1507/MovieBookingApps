import { screenSizeWith } from "../../constant/screenSize.js";
import { addRoom } from "./addRoom.js";
import { getTheater } from "./getTheaters.js";
import { Room } from "../../models/room.js";
import { getAllRoom } from "./getAllRoom.js";
import { updateData } from "./updateRoomData.js";
import { updateRoom } from "./updateRoom.js";

$(document).on("click", "#btn-add-room", async function (event) {
  try {
    const showForm = async () => {
      const dataId = this.getAttribute("data-id");
      let action = "Thêm";
      if (dataId != null) {
        action = "Sửa";
        $(document).ready(function () {
          updateData(dataId);
        });
      }

      $(document).ready(function () {
        getTheater();
      });

      return await Swal.fire({
        width: screenSizeWith(),
        title: action + " phòng chiếu ",
        html: `
          <div class="container d-flex justify-content-center align-items-center min-vh-50">
    <div class="bg-light rounded p-4 w-50">
        <form id="AddTheaterForm">
        <div class="form-floating mb-3">
                <select class="form-select" id="floatingSelectAddForm" aria-label="Floating label select example">
                </select>
                <label for="floatingSelect">CHỌN RẠP CHIẾU</label>
            </div>
            <div class="mb-3">
                <label for="numberInput" class="form-label">Số phòng chiếu</label>
                <input type="number" class="form-control" id="numberInput" />
            </div>
            <div class="mb-3">
                <label for="columnInput" class="form-label">Số cột</label>
                <input type="number" class="form-control" id="columnInput" />
            </div>
            <div class="mb-3">
                <label for="rowInput" class="form-label">Số hàng</label>
                <input type="number" class="form-control" id="rowInput" />
            </div>
            
        </form>
        <div id="errorMessageText"></div>
    </div>
</div>
        `,
        showCancelButton: true,
        confirmButtonText: action,
        showLoaderOnConfirm: true,
        preConfirm: () => {
          const id = dataId;
          const number = $("#numberInput").val().trim();
          const column = $("#columnInput").val().trim();
          const row = $("#rowInput").val().trim();
          const theaterId = $("#floatingSelectAddForm").val();
          if (!number || !column || !row) {
            Swal.showValidationMessage(
              "All fields are required and must be valid."
            );
            return false;
          }

          return {
            id: id,
            number: number,
            column: column,
            row: row,
            theaterId: theaterId,
          };
        },
      });
    };

    const { value, isConfirmed } = await showForm();

    if (isConfirmed) {
      if (value.id != null) {
        const room = new Room(
          value.id,
          value.number,
          value.row,
          value.column,
          value.theaterId
        );
        console.log(room);
        let result = await updateRoom(room);
        if (result === true) {
          Swal.fire({
            title: "Success!",
            text: "New room has been added.",
            icon: "success",
            confirmButtonText: "OK",
          }).then(() => {
            getAllRoom();
          });
        } else {
          Swal.fire({
            title: "Error!",
            text: result,
            icon: "error",
            confirmButtonText: "OK",
          }).then(async () => {
            await showForm();
          });
        }
      } else {
        const room = new Room(
          null,
          value.number,
          value.row,
          value.column,
          value.theaterId
        );
        let result = await addRoom(room);
        if (result == true) {
          Swal.fire({
            title: "Success!",
            text: "New room has been added.",
            icon: "success",
            confirmButtonText: "OK",
          }).then(() => {
            getAllRoom();
          });
        } else {
          Swal.fire({
            title: "Error!",
            text: result,
            icon: "error",
            confirmButtonText: "OK",
          }).then(async () => {
            await showForm();
          });
        }
      }
    }
  } catch (error) {
    console.error(error);
    Swal.fire({
      title: "Error!",
      text: "An unexpected error occurred.",
      icon: "error",
      confirmButtonText: "OK",
    });
  }
});
