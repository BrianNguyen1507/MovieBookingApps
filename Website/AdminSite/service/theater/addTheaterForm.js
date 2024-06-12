import { screenSizeWith } from "../../constant/screenSize";
import { addTheater } from "./addMovieTheater";
import { getAndDisplayTheater } from "./getTheater";
$(document).on("click", "#btn-add-theater", async function (event) {
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
              "All fields are required and must be valid."
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
          title: "Success!",
          text: "New theater has been added.",
          icon: "success",
          confirmButtonText: "OK",
        }).then(() => {
          setTimeout(function () {
            window.location.reload();
          }, 300);
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
  } catch (error) {
    console.error(error);
  }
});
