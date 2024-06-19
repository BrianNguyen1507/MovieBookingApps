
import { logoutService } from "../service/authenticate/logoutService";

$(document).on("click", "#logoutButton", async function (event) {
  try {
    const confirmation = await Swal.fire({
      title: "Are you sure?",
      text: "Do you really want to log out?",
      icon: "warning",
      showCancelButton: true,
      confirmButtonText: "Yes, log out",
      cancelButtonText: "No, cancel",
    });

    if (confirmation.isConfirmed) {
      event.preventDefault();
      logoutService();
      window.location.href = "./signin.html";
    }
  } catch (error) {
    console.error(error);
  }
});

async function logout() {
  const url = "http://localhost:8083/cinema/logout";
  try {
    const token = await getUserToken();
    const response = await $.ajax({
      url: url,
      method: "POST",
      contentType: "application/json",
      data: JSON.stringify(token),
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
