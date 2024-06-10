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
    console.log(categories);
    if (categories.code !== 1000) {
      throw new Error("Failed to fetch categories");
    }

    $(document).ready(function () {
      const containerElement = $("#floatingCategory");
      containerElement.empty();
      categories.result.forEach((categoryData) => {
        const checkboxWrapper = $("<div></div>");
        const checkbox = $("<input>")
          .attr("type", "checkbox")
          .attr("id", `category-${categoryData.id}`)
          .attr("name", "categories")
          .attr("value", categoryData.id);
        const label = $("<label></label>")
          .attr("for", `category-${categoryData.id}`)
          .text(categoryData.name);

        checkboxWrapper.append(checkbox);
        checkboxWrapper.append(label);
        containerElement.append(checkboxWrapper);
      });
    });
  } catch (error) {
    console.error("Error fetching categories:", error);
  }
}
