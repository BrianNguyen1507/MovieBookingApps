import { getMessageWithCode } from "../../util/exception/exception.js";
import { getUserToken } from "../authenticate/authenticate.js";

export async function deleteSchedule(id) {
  const uri = "http://103.200.20.167:8083/cinema/deleteSchedule?id=";

  const token = await getUserToken();
  const response = await fetch(uri + id, {
    method: "DELETE",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`,
    },
  });
  const responseData = await response.json();

  if (response.status == 200) {
    if (responseData.code == 1000) {
      return responseData.code;
    }
  } else if (response.status == 400) {
    return getMessageWithCode(responseData.code);
  }
}
