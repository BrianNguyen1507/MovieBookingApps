import { Movie } from "../../models/movie.js";
import { stringToBase64 } from "../../util/converter.js";
import { deleteMovie } from "./deleteFilm.js";
import { getMovieById } from "./getFilmById.js";
import { updateMovie } from "./updateFilm.js";

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
//edit movie button
document.getElementById("btn-edit").addEventListener("click", function () {
  const id = this.getAttribute("data-id");
  const movie = getMovieFromForm();

  Swal.fire({
    title: "Xác nhận?",
    text: "Bạn có chắc muốn sửa thông tin phim",
    icon: "warning",
    showCancelButton: true,
    confirmButtonText: "Có",
    cancelButtonText: "Hủy",
    reverseButtons: true,
  }).then(async (result) => {
    if (result.isConfirmed) {
      const response = await updateMovie(id, movie);
      console.log(response);
      if (response == true) {
        Swal.fire({
          title: "Thành công!",
          text: "Sửa phim thành công",
          icon: "success",
          confirmButtonText: "OK",
        }).then(async () => {
          getMovieById(id);
          return;
        });
      }
      Swal.fire({
        title: "Thất bại!",
        text: response,
        icon: "error",
        confirmButtonText: "OK",
      }).then(async () => {
        getMovieFromForm();
      });
    }
  });
});
//soft delete movie button
document.getElementById("btn-del").addEventListener("click", function () {
  const id = this.getAttribute("data-id");
  const movie = getMovieFromForm();

  Swal.fire({
    title: "Xác nhận?",
    text: "Bạn có muốn xóa phim " + movie.title,
    icon: "warning",
    showCancelButton: true,
    confirmButtonText: "Có",
    cancelButtonText: "Hủy",
    reverseButtons: true,
  }).then(async (result) => {
    if (result.isConfirmed) {
      const response = await deleteMovie(id);
      if (response == true) {
        await Swal.fire(
          {
            title: "Thành công!",
            text: "Xóa phim thành công",
            icon: "error",
            confirmButtonText: "OK",
          }
        ).then(() => {
          window.location.href = "./movieManagement.html";
          return;
        });
      }
      Swal.fire({
        title: "Thất bại!",
        text: response,
        icon: "error",
        confirmButtonText: "OK",
      });
    }
  });
});
