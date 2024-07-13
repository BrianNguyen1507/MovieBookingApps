import { getUserToken } from "../authenticate/authenticate";

export async function swapSchedule(id, idSwap, date) {
  const uri = `http://localhost:8083/cinema/swapSchedule?id=${id}&idSwap=${idSwap}&date=${date}`;
  const token = await getUserToken();
  const response = await fetch(uri, {
    method: "PUT",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`,
    },
  });
  const responseData = await response.json();

  if (response.status == 200) {
    if (responseData.code == 1000) {
      return responseData.result;
    }
  } else if (response.status == 400) {
    console.log(responseData.message);
    return null;
  }
}
