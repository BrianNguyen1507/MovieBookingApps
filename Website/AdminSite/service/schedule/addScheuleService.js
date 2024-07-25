import { getUserToken } from "../authenticate/authenticate.js";

export async function addSchedule(roomId, filmId, date) {
  const uri = "http://103.200.20.167:8083/cinema/addSchedule";
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
  return responseData;
}
