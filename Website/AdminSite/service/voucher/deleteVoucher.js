import { getUserToken } from "../authenticate/authenticate.js";

const apiUrl = "http://localhost:8083/cinema/deleteVoucher?id=";
const token = await getUserToken();
export async function deleteVoucher(voucherId) {
  try {
    const response = await fetch(`${apiUrl}${voucherId}`, {
      method: "DELETE",
      headers: {
        Authorization: `Bearer ${token}`,
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
