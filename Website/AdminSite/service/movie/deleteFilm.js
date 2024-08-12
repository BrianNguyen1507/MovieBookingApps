import { getMessageWithCode } from "../../util/exception/exception.js";
import { getUserToken } from "../authenticate/authenticate.js";

const apiUrl = "http://localhost:8083/cinema/deleteFilm?id=";

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
    return true;
  } catch (error) {
    console.error("Exception:", error);
    return error.responseJSON ? getMessageWithCode(error.responseJSON.code) : error.message;
  }
}
