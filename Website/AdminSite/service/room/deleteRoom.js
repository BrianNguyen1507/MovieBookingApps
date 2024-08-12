import { getUserToken } from "../authenticate/authenticate";

export async function deleteRoom(id) {
  const url = "http://localhost:8083/cinema/deleteRoom?id=";
  try {
    const token = await getUserToken();
    const response = await fetch(url + id, {
      method: "DELETE",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
    });

    const room = await response.json();
    if (room.code !== 1000) {
      return;
    }
    return room;
  } catch (error) {
    console.error("Error fetching and displaying theaters:", error);
  }
}
