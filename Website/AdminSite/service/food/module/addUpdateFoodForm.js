import { screenSizeWith } from "../../../constant/screenSize.js";
import { Food } from "../../../models/food.js";
import { updateFood } from "../updateFood.js";

import { addFood } from "../addFood.js";
import { updateFoodData } from "../updateFoodData.js";
import { getAllFoodDisplay } from "../getAllFoodDisplay.js";


$(document).on("click", "#btn-add-food", async function (event) {
      const dataId = this.getAttribute("data-id");
      const dataName = this.getAttribute("data-name");
      const dataPrice = this.getAttribute("data-price");
      const dataImage = this.getAttribute("data-image");
      console.log(dataId);
  addUpdateFood(dataId,dataName,dataPrice,dataImage)
});
export async function addUpdateFood(dataId,dataName,dataPrice,dataImage) {
  try {
    const showForm = async () => {
      
      let action = "Thêm";
      if (dataId != null) {
        action = "Sửa";
        $(document).ready(function () {
          updateFoodData(dataId, dataImage, dataName, dataPrice);

          $("#imageInput").data("base64", dataImage);
          $("#imagePreview")
            .attr("src", `data:image/png;base64,${dataImage}`)
            .show();
        });
      }
      return await Swal.fire({
        width: screenSizeWith(),
        title: action + " thức ăn, nước uống ",
        html: `
          <div class="container d-flex justify-content-center align-items-center min-vh-50">
    <div class="bg-light rounded p-4 w-75">
        <form id="AddTheaterForm">
            <div class="row">
                <div class="col-md-1"></div> <!-- Added empty column for left spacing -->
                <div class="col-md-10">
                    <div class="row">
                        <div class="col-md-4">
                            <div class="mb-3">
                                <label for="imageInput" class="form-label">Choose Image</label>
                                <input type="file" class="form-control" id="imageInput" accept="image/*">
                                <img id="imagePreview" src="" alt="Image Preview" class="mt-3" style="display: none; max-width: 100%; height: auto;" />
                            </div>
                        </div>
                        <div class="col-md-8">
                            <div class="mb-3">
                                <label for="nameInput" class="form-label">Tên đồ ăn</label>
                                <input type="text" class="form-control"  id="nameInput" />
                            </div>
                            <div class="mb-3">
                                <label for="priceInput" class="form-label">Giá</label>
                                <input type="number" class="form-control" id="priceInput" />
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div> <!-- Added empty column for right spacing -->
            </div>
        </form>
        <div id="errorMessageText"></div>
    </div>
</div>



        `,
        didOpen: () => {
          document
            .getElementById("imageInput")
            .addEventListener("change", function () {
              const file = this.files[0];
              if (file) {
                const reader = new FileReader();
                reader.onload = function (e) {
                  const base64String = e.target.result.split(",")[1];
                  $("#imageInput").data("base64", base64String);
                  document.getElementById("imagePreview").src = e.target.result;
                  document.getElementById("imagePreview").style.display =
                    "block";
                };
                reader.readAsDataURL(file);
              }
            });
        },

        showCancelButton: true,
        confirmButtonText: action,
        showLoaderOnConfirm: true,
        preConfirm: () => {
          const id = dataId;
          const imageFood = $("#imageInput").data("base64");
          const name = $("#nameInput").val().trim();
          const price = parseInt($("#priceInput").val(), 10);
          if (!imageFood || !name || isNaN(price)) {
            Swal.showValidationMessage(
              "Vui lòng nhập đầy đủ thông tin."
            );
            return false;
          }

          return {
            id: id,
            imageFood: imageFood,
            name: name,
            price: price,
          };
        },
      });
    };

    const { value, isConfirmed } = await showForm();

    if (isConfirmed) {
      if (value.id != null) {
        const food = new Food(
          value.id,
          value.imageFood,
          value.name,
          value.price
        );
        let result = await updateFood(food);
        if (result === true) {
          Swal.fire({
            title: "Thành công!",
            text: "Cập nhật " +value.name +" thành công.",
            icon: "success",
            confirmButtonText: "OK",
          }).then(() => {
            getAllFoodDisplay();
          });
        } else {
          Swal.fire({
            title: "Thất bại!",
            text: result,
            icon: "error",
            confirmButtonText: "OK",
          }).then(async () => {
            addUpdateFood(value.id,
              value.name,
              value.price,
              value.imageFood)
          });
        }
      } else {
        const food = new Food(null, value.name, value.price, value.imageFood);
        let result = await addFood(food);
        if (result == true) {
          Swal.fire({
            title: "Thành công!",
            text: "Thêm " +  value.name +" thành công.",
            icon: "success",
            confirmButtonText: "OK",
          }).then(() => {
            getAllFoodDisplay();
          });
        } else {
          Swal.fire({
            title: "Thất bại!",
            text: result,
            icon: "error",
            confirmButtonText: "OK",
          }).then(() => {
            addUpdateFood(null, value.imageFood, value.name, value.price)
          });
        }
      }
    }
  } catch (error) {
    Swal.fire({
      title: "Error!",
      text: error,
      icon: "error",
      confirmButtonText: "OK",
    });
  }
}