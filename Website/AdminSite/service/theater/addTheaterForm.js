import { screenSizeWith } from "../../constant/screenSize.js";
import { addTheater } from "./addMovieTheater.js";
import { getAndDisplayTheater } from "./getTheater.js";
$(document).on("click", "#btn-add-theater", async function (event) {
  addTheaterForm();
});

async function addTheaterForm(){
  try {
    const showForm = async () => {
      await getAndDisplayTheater();
      return await Swal.fire({
        width: screenSizeWith(),
        title: "Thêm chi nhánh rạp chiếu mới!",
        html: `
          <div class="bg-light rounded h-100 p-4">
            <form id="AddTheaterForm">
              <div class="mb-3">
                <label for="nametheaterInput" class="form-label">Tên chi nhánh</label>
                <input type="text" class="form-control" id="nametheaterInput" />
              </div>
              <div class="mb-3">
                <label for="addresstheaterInput" class="form-label">Địa chỉ</label>
                <input type="text" class="form-control" id="addresstheaterInput" />
              </div>
             
            </form>
            <div id="errorMessageText"></div>
          </div>
        `,
        showCancelButton: true,
        confirmButtonText: "Thêm",
        showLoaderOnConfirm: true,
        preConfirm: () => {
          const nametheater = $("#nametheaterInput").val().trim();
          const addresstheater = $("#addresstheaterInput").val().trim();

          if (!nametheater || !addresstheater) {
            Swal.showValidationMessage(
             "Vui lòng nhập đầy đủ thông tin."
            );
            return false;
          }

          return {
            nametheater: nametheater,
            addresstheater: addresstheater,
          };
        },
      });
    };

    const { value, isConfirmed } = await showForm();

    if (isConfirmed) {
      const result = await addTheater(value.nametheater, value.addresstheater);

      if (result === true) {
        Swal.fire({
          title: "Thành công!",
          text: "Rạp chiếu "+value.nametheater+" đã được thêm.",
          icon: "success",
          confirmButtonText: "OK",
        }).then(() => {
          getAndDisplayTheater();
        });
      } else {
        Swal.fire({
          title: "Error!",
          text: result,
          icon: "error",
          confirmButtonText: "OK",
        }).then(async () => {
          await addTheaterForm();
        });
      }
    }
  } catch (error) {
    console.error(error);
  }
}
