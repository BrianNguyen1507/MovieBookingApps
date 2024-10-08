import { getUserToken } from "../authenticate/authenticate.js";

export async function swapSchedule(id, idSwap, date) {
  const uri = `http://103.200.20.167:8083/cinema/swapSchedule?id=${id}&idSwap=${idSwap}&date=${date}`;
  const token = await getUserToken();
  const response = await fetch(uri, {
    method: "PUT",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`,
    },
  });
  const responseData = await response.json();
  return responseData;
}
