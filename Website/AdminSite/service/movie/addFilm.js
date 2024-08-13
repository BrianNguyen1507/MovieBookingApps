import { getMessageWithCode } from "../../util/exception/exception.js";
import { getUserToken } from "../authenticate/authenticate.js";

const apiUrl = "http://103.200.20.167:8083/cinema/addFilm";

export async function addMovie(movie) {
  try {
    const tokenUser = await getUserToken();
    const response = await $.ajax({
      url: apiUrl,
      method: "POST",
      contentType: "application/json",
      headers: {
        Authorization: `Bearer ${tokenUser}`,
      },
      data: JSON.stringify(movie),
    });

    if (response.code !== 1000) {
      return getMessageWithCode(response.code);
    }

    return true;
  } catch (error) {
    console.error("Exception:", error);
    return error.responseJSON ? getMessageWithCode(error.responseJSON.code) : error.message;
  }
}
