import { getUserToken } from "../authenticate/authenticate.js";

const urlcategory = "http://localhost:8083/cinema/getAllCategory";

export async function fetchCategories() {
  try {
    const token = await getUserToken();
    const response = await fetch(urlcategory, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
    });

    const categories = await response.json();
    if (categories.code !== 1000) {
      throw new Error("Failed to fetch categories");
    }

    $(document).ready(function () {
      const selectElement = $("#floatingCategory");

      selectElement.empty();
      categories.result.forEach((categoryData) => {
        const option = $("<option></option>");
        option.attr("value", categoryData.id);
        option.text(categoryData.name);
        selectElement.append(option);
      });
    });
  } catch (error) {
    console.error("Error fetching categories:", error);
  }
}
