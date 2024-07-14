import { getAllFilm } from "./getAllFilm.js";
import { getFilmById } from "./getFilmById.js";

export async function fetchingSeclectionFilm() {
  const films = await getAllFilm();

  const filmSelection = document.querySelector("#film-selection");
  films.forEach((film) => {
    const option = document.createElement("option");
    option.value = film.id;
    option.textContent = truncateText(film.title, 30);
    filmSelection.appendChild(option);
  });
  filmSelection.addEventListener("change", async (event) => {
    const filmSchedule = document.querySelector("#film-dragtable");
    const room = sessionStorage.getItem("roomId");
    const film = await getFilmById(filmSelection.value);
    while (filmSchedule.firstChild) {
      filmSchedule.removeChild(filmSchedule.firstChild);
    }
    const poster = document.createElement("img");
    poster.src = `data:image/jpeg;base64, ${film.poster}`;
    poster.height = 150;
    poster.width = 100;
    poster.setAttribute("filmId", film.id);
    poster.setAttribute("roomId", room);
    
    const title = document.createElement("p");
    title.textContent = truncateText(film.title, 15);
    title.style.textAlign = "center";
    title.setAttribute("filmId", film.id);
    title.setAttribute("roomId", room);

    const duration = document.createElement("p");
    duration.textContent = film.duration + " phút";
    duration.style.textAlign = "center";
    duration.setAttribute("filmId", film.id);
    duration.setAttribute("roomId", room);
    filmSchedule.appendChild(poster);
    filmSchedule.appendChild(title);
    filmSchedule.appendChild(duration);

    filmSchedule.setAttribute("filmId", film.id);
    filmSchedule.setAttribute("roomId", room);
  });
}
export function truncateText(text, maxLength) {
  if (text.length > maxLength) {
    return text.substring(0, maxLength) + "...";
  }
  return text;
}
fetchingSeclectionFilm();
