import { getUserToken } from "../authenticate/authenticate.js";

const url = "http://103.200.20.167:8083/cinema/getFoodById?id=";
export async function getFoodById(id) {
  try {
    const token = await getUserToken();
    const response = await fetch(url +id, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
    });

    const food = await response.json();
    if (food.code !== 1000) {
      return;
    }
    return food.result;
  } catch (error) {
    console.error("Error fetching and displaying theaters:", error);
  }
}

