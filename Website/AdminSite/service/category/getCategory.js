import { getUserToken } from "../authenticate/authenticate.js";
import { Category } from "../../models/categories.js";
import { deleteCategoryById } from "./deleteCategory.js";
import { updateCategory } from "./updateCategory.js";

const url = "http://localhost:8083/cinema/getAllCategory";
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
        <button class="btn btn-primary" data-id="${category.id}"><i class="fa fa-regular fa-arrow-up"></i></button>
        <button class="btn btn-danger" data-id="${category.id}"><i class="fa fa-solid fa-trash"></i></button>
      `;
      row.appendChild(actionCell);

      const deleteButton = actionCell.querySelector(".btn-danger");
      const editButton = actionCell.querySelector(".btn-primary");
      //event delete
      deleteButton.addEventListener("click", async () => {
        try {
          const confirmation = await Swal.fire({
            title: "Thông báo!",
            text: "Bạn có chắc muốn xóa "+category.name,
            icon: "warning",
            showCancelButton: true,
            confirmButtonText: "Xóa",
            cancelButtonText: "Hủy",
          });

          if (confirmation.isConfirmed) {
            const result = await deleteCategoryById(category.id);
            if (result) {
              tbody.removeChild(row);
              Swal.fire({
                title: "Thành công!",
                text: "Thể loại đã được xóa.",
                icon: "success",
                confirmButtonText: "OK",
              });
            } else {
              Swal.fire({
                title: "Thất bại!",
                text: "Xóa thể loại thất bại.",
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
      //event edit
      editButton.addEventListener("click", async () => {
        try {
          const result = updateCategory(category.id, category.name);
          if (result) {
            Swal.fire({
              title: "Cập nhật thành công!",
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
