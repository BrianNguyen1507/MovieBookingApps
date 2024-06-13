import { getUserToken } from "../authenticate/authenticate";
const url = "http://localhost:8083/cinema/getFilmById?id=";
export async function searchMovie(id) {
  try {
    const token = await getUserToken();
    const response = await fetch(url + id, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
    });

    const movies = await response.json();
    if (movies.code !== 1000) {
      throw new Error(`Failed to get movie with ${id}`);
    }
    console.log(movies);
  } catch (error) {
    console.error("Error fetching:", error);
  }
}
