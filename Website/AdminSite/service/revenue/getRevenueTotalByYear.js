import { getUserToken } from "../authenticate/authenticate.js";

export async function getRevenueTotalByYear() {
  const apiUrl = "http://localhost:8083/cinema/getRevenueTotalByYear";

  try {
    const tokenUser = await getUserToken();
    const response = await $.ajax({
      url: apiUrl,
      method: "GET",
      contentType: "application/json",
      headers: {
        Authorization: `Bearer ${tokenUser}`,
      },
    });
    if (response.code !== 1000) {
      return response.message;
    }
    return response.result;
  } catch (error) {
    console.error("Exception:", error);
    return error.responseJSON ? error.responseJSON.message : error.message;
  }
}
