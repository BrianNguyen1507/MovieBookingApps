import { getMessageWithCode } from "../../util/exception/exception.js";
import { getUserToken } from "../authenticate/authenticate.js";
import { getAndDisplayTheater } from "./getTheater.js";
const tokenUser = await getUserToken();
export const UpdateTheater = (id, name, address) => {
  Swal.fire({
    title: "Cập nhật thông tin chi nhánh rạp chiếu",
    html: `
      <div class="input-group">
          <span class="input-group-text" id="basic-addon3">Tên chi nhánh</span>
          <input type="text" class="form-control" value= "${name}" id="editTheaterName" aria-describedby="basic-addon3 basic-addon4">
      </div>
      <div class="input-group">
          <span class="input-group-text" id="basic-addon3">Địa chi</span>
          <input type="text" class="form-control"  value= "${address}" id="editTheaterAddress" aria-describedby="basic-addon3 basic-addon4">
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
          name,
          address,
        }),
      })
        .then( async (response) => {
          if (!response.ok) {
            const responseData = await response.json();
            throw new Error(getMessageWithCode(responseData.code));
          }
          return response.json();
        })
        .catch((error) => {
          Swal.showValidationMessage(error);
        });
    },
    allowOutsideClick: () => !Swal.isLoading(),
  }).then((result) => {
    if (result.isConfirmed) {
      Swal.fire({
        icon: "success",
        title: `Cập nhật rạp chiếu thành công`,
      });
      getAndDisplayTheater();
    }
  });
};
