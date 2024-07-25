import { getUserToken } from "../authenticate/authenticate.js";

const apiUrl = "http://103.200.20.167:8083/cinema/updateRoom?id=";

export async function updateRoom(room) {
    console.log(room)
  try {
    const tokenUser = await getUserToken();
    const response = await $.ajax({
      url: apiUrl+room.id,
      method: "PUT",
      contentType: "application/json",
      headers: {
        Authorization: `Bearer ${tokenUser}`,
      },
      data: JSON.stringify(room),
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
