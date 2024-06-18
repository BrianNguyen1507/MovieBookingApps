import { classify } from "../../models/classify";
import { Movie } from "../../models/movie";
import { stringToBase64 } from "../../util/converter";
import { deleteMovie } from "./deleteFilm";
import { getMovieById } from "./getFilmById";
import { updateMovie } from "./updateFilm";

function getMovieFromForm() {
  const movieTitleInput = $("#movieTitleInput").val().trim();
  const movieDurationInput = parseInt($("#movieDurationInput").val(), 10);
  const movieDescriptionInput = $("#movieDescriptionInput").val().trim();
  const releaseDateInput = $("#releaseDateInput").val();
  const directorInput = $("#directorInput").val().trim();
  const actorInput = $("#actorInput").val().trim();
  const posterInput = $("#posterinput").val().trim();
  const trailerInput = $("#trailerInput").val().trim();
  const countryInput = $("#countryInput").val().trim();
  const languageInput = $("#languageInput").val().trim();
  const basePriceInput = parseFloat($("#basePriceInput").val());
  const classifyInputValue = $("#classifyInput").val();
  const selectedOptions = $("#floatingCategory")
    .find("input:checked")
    .map(function () {
      return {
        id: parseInt($(this).val()),
        name: $(this).next("label").text(),
      };
    })
    .get();

  return new Movie(
    movieTitleInput,
    movieDurationInput,
    stringToBase64(movieDescriptionInput),
    releaseDateInput,
    directorInput,
    actorInput,
    posterInput,
    trailerInput,
    countryInput,
    languageInput,
    basePriceInput,
    selectedOptions,
    classifyInputValue
  );
}

document.getElementById("btn-edit").addEventListener("click", function () {
  const id = this.getAttribute("data-id");
  const movie = getMovieFromForm();

  Swal.fire({
    title: "Are you sure?",
    text: "Do you want to update this movie?",
    icon: "warning",
    showCancelButton: true,
    confirmButtonText: "Yes, update it!",
    cancelButtonText: "No, cancel!",
    reverseButtons: true,
  }).then((result) => {
    if (result.isConfirmed) {
      updateMovie(id, movie);
      getMovieById(id);
      window.location.reload();
    } else if (result.dismiss === Swal.DismissReason.cancel) {
      Swal.fire({
        title: "Cancelled",
        text: "Update operation has been cancelled.",
        icon: "info",
      });
    }
  });
});

document.getElementById("btn-del").addEventListener("click", function () {
  const id = this.getAttribute("data-id");

  Swal.fire({
    title: "Are you sure?",
    text: "Do you want to hide this movie?",
    icon: "warning",
    showCancelButton: true,
    confirmButtonText: "Yes, hide it!",
    cancelButtonText: "No, cancel!",
    reverseButtons: true,
  }).then((result) => {
    if (result.isConfirmed) {
      deleteMovie(id);
      window.location.href = "./movieManagement.html";
    } else if (result.dismiss === Swal.DismissReason.cancel) {
      Swal.fire({
        title: "Cancelled",
        text: "Hide operation has been cancelled.",
        icon: "info",
      });
    }
  });
});
