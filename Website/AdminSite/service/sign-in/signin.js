const apiurl = "http://103.200.20.167:8083/cinema/login";
import { displayErrorMessage } from "../../util/common.js";
import { getMessageWithCode } from "../../util/exception/exception.js";
async function signin(email, password) {
  try {
    const signInData = JSON.stringify({ email, password });
    const response = await $.ajax({
      url: apiurl,
      method: "POST",
      contentType: "application/json",
      data: signInData,
    }).fail((xhr, status, error) => {
      console.error("Error:", error);
      Swal.fire({
        title: "Error",
        text: getMessageWithCode(xhr.responseJSON.code) || "An unexpected error occurred",
        icon: "error",
        confirmButtonText: "OK",
      });
      throw new Error(xhr.responseJSON.message);
    });

    if (response.code !== 1000 && response.code !== 1001) {
      return getMessageWithCode(response.code);
    }

    const { token, authenticated, role, name } = response.result;
    sessionStorage.setItem("token", token);
    sessionStorage.setItem("authenticated", authenticated);
    sessionStorage.setItem("role", role);
    sessionStorage.setItem("name", name);
    return true;
  } catch (error) {
    console.error("Exception:", error);
  }
}

$("#signInForm").submit(async function (event) {
  event.preventDefault();
  const email = $("#floatingInput").val();
  const password = $("#floatingPassword").val();
  const result = await signin(email, password);

  if (result === true) {
    const role = sessionStorage.getItem("role");
    if (role === "ADMIN") {
      Swal.fire({
        title: "Đăng nhập thành công!",
        icon: "success",
        confirmButtonText: "OK",
      }).then(() => {
        window.location.href = "./";
      });
      setTimeout(() => {
        window.location.href = "./";
      }, 3000);
      $("#floatingInput").val("");
      $("#floatingPassword").val("");
    } else {
      displayErrorMessage("Invalid account");
    }
  } else {
    displayErrorMessage(result);
  }
});
