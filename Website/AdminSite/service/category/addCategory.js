import { getUserToken } from "../authenticate/authenticate.js";
import { displayErrorMessage } from "../../util/common.js";
const apiUrl = "http://localhost:8083/cinema/addCategory";

export async function addCategory(categoryName) {
  try {
    const tokenUser = await getUserToken();
    const response = await $.ajax({
      url: apiUrl,
      method: "POST",
      contentType: "application/json",
      headers: {
        Authorization: `Bearer ${tokenUser}`,
      },
      data: JSON.stringify({ name: categoryName }),
    });

    if (response.code !== 1000) {
      return response.message;
    }

    return true;
  } catch (error) {
    console.error("Exception:", error);
    return error.responseJSON ? error.responseJSON.message : error.message;
  }
}
