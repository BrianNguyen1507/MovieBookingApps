import { displayFilm } from "./displayFilm.js";
$('#search-movie').on('input', function() {
    timeout = setTimeout( async function() {
      let keyword = $('#search-movie').val();
      const movies = await searchMovie(keyword);
      displayFilm(movies);
    }, 1500);
  }); 

export async function searchMovie(keyword) {
  const url = "http://103.200.20.167:8083/cinema/searchFilm?keyword=";
  try {
    
    const response = await fetch(url + keyword, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
      },
    });

    const movies = await response.json();
    if (movies.code == 1000) {
      return movies.result;
    }
  } catch (error) {
    console.error("Error fetching:", error);
  }
}
