import { getUserToken } from "../authenticate/authenticate.js";

const url = "http://103.200.20.167:8083/cinema/getAllFilm";

export async function getAllMovies() {
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

