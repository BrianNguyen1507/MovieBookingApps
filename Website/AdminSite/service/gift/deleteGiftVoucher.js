import { getUserToken } from "../authenticate/authenticate.js";

const apiUrl = "http://localhost:8083/cinema/deleteGiftVoucher?id=";

export async function deleteGiftVoucher(id) {
  try {
    const tokenUser = await getUserToken();
    const response = await $.ajax({
      url: apiUrl,
      method: "DELETE",
      contentType: "application/json",
      headers: {
        Authorization: `Bearer ${tokenUser}`,
      },
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
