import { Movie } from "../../models/movie.js";
import { activeFilm } from "./activeFilm.js";
import { getAllMovies } from "./getAllFilm.js";

export async function displayFilm(movies){
    const movieList = document.getElementById("movie-list");
    movieList.innerHTML = "";
    movies.forEach((movieData) => {
      const movie = new Movie(
        movieData.id,
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
        movieData.categories,
        movieData.classify,
        movieData.active,
      );

      const movieItem = document.createElement("div");
      movieItem.classList.add("movie-item", "col-12", "col-md-3");
  
      const movieIdFlag = document.createElement("div");
      movieIdFlag.classList.add("movie-id-flag");
      movieIdFlag.textContent = "#" + movie.id;
      movieItem.appendChild(movieIdFlag);
  
      const movieclassify = document.createElement("div");
      movieclassify.classList.add("movie-id-classify");
      movieclassify.textContent = movie.active == 0 ? "Active" : "Inactive";
      movieItem.appendChild(movieclassify);
  
      const moviePoster = document.createElement("img");
      moviePoster.src = `data:image/png;base64,${movie.poster}`;
      moviePoster.classList.add("img-fluid");
      moviePoster.alt = `${movie.title} Poster`;
      movieItem.appendChild(moviePoster);
  
      const movieTitle = document.createElement("h4");
      movieTitle.classList.add("text-truncate", "d-inline-block");
      movieTitle.style.maxWidth = "100%"; // Allow the width to be 100% within its container
      movieTitle.textContent = movie.title;
      movieItem.appendChild(movieTitle);
  
      const movieDateRelease = document.createElement("div");
      movieDateRelease.classList.add("movie-details");
      movieDateRelease.textContent = `Ngày phát hành: ${movie.releaseDate}`;
      movieItem.appendChild(movieDateRelease);
  
      const moreDetailsBtn = document.createElement("button");
      moreDetailsBtn.classList.add("btn", "btn-primary", "more-details-btn", "mr-2");
      moreDetailsBtn.textContent = "Chi tiết";
      moreDetailsBtn.addEventListener("click", () => {
          window.location.href = `movieDetail.html?id=${movie.id}`;
      });
  
      const activeBtn = document.createElement("button");
      activeBtn.classList.add("btn", "btn-secondary", "more-details-btn");
      activeBtn.textContent = movie.active == 0 ? "Inactive" : "Active";
      activeBtn.addEventListener("click", () => {
          activeFilm(movie.id);
      });
  
      const btnContainer = document.createElement("div");
      btnContainer.classList.add("mt-3"); // Margin top for button container
      btnContainer.appendChild(moreDetailsBtn);
      btnContainer.appendChild(activeBtn);
      movieItem.appendChild(btnContainer);
  
      movieList.appendChild(movieItem);
    });
}
displayFilm(await getAllMovies());