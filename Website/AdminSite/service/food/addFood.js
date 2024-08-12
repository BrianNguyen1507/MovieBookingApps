import { getMessageWithCode } from "../../util/exception/exception.js";
import { getUserToken } from "../authenticate/authenticate.js";

const apiUrl = "http://localhost:8083/cinema/addFood";

export async function addFood(food) {
  try {
    const tokenUser = await getUserToken();
    const response = await $.ajax({
      url: apiUrl,
      method: "POST",
      contentType: "application/json",
      headers: {
        Authorization: `Bearer ${tokenUser}`,
      },
      data: JSON.stringify(food),
    });

    if (response.code !== 1000) {
      return getMessageWithCode(response.code);
    }

    return true;
  } catch (error) {
    return error.responseJSON ? getMessageWithCode(error.responseJSON.code) : error.message;
  }
}
