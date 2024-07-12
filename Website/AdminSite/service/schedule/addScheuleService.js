import { getUserToken } from "../authenticate/authenticate";

export async function addSchedule(roomId, filmId, date) {
  const uri = "http://localhost:8083/cinema/addSchedule";
  const body = JSON.stringify({
    roomId: roomId,
    filmId: filmId,
    date: date,
  });
  const token = await getUserToken();
  const response = await fetch(uri, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`,
    },
    body: body,
  });
  const responseData = await response.json();
    if (responseData.code == 1000) {
  if (response.status == 200) {
      return responseData.result;
    }
  } else if(response.status == 400) {
    console.log(responseData.message);
    return null;
  }
}
