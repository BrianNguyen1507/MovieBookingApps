import { getUserToken } from "../authenticate/authenticate.js";
import { Movie } from "../../models/movie.js";
import { getMovieById } from "./getFilmById.js";

const url = "http://localhost:8083/cinema/getAllFilm?step=10";

async function getAllMovies() {
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
    if (movies.code !== 1000) {
      return;
    }

    const movieList = document.getElementById("movie-list");
    movieList.innerHTML = "";

    movies.result.forEach((movieData) => {
      const movie = new Movie(
        movieData.title,
        movieData.duration,
        movieData.description,
        movieData.releaseDate,
        movieData.director,
        movieData.actor,
        movieData.poster,
        movieData.trailer,
        movieData.country,
        movieData.language,
        movieData.basePrice,
        movieData.categories
      );

      const movieItem = document.createElement("div");
      movieItem.classList.add("movie-item");

      const movieIdFlag = document.createElement("div");
      movieIdFlag.classList.add("movie-id-flag");
      movieIdFlag.textContent = "#" + movieData.id;
      movieItem.appendChild(movieIdFlag);

      const moviePoster = document.createElement("img");
      moviePoster.src = `data:image/png;base64,${movie.poster}`;
      moviePoster.alt = `${movie.title} Poster`;
      movieItem.appendChild(moviePoster);

      const movieTitle = document.createElement("h5");
      movieTitle.textContent = movie.title;
      movieItem.appendChild(movieTitle);

      const movieDateRelease = document.createElement("div");
      movieDateRelease.classList.add("movie-details");
      movieDateRelease.textContent = `Release Date: ${movie.releaseDate}`;
      movieItem.appendChild(movieDateRelease);

      const moreDetailsBtn = document.createElement("button");
      moreDetailsBtn.classList.add("more-details-btn");
      moreDetailsBtn.textContent = "Chi tiết";
      moreDetailsBtn.addEventListener("click", () => {
        window.location.href = `movieDetail.html?id=${movieData.id}`;
      });
      movieItem.appendChild(moreDetailsBtn);

      movieList.appendChild(movieItem);
    });
  } catch (error) {
    console.error("Error fetching and displaying movies:", error);
  }
}

getAllMovies();
