import { getUserToken } from "../authenticate/authenticate.js";

const apiUrl = "http://localhost:8083/cinema/updateFilm?id=";

export async function updateMovie(id, movie) {
  try {
    const tokenUser = await getUserToken();
    const response = await $.ajax({
      url: apiUrl + id,
      method: "PUT",
      contentType: "application/json",
      headers: {
        Authorization: `Bearer ${tokenUser}`,
      },
      data: JSON.stringify(movie),
    });

    if (response.code !== 1000) {
      console.log(response.message)
      return response.message;
    }

    return true;
  } catch (error) {
    console.error("Exception:", error);
    return error.responseJSON ? error.responseJSON.message : error.message;
  }
}
