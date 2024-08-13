import { getMessageWithCode } from "../../util/exception/exception.js";
import { getUserToken } from "../authenticate/authenticate.js";
const url = "http://103.200.20.167:8083/cinema/activeFilm?id=";

export async function activeFilm(id) {
  try {
    const token = await getUserToken();
    const response = await fetch(url + id, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
    });
    const responseData = await response.json();
    if (response.status == 200) {
      Swal.fire({
        title: "Thành công!",
        text: "Kich hoạt phim thành công",
        icon: "success",
        confirmButtonText: "OK",
      }).then(() => {
       location.reload();
      });
    } else {
      Swal.fire({
        title: "Thất bại!",
        text:  getMessageWithCode(responseData.code),
        icon: "error",
        confirmButtonText: "OK",
      }).then(async () => {
        location.reload();
      });
    }
  } catch (error) {
    console.error("Error fetching and displaying movies:", error);
  }
}
