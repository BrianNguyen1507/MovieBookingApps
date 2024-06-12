import { getUserToken } from "../authenticate/authenticate.js";
import { displayErrorMessage } from "../../util/common.js";
import { Theater } from "../../models/theater.js";

const apiUrl = "http://localhost:8083/cinema/addMovieTheater";

export async function addTheater(theaterName, theaterAddress) {
  try {
    const tokenUser = await getUserToken();
    const theater = new Theater(0,theaterName, theaterAddress); 
    const response = await $.ajax({
      url: apiUrl,
      method: "POST",
      contentType: "application/json",
      headers: {
        Authorization: `Bearer ${tokenUser}`,
      },
      data: JSON.stringify(theater),
    });

    if (response.code !== 1000) {
      return response.message;
    }

    return true;
  } catch (error) {
    console.error("Exception:", error);
    return error.responseJSON ? error.responseJSON.message : error.message;
  }
}

$("#AddTheaterForm").submit(async function (event) {
  event.preventDefault();
  const nameInput = $("#nametheaterInput").val();
  const addressInput = $("#addresstheaterInput").val();
  const result = await addTheater(nameInput, addressInput);

  if (result === true) {
    Swal.fire({
      title: "Success!",
      text: `New theater ${nameInput} has been added.`,
      icon: "success",
      confirmButtonText: "OK",
    }).then(() => {
      setTimeout(function () {
        window.location.reload();
      }, 300);
    });
  } else {
    displayErrorMessage(result);
  }
});
