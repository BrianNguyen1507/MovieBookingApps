import { getAllFood } from "./getAllFood";
import { Food } from "../../models/food";
import { getUserToken } from "../authenticate/authenticate";

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
          <button class="btn btn-primary btn-room-edit" id="btn-add-food" data-image="${food.image}" data-price="${food.price}" data-name="${food.name}" data-id="${food.id}">Edit</button>
          <button class="btn btn-danger btn-room-delete"   data-id="${food.id}">Delete</button>
        `;
    actionCell.style.textAlign = "center";
    row.appendChild(actionCell);

    const deleteButton = actionCell.querySelector(".btn-danger");
    deleteButton.addEventListener("click", async () => {
      try {
        const confirmation = await Swal.fire({
          title: "Are you sure?",
          text: "Do you really want to delete this food?",
          icon: "warning",
          showCancelButton: true,
          confirmButtonText: "Yes, delete it!",
          cancelButtonText: "No, cancel",
        });

        if (confirmation.isConfirmed) {
          const result = await deleteFood(food.id);
          if (result) {
            tbody.removeChild(row);
            Swal.fire({
              title: "Deleted!",
              text: "Food has been deleted.",
              icon: "success",
              confirmButtonText: "OK",
            });
          } else {
            Swal.fire({
              title: "Error!",
              text: "Failed to delete the food.",
              icon: "error",
              confirmButtonText: "OK",
            });
          }
        } else {
          Swal.fire({
            title: "Cancelled",
            text: "Food deletion was cancelled.",
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

    tbody.appendChild(row);
  });
  async function deleteFood(id) {
    const url = "http://localhost:8083/cinema/deleteFood?id=";
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
