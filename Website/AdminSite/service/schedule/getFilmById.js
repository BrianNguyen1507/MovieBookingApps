import { getUserToken } from "../authenticate/authenticate";

export async function getFilmById(id) {
    const url = "http://localhost:8083/cinema/getFilmById?id=";
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
      if (movies.code == 1000) {
        return movies.result;
      }
      return null;
    } catch (error) {
      console.error("Error fetching:", error);
    }
  }