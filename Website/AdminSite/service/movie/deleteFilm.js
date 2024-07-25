import { getUserToken } from "../authenticate/authenticate.js";

const apiUrl = "http://103.200.20.167:8083/cinema/deleteFilm?id=";

export async function deleteMovie(id) {
  try {
    const tokenUser = await getUserToken();
    const response = await $.ajax({
      url: apiUrl + id,
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
