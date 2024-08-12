import { getUserToken } from "../authenticate/authenticate.js";

const url = "http://localhost:8083/cinema/getAllFood";

export async function getAllFood() {
  try {
    const token = await getUserToken();
    const response = await fetch(url, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
    });

    const foods = await response.json();
    
    if (foods.code !== 1000) {
      return;
    }
    return foods.result;
  } catch (error) {
    console.error("Error fetching and displaying categories:", error);
  }
}
