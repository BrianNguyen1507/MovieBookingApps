import { getUserToken } from "../authenticate/authenticate.js";
import { Category } from "../../models/categories.js";
import { deleteCategoryById } from "./deleteCategory.js";
import { updateCategory } from "./updateCategory.js";

const url = "http://103.200.20.167:8083/cinema/getAllCategory";
export async function getAndDisplayCategories() {
  try {
    const token = await getUserToken();
    const response = await fetch(url, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
    });

    const categories = await response.json();
    if (categories.code !== 1000) {
      return;
    }

    const tbody = document.querySelector("#categories-table tbody");
    tbody.innerHTML = "";

    categories.result.forEach((categoryItem, index) => {
      const category = new Category(categoryItem.id, categoryItem.name);
      const row = document.createElement("tr");

      const indexCell = document.createElement("td");
      indexCell.textContent = index + 1;
      row.appendChild(indexCell);

      const nameCell = document.createElement("td");
      nameCell.textContent = category.name;
      nameCell.style.textAlign = "center";
      nameCell.style.fontWeight = "bold";

      row.appendChild(nameCell);

      const actionCell = document.createElement("td");
      actionCell.style.textAlign = "right";
      actionCell.innerHTML = `
        <button class="btn btn-primary" data-id="${category.id}">Edit</button>
        <button class="btn btn-danger" data-id="${category.id}">Delete</button>
      `;
      row.appendChild(actionCell);

      const deleteButton = actionCell.querySelector(".btn-danger");
      const editButton = actionCell.querySelector(".btn-primary");
      //event delete
      deleteButton.addEventListener("click", async () => {
        try {
          const confirmation = await Swal.fire({
            title: "Are you sure?",
            text: "Do you really want to delete this category?",
            icon: "warning",
            showCancelButton: true,
            confirmButtonText: "Yes, delete it!",
            cancelButtonText: "No, cancel",
          });

          if (confirmation.isConfirmed) {
            const result = await deleteCategoryById(category.id);
            if (result) {
              tbody.removeChild(row);
              Swal.fire({
                title: "Deleted!",
                text: "Category has been deleted.",
                icon: "success",
                confirmButtonText: "OK",
              });
            } else {
              Swal.fire({
                title: "Error!",
                text: "Failed to delete the category.",
                icon: "error",
                confirmButtonText: "OK",
              });
            }
          } else {
            Swal.fire({
              title: "Cancelled",
              text: "Category deletion was cancelled.",
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
      //event edit
      editButton.addEventListener("click", async () => {
        try {
          const result = updateCategory(category.id, category.name);
          if (result) {
            Swal.fire({
              title: "Update Success!",
              icon: "success",
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
  } catch (error) {
    console.error("Error fetching and displaying categories:", error);
  }
}
getAndDisplayCategories();
