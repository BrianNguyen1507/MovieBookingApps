import {
  base64ToImage,
  base64ToString,
  formatToYmd,
} from "../../util/converter.js";
import { getUserToken } from "../authenticate/authenticate.js";

const url = "http://localhost:8083/cinema/getFilmById?id=";

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
  } catch (error) {
    console.error("Error fetching:", error);
  }
}

function updateMovieInputs(movieData) {
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
  const categorySelect = document.getElementById("floatingCategory");
  movieTitleInput.value = movieData.title;
  movieDurationInput.value = movieData.duration;
  releaseDateInput.value = formatToYmd(movieData.releaseDate);
  directorInput.value = movieData.director;
  actorInput.value = movieData.actor;
  countryInput.value = movieData.country;
  languageInput.value = movieData.language;
  trailerInput.value = movieData.trailer;
  basePriceInput.value = movieData.basePrice;
  movieDescriptionInput.value = base64ToString(movieData.description);
  if (movieData.poster) {
    moviePoster.src = base64ToImage(movieData.poster);
  } else {
    moviePoster.src = "";
  }
  if (movieData.categories) {
    categorySelect.innerHTML = "";
    movieData.categories.forEach((category) => {
      const option = document.createElement("option");
      option.value = category.id;
      option.text = category.name;
      categorySelect.appendChild(option);
    });
  }
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
}
function extractYouTubeVideoId(url) {
  const regExp = /[?&]v=([^&]+)/;

  const match = url.match(regExp);

  return match && match[1];
}
