import { getUserToken } from "../authenticate/authenticate.js";
const tokenUser = await getUserToken();
const apiUrl = "http://localhost:8083/cinema/deleteMovieTheater?id=";

export async function deleteTheaeterById(theaterId) {
  try {
    const response = await fetch(`${apiUrl}${theaterId}`, {
      method: "DELETE",
      headers: {
        Authorization: `Bearer ${tokenUser}`,
      },
    });

    if (!response.ok) {
      const data = await response.json();
      throw new Error(data.message);
    }

    return true;
  } catch (error) {
    console.error("Error deleting:", error);
    throw error;
  }
}
