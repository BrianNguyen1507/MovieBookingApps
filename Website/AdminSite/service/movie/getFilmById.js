import {
  base64ToImage,
  base64ToString,
  extractYouTubeVideoId,
} from "../../util/converter.js";
import { populateSelectWithOptions } from "../../util/loadclassity.js";
import { getUserToken } from "../authenticate/authenticate.js";
import { fetchCategories } from "./getCategoryList.js";
const url = "http://103.200.20.167:8083/cinema/getFilmById?id=";

export async function getMovieById(id) {
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
    updateMovieInputs(movies.result);
    fetchCategories(movies.result.categories);
    populateSelectWithOptions(movies.result.classify);
  } catch (error) {
    console.error("Error fetching:", error);
  }
}

function updateMovieInputs(movieData) {
  const movieTrailer = document.getElementById("movieTrailer");
  const moviePoster = document.getElementById("moviePoster");
  const movieTitleInput = document.getElementById("movieTitleInput");
  const movieDurationInput = document.getElementById("movieDurationInput");
  const releaseDateInput = document.getElementById("releaseDateInput");
  const directorInput = document.getElementById("directorInput");
  const actorInput = document.getElementById("actorInput");
  const countryInput = document.getElementById("countryInput");
  const languageInput = document.getElementById("languageInput");
  const trailerInput = document.getElementById("trailerInput");
  const basePriceInput = document.getElementById("basePriceInput");

  const movieDescriptionInput = document.getElementById(
    "movieDescriptionInput"
  );
  const posterInput = document.getElementById("posterinput");

  movieTitleInput.value = movieData.title;
  movieDurationInput.value = movieData.duration;
  releaseDateInput.value = movieData.releaseDate;
  directorInput.value = movieData.director;
  actorInput.value = movieData.actor;
  countryInput.value = movieData.country;
  languageInput.value = movieData.language;
  trailerInput.value = movieData.trailer;
  basePriceInput.value = movieData.basePrice;
  movieDescriptionInput.value = base64ToString(movieData.description);
  posterInput.value = movieData.poster;
  if (movieData.trailer) {
    const videoId = extractYouTubeVideoId(movieData.trailer);
    if (videoId) {
      const embedUrl = `https://www.youtube.com/embed/${videoId}`;

      movieTrailer.src = embedUrl;
    } else {
      console.error("Invalid YouTube URL.");
    }
  } else {
    movieTrailer.src = "";
  }

  if (movieData.poster) {
    moviePoster.src = base64ToImage(movieData.poster);
  } else {
    moviePoster.src = "";
  }
}
