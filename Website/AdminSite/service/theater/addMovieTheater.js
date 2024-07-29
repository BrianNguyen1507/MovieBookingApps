import { getUserToken } from "../authenticate/authenticate.js";
import { Theater } from "../../models/theater.js";

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

    if (response.code !== 1000) {
      return response.message;
    }

    return true;
  } catch (error) {
    console.error("Exception:", error);
    return error.responseJSON ? error.responseJSON.message : error.message;
  }
}
