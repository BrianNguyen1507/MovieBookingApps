import { getAllFilm } from "./getAllFilm.js";

async function loadMovies() {
  const films = await getAllFilm();
  const movies = document.querySelector("#list-movie");

  films.forEach((film) => {
    const divPadding = document.createElement("div");
    divPadding.style.padding = "10px";
    divPadding.classList.add(
      "col-12",
      "col-md-2",
      "d-flex",
      "justify-content-center",
      "movie-item"
    );
    divPadding.setAttribute("filmId", film.id);
    divPadding.setAttribute("draggable", true);

    const div = document.createElement("div");
    div.id = "film-dragtable";
    div.setAttribute("draggable", true);

    const poster = document.createElement("img");
    poster.src = `data:image/jpeg;base64,${film.poster}`;
    poster.height = 150;
    poster.width = 100;
    poster.setAttribute("filmId", film.id);

    const title = document.createElement("p");
    title.textContent = film.title;

    title.style.textAlign = "center";
    title.setAttribute("filmId", film.id);

    const duration = document.createElement("p");
    duration.textContent = `${film.duration} phút`;
    duration.style.textAlign = "center";
    duration.setAttribute("filmId", film.id);

    const releaseDate = document.createElement("p");
    releaseDate.textContent = `${film.releaseDate}`;
    releaseDate.style.textAlign = "center";
    releaseDate.setAttribute("filmId", film.id);


    div.appendChild(poster);
    div.appendChild(title);
    div.appendChild(duration);
    div.appendChild(releaseDate);
    div.setAttribute("filmId", film.id);

    divPadding.appendChild(div);
    movies.appendChild(divPadding);
  });
}

async function fetchingSelectionFilm() {
  await loadMovies();
  const observer = new IntersectionObserver({
    root: document.querySelector(".infinite-row-container"),
    rootMargin: "0px",
    threshold: 1.0,
  });

  observer.observe(document.querySelector(".movie-item:last-child"));
}

fetchingSelectionFilm();

export function truncateText(text, maxLength) {
  if (text.length > maxLength) {
    return text.substring(0, maxLength) + "...";
  }
  return text;
}
