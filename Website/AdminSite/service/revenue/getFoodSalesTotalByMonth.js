import { getUserToken } from "../authenticate/authenticate.js";

export async function getFoodSaleTotalByMonth(year) {
const apiUrl = "http://103.200.20.167:8083/cinema/getFoodSaleTotalByMonth?year=";

  try {
    const tokenUser = await getUserToken();
    const response = await $.ajax({
      url: apiUrl+year,
      method: "GET",
      contentType: "application/json",
      headers: {
        Authorization: `Bearer ${tokenUser}`,
      },
    });
    if (response.code !== 1000) {
      return response.message;
    }
    return  response.result;
  } catch (error) {
    console.error("Exception:", error);
    return error.responseJSON ? error.responseJSON.message : error.message;
  }
}