import { getUserToken } from "../authenticate/authenticate";

export async function deleteSchedule(id) {
  const uri = "http://localhost:8083/cinema/deleteSchedule?id=";

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
    return responseData.message;
  }
}
