import { getUserToken } from "../authenticate/authenticate.js";

export async function getAllRoomByTheater(id) {
    
const url = "http://103.200.20.167:8083/cinema/getAllRoomByTheaterId?theaterId=";
  try {
    const token = await getUserToken();
    const response = await fetch(url + id, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
    });

    const roomData = await response.json();
    if (response.status == 200) {
      if (roomData.code == 1000) {
        return roomData.result;
      }
    }
    return null;
  } catch (error) {
    console.error("Error fetching and displaying rooms:", error);
  }
}
