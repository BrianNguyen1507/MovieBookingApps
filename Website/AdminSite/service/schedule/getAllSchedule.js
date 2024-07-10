import { getUserToken } from "../authenticate/authenticate.js";

export async function getAllScheduleByRoomAndDate(roomId, dateStart) {
  const url = `http://localhost:8083/cinema/getAllScheduleByRoomAndDate?roomId=${roomId}&dateStart=${dateStart}`;
  console.log(url);
  try {
    const token = await getUserToken();
    const response = await fetch(url, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
    });
    if (response.status == 200) {
      const responseData =  await response.json();
      if (responseData.code == 1000) {
        return responseData.result;
      }
    }
    return null;
  } catch (error) {
    console.log(error);
  }
}
