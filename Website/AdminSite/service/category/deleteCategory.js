import { getUserToken } from "../authenticate/authenticate.js";

const apiUrl = "http://localhost:8083/cinema/deleteCategory?id=";
const tokenUser = await getUserToken();
export async function deleteCategoryById(categoryId) {
  try {
    const response = await fetch(`${apiUrl}${categoryId}`, {
      method: "DELETE",
      headers: {
        Authorization: `Bearer ${tokenUser}`,
      },
    });

    if (!response.ok) {
      const data = await response.json();
      throw new Error(data.message);
    }

    return true;
  } catch (error) {
    console.error("Error deleting category:", error);
    throw error;
  }
}
