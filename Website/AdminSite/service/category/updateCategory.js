import { getAndDisplayCategories } from "./getCategory.js";
import { getUserToken } from "../authenticate/authenticate.js";
const tokenUser = await getUserToken();
export const updateCategory = (id, name) => {
  Swal.fire({
    title: "Cập nhật thể loại",
    html: `
        <div class="input-group">
            <span class="input-group-text" id="basic-addon3">Tên thể loại</span>
            <input type="text" class="form-control" value = "${name}" id="editcategory" aria-describedby="basic-addon3 basic-addon4">
        </div>
        `,
    showCancelButton: true,
    confirmButtonText: "Cập nhật",
    showLoaderOnConfirm: true,
    preConfirm: () => {
      const name = document.getElementById("editcategory").value;
      return fetch("http://103.200.20.167:8083/cinema/updateCategory", {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${tokenUser}`,
        },
        body: JSON.stringify({
          id,
          name,
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
      getAndDisplayCategories();
    }
  });
};
