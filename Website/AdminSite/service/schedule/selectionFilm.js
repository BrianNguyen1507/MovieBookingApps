import { getAllFilm } from "./getAllFilm.js";


export async function fetchingSeclectionFilm() {
  const films = await getAllFilm();

  const movies = document.querySelector("#list-movie");
  films.forEach((film) => {
    const divPadding = document.createElement("div");
    divPadding.style.padding = "10px";
    
    divPadding.classList.add("col-12", "col-md-2", "d-flex", "justify-content-center","movie-item");
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
    title.style.width ="100px";
    title.style.textAlign = "center";
    title.setAttribute("filmId", film.id);

    const duration = document.createElement("p");
    duration.textContent = film.duration + " phút";
    duration.style.textAlign = "center";
    duration.setAttribute("filmId", film.id);

    div.appendChild(poster);
    div.appendChild(title);
    div.appendChild(duration);
    div.setAttribute("filmId", film.id);

    divPadding.appendChild(div);
    movies.appendChild(divPadding);
  });
}

export function truncateText(text, maxLength) {
  if (text.length > maxLength) {
    return text.substring(0, maxLength) + "...";
  }
  return text;
}

fetchingSeclectionFilm();
