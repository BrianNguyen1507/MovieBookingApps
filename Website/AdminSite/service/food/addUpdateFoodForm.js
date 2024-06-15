import { screenSizeWith } from "../../constant/screenSize";
import { Food } from "../../models/food";
import { updateFood } from "./updateFood";

import { addFood } from "./addFood";
import { updateFoodData } from "./updateFoodData";
import { getAllFoodDisplay } from "./getAllFoodDisplay";

$(document).on("click", "#btn-add-food", async function (event) {
  try {
    const showForm = async () => {
      const dataId = this.getAttribute("data-id");
      const dataName = this.getAttribute("data-name");
      const dataPrice = this.getAttribute("data-price");
      const dataImage = this.getAttribute("data-image");
      let action = "Thêm";
      if (dataId != null) {
        action = "Sửa";
        $(document).ready(function () {
          updateFoodData(dataId, dataImage, dataName, dataPrice);
        });
      }
      // Fetch the theaters and populate the select options

      return await Swal.fire({
        width: screenSizeWith(),
        title: action + " đồ ăn thức uống ",
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
          const imageFood = $("#imageInput").data("base64") || "";
          const name = $("#nameInput").val().trim();
          const price = parseInt($("#priceInput").val(), 10);
          if (!imageFood || !name || isNaN(price)) {
            Swal.showValidationMessage(
              "All fields are required and must be valid."
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
            title: "Success!",
            text: "New room has been added.",
            icon: "success",
            confirmButtonText: "OK",
          }).then(() => {
            getAllFoodDisplay();
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
        const food = new Food(null, value.imageFood, value.name, value.price);
        let result = await addFood(food);
        if (result == true) {
          Swal.fire({
            title: "Success!",
            text: "New room has been added.",
            icon: "success",
            confirmButtonText: "OK",
          }).then(() => {
            getAllFoodDisplay();
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
