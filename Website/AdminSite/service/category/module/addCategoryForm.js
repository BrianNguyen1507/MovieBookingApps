import { screenSizeWith } from "../../../constant/screenSize.js";
import { addCategory } from "../addCategory.js";
import { getAndDisplayCategories } from "../getCategory.js";

$(document).on("click", "#btn-add-category", async function (event) {
  try {
    const showForm = async () => {
      await getAndDisplayCategories();
      return await Swal.fire({
        width: screenSizeWith(),
        title: "Thêm Thể loại",
        html: `
          <div class="bg-light rounded h-100 p-4">
            <form id="AddCategoryForm">
              <div class="mb-3">
                <label for="exampleInputEmail1" class="form-label">Tên thể loại</label>
                <input type="text" class="form-control" id="categoriesInput"/>
              </div>
            </form>
            <div id="errorMessageText"></div>
          </div>
        `,
        showCancelButton: true,
        confirmButtonText: "Thêm",
        showLoaderOnConfirm: true,
        preConfirm: () => {
          const nameCategory = $("#categoriesInput").val().trim();

          if (!nameCategory) {
            Swal.showValidationMessage(
              "All fields are required and must be valid."
            );
            return false;
          }

          return {
            nameCategory: nameCategory,
          };
        },
      });
    };

    const { value, isConfirmed } = await showForm();

    if (isConfirmed) {
      const result = await addCategory(value.nameCategory);

      if (result === true) {
        Swal.fire({
          title: "Success!",
          text: "New category has been added.",
          icon: "success",
          confirmButtonText: "OK",
        }).then(() => {
          getAndDisplayCategories();
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
