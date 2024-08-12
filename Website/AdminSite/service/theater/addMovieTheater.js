import { getUserToken } from "../authenticate/authenticate.js";
import { Theater } from "../../models/theater.js";
import { getMessageWithCode } from "../../util/exception/exception.js";

const apiUrl = "http://localhost:8083/cinema/addMovieTheater";

export async function addTheater(theaterName, theaterAddress) {
  try {
    const tokenUser = await getUserToken();
    const theater = new Theater(0, theaterName, theaterAddress);
    const response = await $.ajax({
      url: apiUrl,
      method: "POST",
      contentType: "application/json",
      headers: {
        Authorization: `Bearer ${tokenUser}`,
      },
      data: JSON.stringify(theater),
    });
    return true;
  } catch (error) {
    console.error("Exception:", error);
    return error.responseJSON ? getMessageWithCode(error.responseJSON.code) : error.message;
  }
}
