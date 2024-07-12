import { getAllMovies } from "../movie/getAllFilm";
import { getFilmById } from "./getFilmById";


export async function fetchingSeclectionFilm(){
    const films = await getAllMovies();
   
    const filmSelection = document.querySelector("#film-selection");
    films.forEach(film => {
        const option = document.createElement("option");
        option.value = film.id ;
        option.textContent = truncateText(film.title,30) ;
        filmSelection.appendChild(option);
        
       
    });
    filmSelection.addEventListener("change", async event=>{
        const filmSchedule = document.querySelector("#film-schedule");
        const room = sessionStorage.getItem("roomId");
        const film = await getFilmById(filmSelection.value);
        while (filmSchedule.firstChild) {
            filmSchedule.removeChild(filmSchedule.firstChild);
        }
        const title = document.createElement("p");
        title.textContent = truncateText(film.title,15);
        const duration = document.createElement("p");
        duration.textContent = film.duration + " phút";
        filmSchedule.appendChild(title);
        filmSchedule.appendChild(duration);
        filmSchedule.setAttribute("filmId",film.id);
        filmSchedule.setAttribute("roomId",room);
        
    })
    
}
export function truncateText(text, maxLength) {
    if (text.length > maxLength) {
        return text.substring(0, maxLength) + '...';
    }
    return text;
}
fetchingSeclectionFilm();