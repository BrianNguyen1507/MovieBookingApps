import { Movie } from "../../models/movie.js";
import { fetchCategories } from "./getCategoryList.js";
import {
  formatToDmy,
  handleFileSelect,
  stringToBase64,
} from "../../util/converter.js";
import { addMovie } from "./addFilm.js";
import { screenSizeWith } from "../../constant/screenSize.js";
import { getAllMovies } from "./getAllFilm.js";
$(document).on("click", "#btn-add-movie", async function (event) {
  try {
    const showForm = async () => {
      $(document).ready(function () {
        fetchCategories();
      });
      return await Swal.fire({
        width: screenSizeWith(),
        title: "Thêm Phim Mới",
        html: `
<div class="container">
  <div class="row">
    <!-- First Column -->
    <div class="col-sm-12 col-md-6">
      <div class="bg-light rounded h-100 p-4">
        <form id="AddMovieForm" class="row g-4">
          <div class="col-md-6">
            <label for="movieTitleInput" class="form-label">Tiêu đề</label>
            <input type="text" class="form-control" id="movieTitleInput">
          </div>
          <div class="col-md-6">
            <label for="movieDurationInput" class="form-label">Thời lượng (phút)</label>
            <input type="number" class="form-control" id="movieDurationInput">
          </div>
          <div class="col-md-6">
            <label for="releaseDateInput" class="form-label">Ngày phát hành</label>
            <input type="date" class="form-control" id="releaseDateInput">
          </div>
          <div class="col-md-6">
            <label for="directorInput" class="form-label">Đạo diễn</label>
            <input type="text" class="form-control" id="directorInput">
          </div>
          <div class="col-md-6">
            <label for="actorInput" class="form-label">Diễn viên</label>
            <input type="text" class="form-control" id="actorInput">
          </div>
          <div class="col-md-6">
            <label for="countryInput" class="form-label">Quốc gia</label>
            <input type="text" class="form-control" id="countryInput">
          </div>
            <div class="col-md-12">
            <label for="movieDescriptionInput" class="form-label">Mô tả</label>
            <textarea class="form-control" id="movieDescriptionInput"></textarea>
          </div>
        </form>
      </div>
    </div>

    <div class="col-sm-12 col-md-6">
      <div class="bg-light rounded h-100 p-4">
        <form id="AddMovieForm" class="row g-4">
          <div class="col-md-6">
            <label for="languageInput" class="form-label">Ngôn ngữ</label>
            <input type="text" class="form-control" id="languageInput">
          </div>
          <div class="col-md-6">
            <label for="basePriceInput" class="form-label">Giá cơ bản</label>
            <input type="number" class="form-control" id="basePriceInput">
          </div>
           <div class="col-md-12 align-items-center">
            <label for="classfityInput" class="form-label">Phân loại: </label>
            <select name="classfityInput" class="form-floating" id="classfityInput">
              <option value="123">123</option>
              <option value="123">123</option>
            </select>
          </div>
          <div class="col-md-12 align-items-center">
            <label for="categoriesInput" class="form-label">Thể loại</label>
            <div class="form-floating" id="floatingCategory"></div>
          </div>
          <div class="col-md-12">
            <label for="trailerInput" class="form-label">Trailer URL</label>
            <input type="text" class="form-control" placeholder="Example:https://www.youtube.com/watch?v=123456" id="trailerInput">
          </div>
          <div class="col-md-12">
            <label for="posterInput" class="form-label">Poster</label>
            <input type="file" class="form-control" id="posterInput">
          </div>
        
          <div id="errorMessageText" style="color: red;"></div>
        </form>
      </div>
    </div>
  </div>
</div>

        `,
        didOpen: () => {
          $("#posterInput").on("change", handleFileSelect);
        },
        showCancelButton: true,
        confirmButtonText: "Thêm Phim",
        showLoaderOnConfirm: true,
        preConfirm: () => {
          const movieTitleInput = $("#movieTitleInput").val().trim();
          const movieDurationInput = parseInt(
            $("#movieDurationInput").val(),
            10
          );
          const movieDescriptionInput = $("#movieDescriptionInput")
            .val()
            .trim();
          const releaseDateInput = $("#releaseDateInput").val();
          const directorInput = $("#directorInput").val().trim();
          const actorInput = $("#actorInput").val().trim();
          const posterBase64 = $("#posterInput").data("base64") || "";
          const trailerInput = $("#trailerInput").val().trim();
          const countryInput = $("#countryInput").val().trim();
          const languageInput = $("#languageInput").val().trim();
          const basePriceInput = parseFloat($("#basePriceInput").val());
          const classfityInput = $("#classfityInput").val();
          const selectedOptions = $("#floatingCategory")
            .find("input:checked")
            .map(function () {
              return {
                id: parseInt($(this).val()),
                name: $(this).next("label").text(),
              };
            })
            .get();
          const categoriesInput = selectedOptions;

          if (
            !classfityInput ||
            !movieTitleInput ||
            isNaN(movieDurationInput) ||
            !movieDescriptionInput ||
            !releaseDateInput ||
            !directorInput ||
            !actorInput ||
            !posterBase64 ||
            !trailerInput ||
            !countryInput ||
            !languageInput ||
            isNaN(basePriceInput) ||
            !categoriesInput
          ) {
            Swal.showValidationMessage(
              "All fields are required and must be valid."
            );
            return false;
          }

          const now = new Date();
          const oneDayFromNow = new Date(now.getTime() + 24 * 60 * 60 * 1000);
          const releaseDate = new Date(releaseDateInput);

          if (releaseDate <= oneDayFromNow) {
            Swal.showValidationMessage(
              "Release date must be at least one day in the future."
            );
            return false;
          }

          return {
            movieTitleInput,
            movieDurationInput,
            movieDescriptionInput,
            releaseDateInput,
            directorInput,
            actorInput,
            posterBase64,
            trailerInput,
            countryInput,
            languageInput,
            basePriceInput,
            categoriesInput,
            classfityInput,
          };
        },
      });
    };

    const { isConfirmed, value } = await showForm();
    console.log(value.releaseDateInput);
    if (isConfirmed) {
      const movie = new Movie(
        value.movieTitleInput,
        value.movieDurationInput,
        stringToBase64(value.movieDescriptionInput),
        value.releaseDateInput,
        value.directorInput,
        value.actorInput,
        value.posterBase64,
        value.trailerInput,
        value.countryInput,
        value.languageInput,
        value.basePriceInput,
        value.categoriesInput,
        value.classfityInput
      );
      const result = await addMovie(movie);

      if (result === true) {
        Swal.fire({
          title: "Success!",
          text: "New movie has been added.",
          icon: "success",
          confirmButtonText: "OK",
        }).then(() => {
          getAllMovies();
        });
      } else {
        Swal.fire({
          title: "Error!",
          text: result,
          icon: "error",
          confirmButtonText: "OK",
        }).then(async () => {
          await showForm();
        });
      }
    }
  } catch (error) {
    console.error(error);
  }
});
