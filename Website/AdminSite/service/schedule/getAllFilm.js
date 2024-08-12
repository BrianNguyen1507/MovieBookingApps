import { getUserToken } from "../authenticate/authenticate.js";

export async function getAllFilm() {
  const url = "http://localhost:8083/cinema/getAllFilm";
  try {
    const token = await getUserToken();
    const response = await fetch(url, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
    });

    const movies = await response.json();
    if (movies.code == 1000) {
      return movies.result;
    }
  } catch (error) {
    console.error("Error fetching and displaying movies:", error);
  }
}

