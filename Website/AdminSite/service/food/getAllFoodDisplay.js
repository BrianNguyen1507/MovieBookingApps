import { getAllFood } from "./getAllFood.js";
import { Food } from "../../models/food.js";
import { getUserToken } from "../authenticate/authenticate.js";

export async function getAllFoodDisplay() {
  const foods = await getAllFood();
  const tbody = document.querySelector("#foods-table tbody");
  tbody.innerHTML = "";
  foods.forEach((foodItem, index) => {
    const food = new Food(
      foodItem.id,
      foodItem.image,
      foodItem.name,
      foodItem.price
    );
    const row = document.createElement("tr");

    const indexCell = document.createElement("td");
    indexCell.textContent = `${food.id}`;
    row.appendChild(indexCell);

    const imageCell = document.createElement("td");
    const image = document.createElement("img");
    image.src = `data:image/png;base64,${food.image}`;
    image.width = 100;
    imageCell.style.textAlign = "center";
    imageCell.style.verticalAlign = "middle";
    image.alt = `${food.name} Poster`;
    imageCell.appendChild(image);
    row.appendChild(imageCell);

    const nameCell = document.createElement("td");
    nameCell.textContent = `${food.name}`;

    row.appendChild(nameCell);

    const priceCell = document.createElement("td");
    priceCell.textContent = `${food.price}`;

    row.appendChild(priceCell);

    const actionCell = document.createElement("td");
    actionCell.innerHTML = `
          <button class="btn btn-primary btn-room-edit" id="btn-add-food" data-image="${food.image}" data-price="${food.price}" data-name="${food.name}" data-id="${food.id}"><i class="fa fa-regular fa-arrow-up"></i></button>
          <button class="btn btn-danger btn-room-delete"   data-id="${food.id}"><i class="fa fa-solid fa-trash"></i></button>
        `;
    actionCell.style.textAlign = "center";
    row.appendChild(actionCell);

    const deleteButton = actionCell.querySelector(".btn-danger");
    deleteButton.addEventListener("click", async () => {
      try {
        const confirmation = await Swal.fire({
          title: "Xác nhận?",
          text: "Bạn có chắc muốn xóa "+food.name,
          icon: "warning",
          showCancelButton: true,
          confirmButtonText: "Có",
          cancelButtonText: "Hủy",
        });

        if (confirmation.isConfirmed) {
          const result = await deleteFood(food.id);
          if (result) {
            tbody.removeChild(row);
            Swal.fire({
              title: "Thành công!",
              text: "Xóa " + food.name+" thành công.",
              icon: "success",
              confirmButtonText: "OK",
            });
          } else {
            Swal.fire({
              title: "Thất bại!",
              text: "Xóa thức ăn, nước uống thất bại.",
              icon: "error",
              confirmButtonText: "OK",
            });
          }
        } 
      } catch (error) {
        Swal.fire({
          title: "Lỗi!",
          text: error.message,
          icon: "error",
          confirmButtonText: "OK",
        });
      }
    });

    tbody.appendChild(row);
  });
  async function deleteFood(id) {
    const url = "http://103.200.20.167:8083/cinema/deleteFood?id=";
    try {
      const token = await getUserToken();
      const response = await fetch(url + id, {
        method: "DELETE",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
      });

      const food = await response.json();
      if (food.code !== 1000) {
        return;
      }
      return food;
    } catch (error) {
      console.error("Error fetching and displaying theaters:", error);
    }
  }
}
getAllFoodDisplay();
