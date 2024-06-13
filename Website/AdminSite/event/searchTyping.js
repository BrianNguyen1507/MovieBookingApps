import { searchMovie } from "../service/movie/searchMovie.js";
import { getAllMovies } from "../service/movie/getAllFilm.js";
let typingTimer;
const doneTypingInterval = 2000;

function sendTypingInput() {
  const inputValue = document.querySelector("#search-movie").value.trim();
  console.log(inputValue);
  if (!inputValue || inputValue.trim === null) {
    getAllMovies();
    return;
  } else {
    searchMovie(inputValue);
  }
}

function inputChanged() {
  clearTimeout(typingTimer);
  typingTimer = setTimeout(sendTypingInput, doneTypingInterval);
}

document.querySelector("#search-movie").addEventListener("input", inputChanged);
